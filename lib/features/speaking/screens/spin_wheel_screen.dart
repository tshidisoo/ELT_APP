import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/speaking_model.dart';
import '../../../core/services/user_service.dart';
import '../../../shared/blocs/auth_bloc.dart';

class SpinWheelScreen extends StatefulWidget {
  final SpeakingTopic topic;

  const SpinWheelScreen({super.key, required this.topic});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _spinAnimation;
  final _random = math.Random();

  bool _isSpinning = false;
  int _selectedIndex = -1;
  int _questionsAnswered = 0;
  int _xpEarned = 0;
  bool _xpAwarded = false;
  double _currentAngle = 0.0;

  static const List<Color> _segmentColors = [
    Color(0xFF0D9488), // teal
    Color(0xFF10B981), // green
    Color(0xFF06B6D4), // cyan
    Color(0xFFFF8C00), // orange
    Color(0xFFEF4444), // red
    Color(0xFF2DD4BF), // turquoise
    Color(0xFF0891B2), // dark cyan
    Color(0xFFFFD700), // gold
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _questions => widget.topic.spinWheelQuestions;

  void _spin() {
    if (_isSpinning || _questions.isEmpty) return;

    final questionCount = _questions.length;
    final targetIndex = _random.nextInt(questionCount);

    // Calculate target angle: current + 3–5 full rotations + land on target
    final fullRotations = (3 + _random.nextInt(3)) * 2 * math.pi;
    final segmentAngle = 2 * math.pi / questionCount;
    // The pointer is at top (12 o'clock). Each segment center is at its midpoint.
    // We want the targetIndex segment to land under the pointer.
    final targetAngle =
        (2 * math.pi) - (targetIndex * segmentAngle) - (segmentAngle / 2);
    final totalAngle = _currentAngle + fullRotations + targetAngle;

    _spinAnimation = Tween<double>(
      begin: _currentAngle,
      end: totalAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    setState(() {
      _isSpinning = true;
      _selectedIndex = -1;
    });

    _controller.reset();
    _controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _isSpinning = false;
          _currentAngle = totalAngle % (2 * math.pi);
          _selectedIndex = targetIndex;
        });
      }
    });
  }

  void _markAnswered() {
    setState(() {
      _questionsAnswered++;
      _xpEarned += widget.topic.xpReward ~/ 3;
      _selectedIndex = -1;
    });

    // Award XP after 3 questions answered
    if (_questionsAnswered >= 3 && !_xpAwarded) {
      _awardXp();
    }
  }

  Future<void> _awardXp() async {
    setState(() => _xpAwarded = true);
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      await UserService().awardXp(authState.user.uid, widget.topic.xpReward);
    }
  }

  void _done() {
    if (!_xpAwarded && _questionsAnswered > 0) {
      _awardXp();
    }
    Navigator.pop(context);
    if (_xpEarned > 0 || _questionsAnswered > 0) {
      _showCompletionSnackBar();
    }
  }

  void _showCompletionSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star_rounded, color: AppColors.xpGold),
            const SizedBox(width: 8),
            Text(
              'Great work! $_questionsAnswered questions answered. +${widget.topic.xpReward} XP earned!',
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.heroGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                      onPressed: _done,
                    ),
                    Expanded(
                      child: Text(
                        widget.topic.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // XP counter
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.xpGold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${_questionsAnswered * (widget.topic.xpReward ~/ 3)} XP',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Selected question card (shown after spin)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _selectedIndex >= 0
                    ? Padding(
                        key: ValueKey(_selectedIndex),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _QuestionResultCard(
                          question: _questions[_selectedIndex],
                          sentenceStarters: widget.topic.sentenceStarters,
                          onAnswered: _markAnswered,
                        ),
                      )
                    : Padding(
                        key: const ValueKey('placeholder'),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.casino_rounded,
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isSpinning
                                    ? 'Spinning...'
                                    : 'Press SPIN to get a question!',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // Wheel + pointer
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Pointer triangle
                      Positioned(
                        top: 0,
                        child: CustomPaint(
                          painter: _PointerPainter(),
                          size: const Size(30, 30),
                        ),
                      ),
                      // Spinning wheel
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final angle = _controller.isAnimating
                                ? _spinAnimation.value
                                : _currentAngle;
                            return Transform.rotate(
                              angle: angle,
                              child: child,
                            );
                          },
                          child: CustomPaint(
                            painter: SpinWheelPainter(
                              questions: _questions,
                              colors: _segmentColors,
                            ),
                            size: const Size(280, 280),
                          ),
                        ),
                      ),
                      // Center hub
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.mic_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Progress and bottom bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    // Progress indicator
                    if (_questionsAnswered > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            math.max(_questionsAnswered, 3),
                            (i) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: i < _questionsAnswered
                                    ? AppColors.xpGold
                                    : Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                    Row(
                      children: [
                        // SPIN button
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTap: _isSpinning || _selectedIndex >= 0
                                ? null
                                : _spin,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _isSpinning || _selectedIndex >= 0
                                      ? [Colors.grey, Colors.grey.shade600]
                                      : [
                                          const Color(0xFFFF8C00),
                                          const Color(0xFFFFAD40),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isSpinning || _selectedIndex >= 0
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: AppColors.secondary
                                              .withValues(alpha: 0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.casino_rounded,
                                        color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      _isSpinning ? 'Spinning...' : 'SPIN!',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Done button
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: _done,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                    color: Colors.white54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Done',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Question Result Card ─────────────────────────────────────────────────────

class _QuestionResultCard extends StatelessWidget {
  final String question;
  final List<String> sentenceStarters;
  final VoidCallback onAnswered;

  const _QuestionResultCard({
    required this.question,
    required this.sentenceStarters,
    required this.onAnswered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star prompt
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  color: AppColors.xpGold, size: 16),
              const SizedBox(width: 6),
              Text(
                'Answer in English!',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Question text
          Text(
            question,
            style: const TextStyle(
              color: AppColors.textPrimaryLight,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),

          // Sentence starters
          if (sentenceStarters.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: sentenceStarters.map((s) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 12),

          // "I answered" button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAnswered,
              icon: const Icon(Icons.check_circle_rounded, size: 18),
              label: const Text('I answered! Next question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Spin Wheel Painter ───────────────────────────────────────────────────────

class SpinWheelPainter extends CustomPainter {
  final List<String> questions;
  final List<Color> colors;

  SpinWheelPainter({required this.questions, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (questions.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final count = questions.length;
    final sweepAngle = 2 * math.pi / count;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Draw shadow
    canvas.drawCircle(
      center + const Offset(0, 4),
      radius,
      shadowPaint,
    );

    for (int i = 0; i < count; i++) {
      final startAngle = i * sweepAngle - math.pi / 2;
      final color = colors[i % colors.length];

      // Segment fill
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Segment border
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Draw text in segment
      final textAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.62;
      final textX = center.dx + textRadius * math.cos(textAngle);
      final textY = center.dy + textRadius * math.sin(textAngle);

      // Truncate question for display
      final rawLabel = questions[i];
      final label = rawLabel.length > 18
          ? '${rawLabel.substring(0, 15)}...'
          : rawLabel;

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.white,
            fontSize: count > 6 ? 9 : 11,
            fontWeight: FontWeight.w700,
            shadows: const [
              Shadow(
                color: Colors.black45,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout(maxWidth: radius * 0.7);

      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + math.pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Outer border ring
    final outerBorderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, outerBorderPaint);
  }

  @override
  bool shouldRepaint(SpinWheelPainter oldDelegate) =>
      oldDelegate.questions != questions || oldDelegate.colors != colors;
}

// ─── Pointer Painter ──────────────────────────────────────────────────────────

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    final shadowPath = Path()
      ..moveTo(size.width / 2, size.height + 2)
      ..lineTo(0, 2)
      ..lineTo(size.width, 2)
      ..close();

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PointerPainter oldDelegate) => false;
}

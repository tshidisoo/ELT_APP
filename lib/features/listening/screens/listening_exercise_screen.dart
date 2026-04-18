import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/listening_model.dart';
import '../../../core/services/listening_audio_service.dart';
import '../../../core/services/user_service.dart';
import '../../../shared/blocs/auth_bloc.dart';

class ListeningExerciseScreen extends StatefulWidget {
  final ListeningExercise exercise;

  const ListeningExerciseScreen({super.key, required this.exercise});

  @override
  State<ListeningExerciseScreen> createState() =>
      _ListeningExerciseScreenState();
}

class _ListeningExerciseScreenState extends State<ListeningExerciseScreen> {
  AudioPlayer? _player;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  final Set<String> _answeredIds = {};
  final Map<String, String?> _userAnswers = {};
  bool _xpAwarded = false;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _playerStateSub;
  String? _resolvedAudioUrl; // static url or teacher-uploaded url from Firestore

  @override
  void initState() {
    super.initState();
    _resolveAudioAndInit();
  }

  Future<void> _resolveAudioAndInit() async {
    // Prefer teacher-uploaded URL from Firestore; fall back to static URL
    final uploaded =
        await ListeningAudioService().getAudioUrl(widget.exercise.id);
    final url = uploaded ?? widget.exercise.audioUrl;
    if (url != null && mounted) {
      setState(() => _resolvedAudioUrl = url);
      _initAudio(url);
    }
  }

  Future<void> _initAudio(String url) async {
    _player = AudioPlayer();
    setState(() => _isLoading = true);
    try {
      await _player!.setUrl(url);
      _durationSub = _player!.durationStream.listen((d) {
        if (mounted) setState(() => _duration = d ?? Duration.zero);
      });
      _positionSub = _player!.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      _playerStateSub = _player!.playerStateStream.listen((state) {
        if (mounted) {
          setState(() => _isPlaying = state.playing);
        }
      });
    } catch (_) {
      // Audio load failed — handled in UI
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _player?.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_player == null) return;
    if (_isPlaying) {
      await _player!.pause();
    } else {
      await _player!.play();
    }
  }

  Future<void> _seekTo(double value) async {
    if (_player == null || _duration == Duration.zero) return;
    final target = Duration(
      milliseconds: (value * _duration.inMilliseconds).round(),
    );
    await _player!.seek(target);
  }

  void _answerQuestion(String questionId, String answer) {
    if (_answeredIds.contains(questionId)) return;
    setState(() {
      _userAnswers[questionId] = answer;
      _answeredIds.add(questionId);
    });

    // Check if all questions answered — award XP
    if (_answeredIds.length == widget.exercise.questions.length &&
        !_xpAwarded) {
      _awardXp();
    }
  }

  Future<void> _awardXp() async {
    setState(() => _xpAwarded = true);
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      await UserService().awardXp(authState.user.uid, widget.exercise.xpReward);
    }
  }

  Future<void> _openFlipbook() async {
    const url = 'https://online.flipbuilder.com/xtrvf/xncb/';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exercise = widget.exercise;
    final allAnswered = _answeredIds.length == exercise.questions.length &&
        exercise.questions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          exercise.title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Track label banner
            if (exercise.trackLabel != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.queue_music_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exercise.trackLabel!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Flipbook button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openFlipbook,
                icon: const Icon(Icons.menu_book_rounded),
                label: const Text('Open Textbook'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0EA5E9),
                  side: const BorderSide(color: Color(0xFF0EA5E9)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Audio player card — uses teacher-uploaded URL if available
            _AudioPlayerCard(
              audioUrl: _resolvedAudioUrl,
              isPlaying: _isPlaying,
              isLoading: _isLoading,
              position: _position,
              duration: _duration,
              onPlayPause: _togglePlay,
              onSeek: _seekTo,
              formatDuration: _formatDuration,
            ),

            const SizedBox(height: 14),

            // Transcript hint
            if (exercise.transcriptHint != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppColors.info, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exercise.transcriptHint!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 14),

            // Instructions
            Text(
              'Instructions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              exercise.instructions,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Questions
            if (exercise.questions.isNotEmpty) ...[
              Text(
                'Questions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...exercise.questions.asMap().entries.map((entry) {
                final idx = entry.key;
                final q = entry.value;
                return _QuestionCard(
                  index: idx + 1,
                  question: q,
                  userAnswer: _userAnswers[q.id],
                  isAnswered: _answeredIds.contains(q.id),
                  onAnswer: (answer) => _answerQuestion(q.id, answer),
                );
              }),
            ],

            const SizedBox(height: 16),

            // XP reward banner
            if (allAnswered)
              _XpBanner(
                xp: exercise.xpReward,
                awarded: _xpAwarded,
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Audio Player Card ────────────────────────────────────────────────────────

class _AudioPlayerCard extends StatelessWidget {
  final String? audioUrl;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onSeek;
  final String Function(Duration) formatDuration;

  const _AudioPlayerCard({
    required this.audioUrl,
    required this.isPlaying,
    required this.isLoading,
    required this.position,
    required this.duration,
    required this.onPlayPause,
    required this.onSeek,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (audioUrl == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.speaker_outlined,
                  color: AppColors.warning, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Audio Coming Soon',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your teacher will upload the audio for this exercise.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final progress =
        duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0EA5E9).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF0EA5E9).withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.music_note_rounded,
                    color: Color(0xFF0EA5E9), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Audio Player',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${formatDuration(position)} / ${formatDuration(duration)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF0EA5E9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF0EA5E9),
                  ),
                )
              else
                IconButton(
                  onPressed: onPlayPause,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    color: const Color(0xFF0EA5E9),
                    size: 44,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: onSeek,
            activeColor: const Color(0xFF0EA5E9),
            inactiveColor: const Color(0xFF0EA5E9).withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}

// ─── Question Card ────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final int index;
  final ListeningQuestion question;
  final String? userAnswer;
  final bool isAnswered;
  final ValueChanged<String> onAnswer;

  const _QuestionCard({
    required this.index,
    required this.question,
    required this.userAnswer,
    required this.isAnswered,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = isAnswered && userAnswer == question.correctAnswer;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAnswered
            ? (isCorrect
                ? AppColors.success.withValues(alpha: 0.06)
                : AppColors.error.withValues(alpha: 0.06))
            : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAnswered
              ? (isCorrect
                  ? AppColors.success.withValues(alpha: 0.4)
                  : AppColors.error.withValues(alpha: 0.4))
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isAnswered
                      ? (isCorrect ? AppColors.success : AppColors.error)
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isAnswered
                      ? Icon(
                          isCorrect
                              ? Icons.check_rounded
                              : Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          '$index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.question,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...question.options.map((option) {
            final isSelected = userAnswer == option;
            final isCorrectOption = option == question.correctAnswer;
            Color optionColor;
            if (!isAnswered) {
              optionColor = AppColors.primary;
            } else if (isCorrectOption) {
              optionColor = AppColors.success;
            } else if (isSelected && !isCorrectOption) {
              optionColor = AppColors.error;
            } else {
              optionColor = Colors.grey;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: OutlinedButton(
                    onPressed: isAnswered ? null : () => onAnswer(option),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isAnswered && isCorrectOption
                          ? AppColors.success.withValues(alpha: 0.12)
                          : isAnswered && isSelected && !isCorrectOption
                              ? AppColors.error.withValues(alpha: 0.08)
                              : null,
                      foregroundColor: optionColor,
                      side: BorderSide(
                        color: optionColor.withValues(
                          alpha: isAnswered ? 0.5 : 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontWeight: isSelected || isCorrectOption
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isAnswered && isCorrectOption)
                          const Icon(Icons.check_circle_rounded, size: 18)
                        else if (isAnswered && isSelected && !isCorrectOption)
                          const Icon(Icons.cancel_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Show correct answer if wrong
          if (isAnswered && !isCorrect && question.correctAnswer != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_rounded,
                      color: AppColors.success, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Correct answer: ${question.correctAnswer}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── XP Banner ────────────────────────────────────────────────────────────────

class _XpBanner extends StatelessWidget {
  final int xp;
  final bool awarded;

  const _XpBanner({required this.xp, required this.awarded});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.xpGold, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  awarded ? 'Exercise Complete!' : 'All Questions Answered!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                Text(
                  awarded
                      ? '+$xp XP added to your profile'
                      : 'Awarding $xp XP...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+$xp',
            style: const TextStyle(
              color: AppColors.xpGold,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

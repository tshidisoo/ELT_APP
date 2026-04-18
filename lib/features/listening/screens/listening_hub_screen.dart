import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/listening_model.dart';
import '../../../shared/blocs/auth_bloc.dart';
import '../../unit_lessons/data/ff1_content.dart';
import '../../unit_lessons/data/ff3_content.dart';

class ListeningHubScreen extends StatelessWidget {
  const ListeningHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final englishLevel =
        authState is AuthAuthenticated ? authState.user.englishLevel : '';

    // Filter exercises for this student's level
    final allExercises = [
      ...FF1Content.listeningExercises,
      ...FF3Content.listeningExercises,
    ].where((e) =>
            englishLevel.isEmpty ||
            e.level.toLowerCase() == englishLevel.toLowerCase())
        .toList();

    // Group by unit
    final Map<String, List<ListeningExercise>> grouped = {};
    for (final ex in allExercises) {
      grouped.putIfAbsent(ex.unit, () => []).add(ex);
    }
    // Sort each group by order
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => a.order.compareTo(b.order));
    }

    final unitOrder = ['Starter Unit', 'Unit 1', 'Unit 2', 'Unit 3'];
    final sortedUnits = grouped.keys.toList()
      ..sort((a, b) {
        final ai = unitOrder.indexOf(a);
        final bi = unitOrder.indexOf(b);
        if (ai == -1 && bi == -1) return a.compareTo(b);
        if (ai == -1) return 1;
        if (bi == -1) return -1;
        return ai.compareTo(bi);
      });

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ListeningHubHeader(level: englishLevel),
          ),
          if (allExercises.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(level: englishLevel),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final unit = sortedUnits[index];
                    final exercises = grouped[unit]!;
                    return _UnitSection(
                      unit: unit,
                      exercises: exercises,
                    );
                  },
                  childCount: sortedUnits.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ListeningHubHeader extends StatelessWidget {
  final String level;
  const _ListeningHubHeader({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 20,
        20,
        28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 24),
                onPressed: () => context.go(AppRoutes.studentHome),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.headphones_rounded,
                  color: Colors.white, size: 28),
              const SizedBox(width: 10),
              const Text(
                'Listening',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.volume_up_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Listen & Learn',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level.isNotEmpty ? level : 'English Listening Practice',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                        ),
                      ),
                    ],
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

// ─── Unit Section ─────────────────────────────────────────────────────────────

class _UnitSection extends StatelessWidget {
  final String unit;
  final List<ListeningExercise> exercises;

  const _UnitSection({required this.unit, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                unit,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${exercises.length} exercise${exercises.length == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...exercises.map((ex) => _ExerciseCard(exercise: ex)),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Exercise Card ────────────────────────────────────────────────────────────

class _ExerciseCard extends StatelessWidget {
  final ListeningExercise exercise;

  const _ExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAudio = exercise.audioUrl != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            context.go(AppRoutes.studentListeningExercise, extra: exercise),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.headphones_rounded,
                        color: Color(0xFF0EA5E9),
                        size: 26,
                      ),
                    ),
                    if (hasAudio)
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (exercise.trackLabel != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        exercise.trackLabel!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF0EA5E9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _PillBadge(
                          label:
                              '${exercise.questions.length} Q${exercise.questions.length == 1 ? '' : 's'}',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        _PillBadge(
                          label: '${exercise.xpReward} XP',
                          color: AppColors.xpGold,
                        ),
                        if (!hasAudio) ...[
                          const SizedBox(width: 6),
                          _PillBadge(
                            label: 'Audio soon',
                            color: AppColors.warning,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF0EA5E9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _PillBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String level;
  const _EmptyState({required this.level});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.headphones_outlined,
              size: 64,
              color: const Color(0xFF0EA5E9).withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No exercises yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              level.isNotEmpty
                  ? 'Listening exercises for "$level" will appear here.'
                  : 'Listening exercises will appear here once your teacher sets up your level.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

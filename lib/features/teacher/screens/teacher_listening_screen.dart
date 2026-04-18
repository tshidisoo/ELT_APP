import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/listening_model.dart';
import '../../../core/services/listening_audio_service.dart';
import '../../unit_lessons/data/ff1_content.dart';
import '../../unit_lessons/data/ff3_content.dart';

class TeacherListeningScreen extends StatelessWidget {
  const TeacherListeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).padding.top + 20, 20, 28),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.headphones_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Listening Audio',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          )),
                      Text('Upload audio for student exercises',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: StreamBuilder<Map<String, String>>(
          stream: ListeningAudioService().watchAudioUrls(),
          builder: (context, snapshot) {
            final audioUrls = snapshot.data ?? {};
            final exercises = [
              ...FF1Content.listeningExercises,
              ...FF3Content.listeningExercises,
            ];

            // Group by unit
            final units = exercises.map((e) => e.unit).toSet().toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                for (final unit in units) ...[
                  _UnitHeader(unit: unit),
                  const SizedBox(height: 8),
                  ...exercises
                      .where((e) => e.unit == unit)
                      .map((e) => _ExerciseAudioCard(
                            exercise: e,
                            uploadedUrl: audioUrls[e.id],
                          )),
                  const SizedBox(height: 16),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Unit Header ──────────────────────────────────────────────────────────────

class _UnitHeader extends StatelessWidget {
  final String unit;
  const _UnitHeader({required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_open_rounded,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(unit,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppColors.primary,
              )),
        ],
      ),
    );
  }
}

// ─── Exercise Audio Card ──────────────────────────────────────────────────────

class _ExerciseAudioCard extends StatefulWidget {
  final ListeningExercise exercise;
  final String? uploadedUrl;

  const _ExerciseAudioCard({
    required this.exercise,
    required this.uploadedUrl,
  });

  @override
  State<_ExerciseAudioCard> createState() => _ExerciseAudioCardState();
}

class _ExerciseAudioCardState extends State<_ExerciseAudioCard> {
  bool _uploading = false;
  bool _deleting = false;
  double _uploadProgress = 0;
  String? _error;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    setState(() {
      _uploading = true;
      _uploadProgress = 0;
      _error = null;
    });

    try {
      await ListeningAudioService().uploadAudio(
        exerciseId: widget.exercise.id,
        filePath: path,
        uploadedBy: uid,
        onProgress: (p) => setState(() => _uploadProgress = p),
      );
    } catch (e) {
      setState(() => _error = 'Upload failed: $e');
    } finally {
      setState(() => _uploading = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Audio'),
        content: const Text(
            'This will remove the audio file. Students will see "Audio coming soon" until a new file is uploaded.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove',
                  style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      await ListeningAudioService().deleteAudio(widget.exercise.id);
    } catch (e) {
      setState(() => _error = 'Delete failed: $e');
    } finally {
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAudio = widget.uploadedUrl != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row + audio status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.exercise.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      if (widget.exercise.trackLabel != null) ...[
                        const SizedBox(height: 2),
                        Text(widget.exercise.trackLabel!,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: hasAudio
                        ? AppColors.success.withValues(alpha: 0.12)
                        : AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasAudio
                            ? Icons.check_circle_rounded
                            : Icons.upload_rounded,
                        size: 12,
                        color: hasAudio ? AppColors.success : AppColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasAudio ? 'Audio uploaded' : 'No audio yet',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color:
                              hasAudio ? AppColors.success : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Stats row
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.quiz_rounded,
                    size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('${widget.exercise.questions.length} questions',
                    style: const TextStyle(fontSize: 11)),
                const SizedBox(width: 12),
                const Icon(Icons.star_rounded,
                    size: 12, color: AppColors.xpGold),
                const SizedBox(width: 4),
                Text('${widget.exercise.xpReward} XP',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.xpGold)),
              ],
            ),

            // Upload progress bar
            if (_uploading) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  minHeight: 6,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  valueColor:
                      const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text('Uploading ${(_uploadProgress * 100).toInt()}%...',
                  style: const TextStyle(fontSize: 11, color: AppColors.primary)),
            ],

            // Error message
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.error,
                      fontWeight: FontWeight.w600)),
            ],

            // Action buttons
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: (_uploading || _deleting) ? null : _pickAndUpload,
                    icon: _uploading
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.upload_file_rounded, size: 16),
                    label: Text(
                      _uploading
                          ? 'Uploading...'
                          : hasAudio
                              ? 'Replace Audio'
                              : 'Upload Audio',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                if (hasAudio) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: (_uploading || _deleting) ? null : _delete,
                    icon: _deleting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.delete_outline_rounded, size: 16),
                    label: const Text('Remove', style: TextStyle(fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

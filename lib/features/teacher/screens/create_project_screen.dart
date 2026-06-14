import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/project_service.dart';

class CreateProjectScreen extends StatefulWidget {
  final String teacherId;

  const CreateProjectScreen({super.key, required this.teacherId});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _linkCtrl = TextEditingController();
  final _thumbCtrl = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 14));
  final Set<String> _mediaAllowed = {'image', 'pdf', 'video', 'audio'};
  bool _saving = false;

  // 'media' = file/notes upload · 'link' = interactive link/game
  String _mode = 'media';
  bool get _isLink => _mode == 'link';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _linkCtrl.dispose();
    _thumbCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      if (_isLink) {
        await ProjectService().createLinkProject(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          dueDate: _dueDate,
          teacherId: widget.teacherId,
          linkUrl: _linkCtrl.text.trim(),
          thumbnailUrl: _thumbCtrl.text.trim().isEmpty
              ? null
              : _thumbCtrl.text.trim(),
        );
      } else {
        await ProjectService().createProject(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          dueDate: _dueDate,
          teacherId: widget.teacherId,
          mediaAllowed: _mediaAllowed.toList(),
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isLink
                ? '✅ Activity assigned successfully!'
                : '✅ Assignment created successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _formatDate(DateTime dt) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header decoration
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.secondaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.assignment_rounded,
                      color: Colors.white, size: 32),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Project',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      Text('Assign a project to your students',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Assignment type toggle
            Text('Assignment Type',
                style: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TypeToggle(
                    label: 'File Upload',
                    icon: Icons.upload_file_rounded,
                    selected: !_isLink,
                    onTap: () => setState(() => _mode = 'media'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeToggle(
                    label: 'Link / Game',
                    icon: Icons.videogame_asset_rounded,
                    selected: _isLink,
                    onTap: () => setState(() => _mode = 'link'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title
            Text('Assignment Title',
                style: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                hintText: _isLink
                    ? 'e.g. Past Simple — Wordwall Game'
                    : 'e.g. Past Simple Practice',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.title_rounded),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 20),

            // ── Link / game fields ───────────────────────────────────────────
            if (_isLink) ...[
              Text('Activity Link',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                'Paste a GitHub Pages, Wordwall, or any game/activity link. '
                'A preview thumbnail is generated automatically.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _linkCtrl,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://yourname.github.io/game/',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.link_rounded),
                ),
                validator: (v) {
                  if (!_isLink) return null;
                  final t = v?.trim() ?? '';
                  if (t.isEmpty) return 'Link is required';
                  final uri = Uri.tryParse(t);
                  if (uri == null || !uri.hasScheme || !uri.isAbsolute) {
                    return 'Enter a full URL starting with https://';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Custom Thumbnail (optional)',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                'Leave blank to auto-generate. Or paste an image URL to override.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _thumbCtrl,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://…/preview.png',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.image_rounded),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Description / instructions
            Text(_isLink ? 'Instructions (optional)' : 'Description',
                style: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(
              _isLink
                  ? 'Tell students what to do in the activity.'
                  : 'Describe the task, questions, and what to submit.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: _isLink ? 4 : 10,
              decoration: InputDecoration(
                hintText: _isLink
                    ? 'e.g. Play the game and beat your high score!'
                    : 'Describe the assignment brief, questions, and tasks…',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                alignLabelWithHint: true,
              ),
              validator: (v) {
                if (_isLink) return null; // optional for links
                return v == null || v.trim().isEmpty
                    ? 'Description is required'
                    : null;
              },
            ),
            const SizedBox(height: 20),

            // Due date picker
            Text('Due Date',
                style: theme.textTheme.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDueDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: theme.colorScheme.outline
                          .withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(_dueDate),
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Media allowed (file-upload assignments only)
            if (!_isLink) ...[
              Text('Accepted Media Types',
                  style: theme.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  _MediaToggle(
                    label: 'Images',
                    icon: Icons.image_rounded,
                    type: 'image',
                    selected: _mediaAllowed.contains('image'),
                    onToggle: (v) => setState(() => v
                        ? _mediaAllowed.add('image')
                        : _mediaAllowed.remove('image')),
                  ),
                  _MediaToggle(
                    label: 'PDF',
                    icon: Icons.picture_as_pdf_rounded,
                    type: 'pdf',
                    selected: _mediaAllowed.contains('pdf'),
                    onToggle: (v) => setState(() => v
                        ? _mediaAllowed.add('pdf')
                        : _mediaAllowed.remove('pdf')),
                  ),
                  _MediaToggle(
                    label: 'Video',
                    icon: Icons.videocam_rounded,
                    type: 'video',
                    selected: _mediaAllowed.contains('video'),
                    onToggle: (v) => setState(() => v
                        ? _mediaAllowed.add('video')
                        : _mediaAllowed.remove('video')),
                  ),
                  _MediaToggle(
                    label: 'Audio',
                    icon: Icons.mic_rounded,
                    type: 'audio',
                    selected: _mediaAllowed.contains('audio'),
                    onToggle: (v) => setState(() => v
                        ? _mediaAllowed.add('audio')
                        : _mediaAllowed.remove('audio')),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_rounded),
                label: Text(_saving
                    ? 'Creating…'
                    : _isLink
                        ? 'Assign Activity'
                        : 'Create Assignment'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Assignment Type Toggle ───────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeToggle({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 22, color: selected ? Colors.white : AppColors.primary),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Media Toggle Chip ────────────────────────────────────────────────────────

class _MediaToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final String type;
  final bool selected;
  final ValueChanged<bool> onToggle;

  const _MediaToggle({
    required this.label,
    required this.icon,
    required this.type,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 15,
                color: selected ? Colors.white : AppColors.primary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                )),
          ],
        ),
      ),
    );
  }
}

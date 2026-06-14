import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/project_service.dart';
import '../../../core/services/user_service.dart';

/// In-app player for "link" assignments (GitHub Pages games, Wordwall, etc.).
/// Loads the activity in a WebView and awards XP the first time it is opened
/// (play-only — no submission required).
class GamePlayerScreen extends StatefulWidget {
  final String projectId;
  final String studentId;
  final String url;
  final String title;

  const GamePlayerScreen({
    super.key,
    required this.projectId,
    required this.studentId,
    required this.url,
    required this.title,
  });

  @override
  State<GamePlayerScreen> createState() => _GamePlayerScreenState();
}

class _GamePlayerScreenState extends State<GamePlayerScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _xpAwarded = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
            _awardXpOnce();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _awardXpOnce() async {
    if (_xpAwarded) return;
    _xpAwarded = true;
    try {
      final user = await UserService().getUser(widget.studentId);
      final firstPlay = await ProjectService().markLinkPlayed(
        projectId: widget.projectId,
        studentId: widget.studentId,
        studentName: user?.displayName ?? 'Student',
      );
      if (firstPlay) {
        await UserService()
            .awardXp(widget.studentId, AppConstants.xpPerProjectSubmission);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '🎉 +${AppConstants.xpPerProjectSubmission} XP — activity opened!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ));
        }
      }
    } catch (_) {
      // XP is a bonus — never block playing the game on a failure here.
      _xpAwarded = false;
    }
  }

  Future<void> _openExternally() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            tooltip: 'Open in browser',
            icon: const Icon(Icons.open_in_browser_rounded),
            onPressed: _openExternally,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
        ],
      ),
    );
  }
}

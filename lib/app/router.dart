import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/blocs/auth_bloc.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/role_selection_screen.dart';
import '../features/home/screens/student_shell.dart';
import '../features/home/screens/home_screen.dart';
import '../features/unit_lessons/screens/unit_lessons_hub_screen.dart';
import '../features/unit_lessons/screens/unit_lesson_detail_screen.dart';
import '../core/models/unit_lesson_model.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/practice/screens/practice_screen.dart';
import '../features/projects/screens/student_projects_screen.dart';
import '../features/daily_challenge/screens/daily_challenge_screen.dart';
import '../features/piano/screens/piano_screen.dart';
import '../features/ear_training/screens/ear_training_hub_screen.dart';
import '../features/battle/screens/battle_lobby_screen.dart';
import '../features/teacher/screens/teacher_shell.dart';
import '../features/teacher/screens/teacher_dashboard_screen.dart';
import '../features/teacher/screens/teacher_projects_screen.dart';
import '../features/teacher/screens/teacher_submissions_screen.dart';
import '../features/teacher/screens/teacher_daily_schedule_screen.dart';
import '../features/teacher/screens/teacher_students_screen.dart';
import '../features/teacher/screens/teacher_listening_screen.dart';
import '../features/listening/screens/listening_hub_screen.dart';
import '../features/listening/screens/listening_exercise_screen.dart';
import '../features/speaking/screens/speaking_hub_screen.dart';
import '../features/speaking/screens/spin_wheel_screen.dart';
import '../core/models/listening_model.dart';
import '../core/models/speaking_model.dart';

// Route name constants
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const roleSelection = '/role-selection';
  static const studentHome = '/student/home';
  static const studentLessons = '/student/lessons';
  static const studentPractice = '/student/practice';
  static const studentProjects = '/student/projects';
  static const studentProfile = '/student/profile';
  static const studentDailyChallenge = '/student/daily-challenge';
  static const studentPiano = '/student/piano';
  static const studentEarTraining = '/student/ear-training';
  static const studentBattle = '/student/battle';
  static const studentListening = '/student/listening';
  static const studentListeningExercise = '/student/listening/exercise';
  static const studentSpeaking = '/student/speaking';
  static const studentSpeakingTopic = '/student/speaking/topic';
  static const teacherDashboard = '/teacher/dashboard';
  static const teacherStudents = '/teacher/students';
  static const teacherProjects = '/teacher/projects';
  static const teacherSubmissions = '/teacher/submissions';
  static const teacherDailySchedule = '/teacher/daily-schedule';
  static const unitLessonDetail = '/student/lessons/detail';
  static const teacherListening = '/teacher/listening';
}

GoRouter buildRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final loc = state.matchedLocation;

      // Splash is only valid while auth is still loading
      if (authState is AuthLoading || authState is AuthInitial) {
        return AppRoutes.splash;
      }

      // Auth resolved — never stay on splash
      if (loc == AppRoutes.splash) {
        if (authState is AuthAuthenticated) {
          return authState.user.isTeacher
              ? AppRoutes.teacherDashboard
              : AppRoutes.studentHome;
        }
        return AppRoutes.login;
      }

      final isOnAuthForm = loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.roleSelection;

      // Any error or unauthenticated → send to login (unless already there)
      if (authState is AuthError || authState is AuthUnauthenticated) {
        if (isOnAuthForm) return null;
        return AppRoutes.login;
      }

      if (authState is AuthAuthenticated) {
        final user = authState.user;
        if (isOnAuthForm) {
          return user.isTeacher
              ? AppRoutes.teacherDashboard
              : AppRoutes.studentHome;
        }
        if (user.isTeacher && loc.startsWith('/student')) {
          return AppRoutes.teacherDashboard;
        }
        if (user.isStudent && loc.startsWith('/teacher')) {
          return AppRoutes.studentHome;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RoleSelectionScreen(
            uid: extra?['uid'] ?? '',
            displayName: extra?['displayName'] ?? '',
            email: extra?['email'] ?? '',
            photoUrl: extra?['photoUrl'],
          );
        },
      ),
      // ── Student Shell ──────────────────────────────────────────────────────
      ShellRoute(
        builder: (_, state, child) => StudentShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.studentHome,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentLessons,
            builder: (_, __) => const UnitLessonsHubScreen(),
          ),
          GoRoute(
            path: AppRoutes.unitLessonDetail,
            builder: (_, state) {
              final lesson = state.extra as UnitLesson;
              return UnitLessonDetailScreen(lesson: lesson);
            },
          ),
          GoRoute(
            path: AppRoutes.studentPractice,
            builder: (_, __) => const PracticeScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentProjects,
            builder: (_, __) => const StudentProjectsScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentProfile,
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentDailyChallenge,
            builder: (_, __) => const DailyChallengeScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentPiano,
            builder: (_, __) => const PianoScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentEarTraining,
            builder: (_, __) => const EarTrainingHubScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentBattle,
            builder: (_, __) => const BattleLobbyScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentListening,
            builder: (_, __) => const ListeningHubScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentListeningExercise,
            builder: (_, state) {
              final exercise = state.extra as ListeningExercise;
              return ListeningExerciseScreen(exercise: exercise);
            },
          ),
          GoRoute(
            path: AppRoutes.studentSpeaking,
            builder: (_, __) => const SpeakingHubScreen(),
          ),
          GoRoute(
            path: AppRoutes.studentSpeakingTopic,
            builder: (_, state) {
              final topic = state.extra as SpeakingTopic;
              return SpinWheelScreen(topic: topic);
            },
          ),
        ],
      ),
      // ── Teacher Shell ──────────────────────────────────────────────────────
      ShellRoute(
        builder: (_, state, child) => TeacherShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.teacherDashboard,
            builder: (_, __) => const TeacherDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.teacherStudents,
            builder: (_, __) => const TeacherStudentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.teacherProjects,
            builder: (_, __) => const TeacherProjectsScreen(),
          ),
          GoRoute(
            path: AppRoutes.teacherSubmissions,
            builder: (_, __) => const TeacherAllSubmissionsScreen(),
          ),
          GoRoute(
            path: AppRoutes.teacherDailySchedule,
            builder: (_, __) => const TeacherDailyScheduleScreen(),
          ),
          GoRoute(
            path: AppRoutes.teacherListening,
            builder: (_, __) => const TeacherListeningScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
}

// Placeholder for screens not yet built
class _ComingSoonPage extends StatelessWidget {
  final String title;
  const _ComingSoonPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text('$title — Coming Soon',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('This feature is being built.',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// Helper to make GoRouter react to BLoC state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

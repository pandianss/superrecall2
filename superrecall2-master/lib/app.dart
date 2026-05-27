import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'data/repositories/catalog_repository.dart';
import 'features/study/domain/learning_models.dart';
import 'core/utils/logger.dart';
import 'features/study/presentation/home_page.dart';
import 'features/study/presentation/study_plan_screen.dart';
import 'features/study/presentation/daily_session_screen.dart';
import 'features/study/presentation/lesson_detail_screen.dart';
import 'features/study/presentation/splash_screen.dart';
import 'features/quiz/presentation/quiz_detail_screen.dart';
import 'features/study/presentation/drill_session_screen.dart';
import 'features/engagement/presentation/settings_screen.dart';
import 'features/engagement/presentation/profile_screen.dart';
import 'features/engagement/presentation/auth_screen.dart';
import 'features/engagement/presentation/analytics_dashboard_screen.dart';
import 'data/local/storage_service.dart';
import 'data/remote/sync_service.dart';
import 'features/study/state/srs_controller.dart';
import 'features/study/state/progress_controller.dart';
import 'features/study/state/learning_session_controller.dart';
import 'features/engagement/state/engagement_controller.dart';
import 'features/engagement/state/notification_controller.dart';
import 'features/ai/state/explanation_controller.dart';
import 'features/ai/state/ai_quiz_controller.dart';
import 'features/engagement/state/settings_controller.dart';
import 'features/engagement/state/notification_service.dart';
import 'features/ai/state/ai_service.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SuperRecallRoot(),
    ),
    GoRoute(
      path: '/study-plan/:examId',
      builder: (context, state) => StudyPlanScreen(
        examId: state.pathParameters['examId']!,
      ),
    ),
    GoRoute(
      path: '/daily-session/:examId',
      builder: (context, state) => DailySessionScreen(
        examId: state.pathParameters['examId']!,
      ),
    ),
    GoRoute(
      path: '/drill/:examId',
      builder: (context, state) => DrillSessionScreen(examId: state.pathParameters['examId']!),
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (context, state) => LessonDetailScreen(
        lessonId: state.pathParameters['lessonId']!,
      ),
    ),
    GoRoute(
      path: '/quiz/:quizId',
      builder: (context, state) => QuizDetailScreen(
        quizId: state.pathParameters['quizId']!,
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/analytics/:examId',
      builder: (context, state) {
        final examId = state.pathParameters['examId']!;
        final repo = context.read<CatalogRepository>();
        final exam = repo.getExam(examId)!;
        return AnalyticsDashboardScreen(exam: exam);
      },
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        final isLinking = state.uri.queryParameters['linking'] == 'true';
        return AuthScreen(isLinking: isLinking);
      },
    ),
  ],
);

class SuperRecallApp extends StatelessWidget {
  const SuperRecallApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.light.accentPrimary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.light.surfaceBase,
      textTheme: AppTypography.textTheme(AppColors.light.textPrimary),
      extensions: [AppColors.light],
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.dark.accentPrimary,
        brightness: Brightness.dark,
        surface: AppColors.dark.surfaceCard,
      ),
      scaffoldBackgroundColor: AppColors.dark.surfaceBase,
      textTheme: AppTypography.textTheme(AppColors.dark.textPrimary),
      extensions: [AppColors.dark],
    );

    return MultiProvider(
      providers: [
        Provider(create: (_) => StorageService()),
        ProxyProvider<StorageService, SyncService>(
          create: (context) => SyncService(context.read<StorageService>()),
          update: (context, storage, prev) => prev ?? SyncService(storage),
        ),
        ChangeNotifierProxyProvider2<StorageService, SyncService, SrsController>(
          create: (context) => SrsController(context.read<StorageService>(), context.read<SyncService>()),
          update: (context, storage, sync, prev) => prev ?? SrsController(storage, sync),
        ),
        ChangeNotifierProxyProvider2<StorageService, SyncService, EngagementController>(
          create: (context) => EngagementController(context.read<StorageService>(), context.read<SyncService>()),
          update: (context, storage, sync, prev) => prev ?? EngagementController(storage, sync),
        ),
        ChangeNotifierProxyProvider4<StorageService, SrsController, EngagementController, SyncService, ProgressController>(
          create: (context) => ProgressController(
            context.read<StorageService>(),
            context.read<SrsController>(),
            context.read<EngagementController>(),
            context.read<SyncService>(),
          ),
          update: (context, storage, srs, eng, sync, prev) => 
              prev ?? ProgressController(storage, srs, eng, sync),
        ),
        ChangeNotifierProxyProvider2<SrsController, ProgressController, LearningSessionController>(
          create: (context) => LearningSessionController(context.read<SrsController>(), context.read<ProgressController>()),
          update: (context, srs, prog, prev) => prev ?? LearningSessionController(srs, prog),
        ),
        Provider(create: (_) => NotificationService()),
        ChangeNotifierProxyProvider3<NotificationService, EngagementController, SrsController, NotificationController>(
          create: (context) => NotificationController(
            context.read<NotificationService>(),
            context.read<EngagementController>(),
            context.read<SrsController>(),
          ),
          update: (context, svc, eng, srs, prev) => prev ?? NotificationController(svc, eng, srs),
        ),
        ChangeNotifierProxyProvider<StorageService, SettingsController>(
          create: (context) => SettingsController(context.read<StorageService>()),
          update: (context, storage, prev) => prev ?? SettingsController(storage),
        ),
        ProxyProvider<SettingsController, AiService>(
          create: (context) => AiService(apiKey: context.read<SettingsController>().geminiApiKey),
          update: (context, settings, prev) {
            if (prev != null && prev.apiKey == settings.geminiApiKey) return prev;
            return AiService(apiKey: settings.geminiApiKey);
          },
        ),
        ChangeNotifierProxyProvider<AiService, ExplanationController>(
          create: (context) => ExplanationController(context.read<AiService>()),
          update: (context, ai, prev) => prev ?? ExplanationController(ai),
        ),
        ChangeNotifierProxyProvider<AiService, AiQuizController>(
          create: (context) => AiQuizController(context.read<AiService>()),
          update: (context, ai, prev) => prev ?? AiQuizController(ai),
        ),
        Provider(create: (_) => CatalogRepository()),
      ],
      child: MaterialApp.router(
        title: 'SuperRecall',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

class SuperRecallRoot extends StatefulWidget {
  const SuperRecallRoot({super.key});

  @override
  State<SuperRecallRoot> createState() => _SuperRecallRootState();
}

class _SuperRecallRootState extends State<SuperRecallRoot> {
  List<ExamCatalog>? _exams;
  ExamCatalog? _selectedExam;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _loadData();
      _isInit = true;
    }
  }

  Future<void> _loadData() async {
    try {
      final repo = context.read<CatalogRepository>();
      final srsController = context.read<SrsController>();
      final progressController = context.read<ProgressController>();
      final engagementController = context.read<EngagementController>();
      final notificationService = context.read<NotificationService>();
      final storageService = context.read<StorageService>();
      final settingsController = context.read<SettingsController>();
      final notificationController = context.read<NotificationController>();
      final syncService = context.read<SyncService>();

      // Storage is the foundation, initialize it first with a timeout
      try {
        await storageService.init().timeout(const Duration(seconds: 5));
        await syncService.initialize();
        await syncService.pullRemoteProgress();
      } catch (e) {
        AppLogger.error('Storage or Sync initialization failed', e);
      }

      // Start other tasks in parallel
      final results = await Future.wait([
        repo.fetchCatalogs(),
        notificationService.init(),
        settingsController.init(),
        srsController.init(),
        engagementController.init(),
        progressController.init(),
      ]).timeout(const Duration(seconds: 10), onTimeout: () => [[], null, null, null, null, null]);

      final exams = results[0] as List<ExamCatalog>;
      progressController.seedBaselines(exams);
      
      try {
        await notificationController.updateReminders();
      } catch (e) {
        AppLogger.error('Notification update failed', e);
      }

      if (mounted) {
        setState(() {
          _exams = exams;
          if (exams.isNotEmpty) {
            _selectedExam = exams.first;
          }
        });
      }
    } catch (e, st) {
      AppLogger.error('Fatal initialization error', e, st);
      if (mounted) {
        setState(() {
          _exams = [];
        });
      }
    }
  }

  void _openStudyPlan(BuildContext context) {
    if (_selectedExam == null) return;
    context.push('/study-plan/${_selectedExam!.id}');
  }

  @override
  Widget build(BuildContext context) {
    final srsController = context.watch<SrsController>();
    final progressController = context.watch<ProgressController>();
    final engagementController = context.watch<EngagementController>();

    if (_exams == null || !srsController.isLoaded || !progressController.isLoaded || !engagementController.isLoaded) {
      return const SplashScreen();
    }

    if (_exams!.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No catalogs available.'),
        ),
      );
    }

    return SuperRecallHomePage(
      exams: _exams!,
      selectedExam: _selectedExam!,
      monthsToGoal: progressController.monthsToGoal.toDouble(),
      onExamChanged: (value) {
        setState(() {
          _selectedExam = value;
        });
      },
      onMonthsChanged: (value) {
        progressController.setMonthsToGoal(value.round());
      },
      onBuildPlan: () => _openStudyPlan(context),
    );
  }
}

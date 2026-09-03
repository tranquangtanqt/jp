import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/error/error_screen.dart';
import '../../presentation/screens/exam/exam_lessons_screen.dart';
import '../../presentation/screens/exam/exam_quiz_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/kanji/kanji_categories_screen.dart';
import '../../presentation/screens/kanji/kanji_detail_screen.dart';
import '../../presentation/screens/kanji/kanji_quiz_screen.dart';
import '../../presentation/screens/main/main_screen.dart';
import '../../presentation/screens/setting/about_screen.dart';
import '../../presentation/screens/setting/setting_screen.dart';
import '../../presentation/screens/vocabulary/vocabulary_detail_screen.dart';
import '../../presentation/screens/vocabulary/vocabulary_levels_screen.dart';
import '../../presentation/screens/vocabulary/vocabulary_quiz_screen.dart';
import '../../presentation/screens/welcome/welcome_screen.dart';
import 'params/error_screen_param.dart';

/// Route paths
class AppRouteConst {
  static const splash = '/';
  static const home = '/home';
  static const vocabulary = '/vocabulary';
  static const kanji = '/kanji';
  static const exam = '/exam';
  static const setting = '/setting';
}

/// App routes
class AppRoutes {
  AppRoutes();

  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final navNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'nav');

  GoRouter? _router;

  GoRouter get router {
    _router ??= _initialize();
    return _router!;
  }

  GoRouter _initialize() {
    return GoRouter(
      initialLocation: AppRouteConst.splash,
      navigatorKey: rootNavigatorKey,
      errorBuilder: (context, state) => ErrorScreen(param: ErrorScreenParam(error: state.error)),
      redirect: (context, state) {
        if (state.uri.toString() == AppRouteConst.splash) {
          return AppRouteConst.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRouteConst.splash,
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/error',
          builder: (context, state) {
            final param = state.extra is ErrorScreenParam ? state.extra as ErrorScreenParam : ErrorScreenParam();

            return ErrorScreen(param: param);
          },
        ),
        _main(),
      ],
    );
  }

  ShellRoute _main() {
    return ShellRoute(
      navigatorKey: navNavigatorKey,
      builder: (context, state, child) => MainScreen(child: child),
      routes: [
        GoRoute(
          path: AppRouteConst.home,
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: HomeScreen()),
        ),
        GoRoute(
          path: AppRouteConst.vocabulary,
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: VocabularyLevelsScreen()),
          routes: [
            GoRoute(
              path: ':level',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => VocabularyDetailScreen(level: state.pathParameters['level']!),
              routes: [
                GoRoute(
                  path: 'quiz',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => VocabularyQuizScreen(
                    level: state.pathParameters['level']!,
                    mistakeMode: state.uri.queryParameters['mode'] == 'mistakes',
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRouteConst.kanji,
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: KanjiCategoriesScreen()),
          routes: [
            GoRoute(
              path: ':categoryId',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => KanjiDetailScreen(categoryId: state.pathParameters['categoryId']!),
              routes: [
                GoRoute(
                  path: 'quiz',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => KanjiQuizScreen(
                    categoryId: state.pathParameters['categoryId']!,
                    mistakeMode: state.uri.queryParameters['mode'] == 'mistakes',
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRouteConst.exam,
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: ExamLessonsScreen()),
          routes: [
            GoRoute(
              path: ':lesson/quiz',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => ExamQuizScreen(
                lesson: int.parse(state.pathParameters['lesson']!),
                mistakeMode: state.uri.queryParameters['mode'] == 'mistakes',
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRouteConst.setting,
          pageBuilder: (context, state) => const NoTransitionPage<void>(child: SettingScreen()),
          routes: [
            GoRoute(
              path: 'about',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const AboutScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

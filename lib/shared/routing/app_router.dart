import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/features/auth/presentation/pages/login_page.dart';
import 'package:shiharainu/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:shiharainu/features/event_creation/presentation/pages/event_creation_page.dart';
import 'package:shiharainu/features/payment/presentation/pages/payment_page.dart';
import 'package:shiharainu/features/gamification/presentation/pages/gamification_page.dart';
import 'package:shiharainu/features/secondary_event/presentation/pages/secondary_event_page.dart';
import 'package:shiharainu/shared/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = ref.read(isLoggedInProvider);
      final isGoingToLogin = state.matchedLocation == '/login';

      // ログインしていない場合は、ログインページ以外へのアクセスを制限
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }

      // ログインしている場合は、ログインページへのアクセスをダッシュボードにリダイレクト
      if (isLoggedIn && isGoingToLogin) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/event-creation',
        name: 'event-creation',
        builder: (context, state) => const EventCreationPage(),
      ),
      GoRoute(
        path: '/payment/:eventId',
        name: 'payment',
        builder: (context, state) => PaymentPage(
          eventId: state.pathParameters['eventId']!,
        ),
      ),
      GoRoute(
        path: '/gamification',
        name: 'gamification',
        builder: (context, state) => const GamificationPage(),
      ),
      GoRoute(
        path: '/secondary-event/:eventId',
        name: 'secondary-event',
        builder: (context, state) => SecondaryEventPage(
          eventId: state.pathParameters['eventId']!,
        ),
      ),
    ],
  );
});
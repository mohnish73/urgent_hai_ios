import 'package:go_router/go_router.dart';
import '../core/storage/hive_service.dart';

// Auth
import '../ui/splash/splash_screen.dart';
import '../ui/auth/onboard1_screen.dart';
import '../ui/auth/onboard2_screen.dart';
import '../ui/auth/onboard3_screen.dart';
import '../ui/auth/login_screen.dart';
import '../ui/auth/otp_screen.dart';
import '../ui/auth/signup_screen.dart';
import '../ui/auth/signup_success_screen.dart';

// Dashboard
import '../ui/dashboard/dashboard_screen.dart';

// Ride
import '../model/ride/book_ride_model.dart';
import '../ui/ride/ride_dashboard_screen.dart';
import '../ui/ride/ride_destination_screen.dart';
import '../ui/ride/book_ride_screen.dart';
import '../ui/ride/ride_details_screen.dart';
import '../ui/ride/locate_me_screen.dart';

// Parcel
import '../ui/parcel/parcel_dashboard_screen.dart';
import '../ui/parcel/parcel_destination_screen.dart';
import '../ui/parcel/book_parcel_screen.dart';
import '../ui/parcel/parcel_booking_req_screen.dart';
import '../ui/parcel/parcel_details_screen.dart';

// Store
import '../ui/store/store_dashboard_screen.dart';
import '../ui/store/categories_screen.dart';
import '../ui/store/products_screen.dart';
import '../ui/store/product_detail_screen.dart';
import '../ui/store/cart_screen.dart';
import '../ui/store/favourites_screen.dart';
import '../ui/store/order_screen.dart';
import '../ui/store/custom_order_screen.dart';

// Profile
import '../ui/profile/about_me_screen.dart';
import '../ui/profile/add_address_screen.dart';
import '../ui/profile/notifications_screen.dart';

// ─── Route Names ──────────────────────────────────────────
class AppRoutes {
  static const String splash = '/';
  static const String onboard1 = '/onboard1';
  static const String onboard2 = '/onboard2';
  static const String onboard3 = '/onboard3';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String signup = '/signup';
  static const String signupSuccess = '/signup-success';
  static const String dashboard = '/dashboard';
  static const String rideDashboard = '/ride';
  static const String rideDestination = '/ride/destination';
  static const String bookRide = '/ride/book';
  static const String rideDetails = '/ride/details';
  static const String locateMe = '/locate-me';
  static const String parcelDashboard = '/parcel';
  static const String parcelDestination = '/parcel/destination';
  static const String bookParcel = '/parcel/book';
  static const String parcelBookingReq = '/parcel/request';
  static const String parcelDetails = '/parcel/details';
  static const String storeDashboard = '/store';
  static const String categories = '/store/categories';
  static const String products = '/store/products';
  static const String productDetail = '/store/product-detail';
  static const String cart = '/store/cart';
  static const String favourites = '/store/favourites';
  static const String order = '/store/order';
  static const String customOrder = '/store/custom-order';
  static const String aboutMe = '/profile/about-me';
  static const String addAddress = '/profile/add-address';
  static const String notifications = '/profile/notifications';
}

// ─── Router ───────────────────────────────────────────────
class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = HiveService.isLoggedIn();
      final onboardingDone = HiveService.getOnboardingDone();
      final loc = state.matchedLocation;

      if (loc == AppRoutes.splash) return null;

      if (!onboardingDone &&
          loc != AppRoutes.onboard1 &&
          loc != AppRoutes.onboard2 &&
          loc != AppRoutes.onboard3) {
        return AppRoutes.onboard1;
      }
      if (!isLoggedIn && loc == AppRoutes.dashboard) {
        return AppRoutes.login;
      }
      return null;
    },
    routes: [
      // ── Splash ──
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),

      // ── Onboarding ──
      GoRoute(path: AppRoutes.onboard1, builder: (_, __) => const OnBoard1Screen()),
      GoRoute(path: AppRoutes.onboard2, builder: (_, __) => const OnBoard2Screen()),
      GoRoute(path: AppRoutes.onboard3, builder: (_, __) => const OnBoard3Screen()),

      // ── Auth ──
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, state) {
          final extra = state.extra as Map<String, String>;
          return OtpScreen(phone: extra['phone']!, id: extra['id']!);
        },
      ),
      GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupScreen()),
      GoRoute(
        path: AppRoutes.signupSuccess,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SignupSuccessScreen(
            userId: extra['userId'] as int,
            phone: extra['phone'] as String,
          );
        },
      ),

      // ── Main ──
      GoRoute(path: AppRoutes.dashboard, builder: (_, __) => const DashboardScreen()),

      // ── Ride ──
      GoRoute(path: AppRoutes.rideDashboard, builder: (_, __) => const RideDashboardScreen()),
      GoRoute(path: AppRoutes.rideDestination, builder: (_, __) => const RideDestinationScreen()),
      GoRoute(
        path: AppRoutes.bookRide,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return BookRideScreen(
            pickup: extra['pickup'] as String? ?? '',
            drop: extra['drop'] as String? ?? '',
            pickupLat: (extra['pickupLat'] as num?)?.toDouble() ?? 0.0,
            pickupLng: (extra['pickupLng'] as num?)?.toDouble() ?? 0.0,
            dropLat: (extra['dropLat'] as num?)?.toDouble() ?? 0.0,
            dropLng: (extra['dropLng'] as num?)?.toDouble() ?? 0.0,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.rideDetails,
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RideDetailsScreen(booking: extra['booking'] as BookRideData);
        },
      ),
      GoRoute(path: AppRoutes.locateMe, builder: (_, __) => const LocateMeScreen()),

      // ── Parcel ──
      GoRoute(path: AppRoutes.parcelDashboard, builder: (_, __) => const ParcelDashboardScreen()),
      GoRoute(path: AppRoutes.parcelDestination, builder: (_, __) => const ParcelDestinationScreen()),
      GoRoute(path: AppRoutes.bookParcel, builder: (_, __) => const BookParcelScreen()),
      GoRoute(path: AppRoutes.parcelBookingReq, builder: (_, __) => const ParcelBookingReqScreen()),
      GoRoute(path: AppRoutes.parcelDetails, builder: (_, __) => const ParcelDetailsScreen()),

      // ── Store ──
      GoRoute(path: AppRoutes.storeDashboard, builder: (_, __) => const StoreDashboardScreen()),
      GoRoute(path: AppRoutes.categories, builder: (_, __) => const CategoriesScreen()),
      GoRoute(path: AppRoutes.products, builder: (_, __) => const ProductsScreen()),
      GoRoute(path: AppRoutes.productDetail, builder: (_, __) => const ProductDetailScreen()),
      GoRoute(path: AppRoutes.cart, builder: (_, __) => const CartScreen()),
      GoRoute(path: AppRoutes.favourites, builder: (_, __) => const FavouritesScreen()),
      GoRoute(path: AppRoutes.order, builder: (_, __) => const OrderScreen()),
      GoRoute(path: AppRoutes.customOrder, builder: (_, __) => const CustomOrderScreen()),

      // ── Profile ──
      GoRoute(path: AppRoutes.aboutMe, builder: (_, __) => const AboutMeScreen()),
      GoRoute(path: AppRoutes.addAddress, builder: (_, __) => const AddAddressScreen()),
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),
    ],
  );
}

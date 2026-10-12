import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import toàn bộ các Provider
import 'provider/user_provider.dart';
import 'provider/movie_provider.dart';
import 'provider/booking_provider.dart';
import 'provider/seat_provider.dart';
import 'provider/food_previder.dart';
import 'provider/ticket_provider.dart';
import 'provider/showtime_provider.dart';
import 'provider/review_provider.dart';

// Import các Pages
import 'page/splash/splash_page.dart';
import 'page/login/login_page.dart';
import 'page/register/register_page.dart';
import 'page/home/home_page.dart';
import 'page/movie/movie_detail_page.dart';
import 'page/booking/booking_page.dart';
import 'page/seat/seat_page.dart';
import 'page/payment/payment_page.dart';
import 'page/profile/profile_page.dart';
import 'page/favorite/favorite_page.dart';
import 'page/ticket/ticket_history_page.dart';
import 'page/admin/room_management_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => SeatProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => ShowtimeProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: const MovieBookingApp(),
    ),
  );
}

class MovieBookingApp extends StatelessWidget {
  const MovieBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Booking',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),

      // Trả lại SplashPage làm màn hình bắt đầu
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/movie_detail': (context) => const MovieDetailPage(),
        '/booking': (context) => const BookingPage(),
        '/seat': (context) => const SeatPage(),
        '/payment': (context) => const PaymentPage(),
        '/profile': (context) => const ProfilePage(),
        '/favorite': (context) => const FavoritePage(),
        '/tickets': (context) => const TicketHistoryPage(),
        '/admin_room': (context) => const RoomManagementPage(),
      },
    );
  }
}
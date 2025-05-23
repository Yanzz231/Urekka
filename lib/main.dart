import 'package:marketplace_app/routers/app_router.dart';
import 'package:marketplace_app/widget/core/responsive_app_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class NoTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      builder: (context, child) => ResponsiveAppWrapper(
        child: child!,
        backgroundColor: const Color(0xFFFFFFFF),
        minWidth: 420.0,
        maxWidth: 580.0,
        idealAspectRatio: 9 / 16,
        minAspectRatio: 0.8,
        maxAspectRatio: 0.85,
        enableDebugOutline: kDebugMode && false,
      ),
      title: 'Ecommerce Apps',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
            .copyWith(
          background: Colors.white,
          surface: Colors.white,
        ),

        scaffoldBackgroundColor: Colors.white,

        cardTheme: const CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),

      ),

      routerConfig: router,
    );
  }
}
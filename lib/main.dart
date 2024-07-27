import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:projectx/values/app_constants.dart';
import 'package:projectx/values/app_routes.dart';
import 'package:projectx/views/add.dart';
import 'package:projectx/views/currencies.dart';
import 'package:projectx/views/home_screen.dart';
import 'package:projectx/views/restart.dart';
import 'package:projectx/views/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the saved currency from shared preferences
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('selectedCurrency')) {
    MainApp.selectedAppCurrency = prefs.getString('selectedCurrency')!;
  }

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: AppColors.statusBarColor),
  );
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ).then((_) => runApp(const RestartableApp(child: MainApp())));
}

class MainApp extends StatefulWidget {
  static String selectedAppCurrency = "ZAR";

  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool firstTimeRunning = true;

  @override
  void initState() {
    setTheme();
    super.initState();
  }

  void setTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('theme')) {
      setState(() {
        AppColors.theme = prefs.getBool('theme')!;
        AppColors();
      });
    } else {
      await prefs.setBool('theme', false);
    }
    if (prefs.containsKey('appRan')) {
      firstTimeRunning = false;
    } else {
      await prefs.setBool('appRan', true);
    }
    setState(() {});
  }

  void _resetApp() {
    if (mounted) {
      RestartableApp.restartApp(context);
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: AppConstants.navigationKey,
        routes: {
          AppRoutes.addScreen: (context) => const Add(),
          AppRoutes.homeScreen: (context) => const MainApp(),
          AppRoutes.currencyScreen: (context) => const CurrencyListScreen()
        },
        home: firstTimeRunning == true
            ? const OnboardingScreen()
            : const HomeScreen());
  }
}

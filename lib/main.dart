import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:projectx/utils/extensions.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:projectx/values/app_constants.dart';
import 'package:projectx/values/app_routes.dart';
import 'package:projectx/views/add.dart';
import 'package:projectx/views/currencies.dart';
import 'package:projectx/views/iou.dart';
import 'package:projectx/views/restart.dart';
import 'package:projectx/views/uome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/styles.dart';
import 'views/dashboard.dart';

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
  ).then(
    (_) => runApp(const RestartableApp(child: MainApp())),
  );
}

class MainApp extends StatefulWidget {
  static String selectedAppCurrency = "ZAR";

  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isSwitched = false;
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
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: AppColors.background,
              drawer: sideNav(),
              onDrawerChanged: (isOpened) {
                if (!isOpened) {
                  // _resetApp();
                }
              },
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: AppColors.background,
                title: const Text('IOU', style: logo),
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(54.0),
                    child: getTabBar()),
              ),
              body: SafeArea(
                  child: Column(
                children: <Widget>[Expanded(child: getTabs())],
              )),
            )));
  }

  void _toggleSwitch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', value);

    setState(() {
      AppColors.theme = prefs.getBool('theme')!;
      AppColors();
      isSwitched = prefs.getBool('theme')!;
    });
  }

  Widget mySwitch() {
    return Switch(
      value: AppColors.theme,
      onChanged: _toggleSwitch,
      activeTrackColor: AppColors.divider,
      activeColor: AppColors.orange,
    );
  }

  Widget sideNav() {
    return Container(
      color: AppColors.appBackgroundColor,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: AppColors.background,
            width: double.infinity,
            height: 200,
            child: Center(
                child: Image.asset('assets/logo.jpg', width: 120, height: 120)),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(color: AppColors.blackText, fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      mySwitch()
                    ],
                  )),
              Expanded(child: getItems())
            ],
          ))
        ],
      ),
    );
  }

  // sidenav options
  Widget getItems() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        List<IconData> icons = [Icons.info, Icons.currency_exchange];
        List<String> titles = ['Active Notifications', 'Currency'];
        return ListTile(
          onTap: () {
            switch (index) {
              case 1:
                AppRoutes.currencyScreen.pushName();
                setState(() {});
            }
          },
          leading: Icon(icons[index], color: AppColors.orange),
          title: Text(
            titles[index],
            style: TextStyle(color: AppColors.blackText, fontWeight: FontWeight.bold),
          ),
        );
      }),
      itemCount: 2,
    );
  }
}

// animation section for empty pages
Widget getAnimationSection(String message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      LottieBuilder.asset(
        'assets/empty.json',
        width: double.infinity,
        height: 300,
      ),
      const Text(
        "It's empty here ",
        style: TextStyle(color: Colors.grey, fontSize: 17),
      ),
      Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            message,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: AppColors.blackText),
          ))
    ],
  );
}

// floating action button
Widget getFloatingButton(int key) {
  return Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
        color: AppColors.orange, borderRadius: BorderRadius.circular(360)),
    child: IconButton(
        onPressed: () => handleNavigation(key),
        icon: Icon(
          Icons.add,
          color: AppColors.appBackgroundColor,
        )),
  );
}

// handles the title for the add new iou/uome page
void handleNavigation(int key) {
  switch (key) {
    case 0:
      navigateToAddScreen('Add UOMe');
      break;
    case 1:
      navigateToAddScreen('Add IOU');
      break;
  }
}

void navigateToAddScreen(String title) {
  Add.title = title;
  AppRoutes.addScreen.pushName();
}

// tab headers
Widget getTabBar() {
  return TabBar(
      labelStyle: headersDashboard,
      dividerColor: AppColors.statusBarColor,
      indicatorColor: AppColors.orange,
      unselectedLabelColor: Colors.grey,
      labelColor: AppColors.orange,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: const [
        Tab(text: 'Dashboard'),
        Tab(text: 'UOMe'),
        Tab(text: 'IOU')
      ]);
}

// tab sections
Widget getTabs() {
  return const TabBarView(
    children: [
      // dashboard
      Dashboard(),
      // oume
      Uome(),
      // iou
      Iou()
    ],
  );
}

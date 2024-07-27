import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projectx/main.dart';
import 'package:projectx/sqflite/handler.dart';
import 'package:projectx/utils/handle_table.dart';
import 'package:projectx/utils/pie_chart.dart';
import 'package:projectx/utils/styles.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

/// This is the main dashboard screen of the application.
/// It displays the net balance, remaining balance, and a list of balances for IOU and UOMe.
/// It also includes a pie chart to visualize the distribution of debt and credit.

class Dashboard extends StatefulWidget {
  // Static variables to hold data for the dashboard
  static bool uomeHasData = false;
  static bool iouHasData = false;
  static double netBalance = 0.0;
  static double remainingBalance = 0.0;
  static double debt = 0.0;
  static double credit = 0.0;
  static late List<Map<String, Object?>> debtRows, creditRows;
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    setTheme();
    getTables();
    super.initState();
  }
  void setTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('theme')) {
      AppColors.theme = prefs.getBool('theme')!;
      AppColors();
    }
  }

  /// Initializes the database and checks for the existence of 'UOMe' and 'IOU' tables.
  Future<void> initializeDatabase() async {
    var dbHelper = DatabaseHelper.instance;
    await dbHelper.initDatabase();
  }

  /// Calls initializeDatabase and handles the table checks.
  void getTables() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('tablesCreated')) {
      await HandleTable().checkTable('UOMe');
      await HandleTable().checkTable('IOU');
    } else {
      await initializeDatabase();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setTheme();
    // Build the dashboard UI
    return Scaffold(
        backgroundColor: AppColors.waveBackgroundColor,
        body: Column(
          children: [
            Container(
                height: 150.0,
                color: AppColors.waveBackgroundColor,
                child: getBalanceContainer(
                    Dashboard.netBalance, Dashboard.remainingBalance)),
            Container(
              color: AppColors.waveBackgroundColor,
              height: 80.0,
              child: getWave(),
            ),
            const Divider(
              color: Colors.grey,
              height: 0.1,
              thickness: 0.1,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              color: AppColors.appBackgroundColor,
              child: Column(
                children: [
                  Dashboard.uomeHasData == true || Dashboard.iouHasData == true
                      ? displayPieContainer()
                      : getStartedContainer(),
                  Expanded(
                      child: getBalanceList(Dashboard.debt, Dashboard.credit,
                          Dashboard.remainingBalance))
                ],
              ),
            ))
          ],
        ));
  }

  // displays the pie chart with the keys
  Widget displayPieContainer() {
    return Container(
        padding: const EdgeInsets.all(20.0),
        height: 160,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(child: getPie()),
          const SizedBox(
            width: 50.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getKey(AppColors.orange, 'IOU'),
              getKey(AppColors.pieDark, 'UOMe')
            ],
          )
        ]));
  }

  // displays the get started container
  Widget getStartedContainer() {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LottieBuilder.asset(
            'assets/slide.json',
          ),
          const Text(
            'Swipe left to get started',
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }

  // pie chart container
  Widget getPie() {
    return AnimatedPie(value1: Dashboard.debt, value2: Dashboard.credit);
  }

  // pie chart key
  Widget getKey(Color color, String key) {
    return Row(children: [
      Icon(
        Icons.circle_outlined,
        color: color,
        size: 15.0,
      ),
      Text(key, style: TextStyle(color: AppColors.blackText, fontWeight: FontWeight.bold))
    ]);
  }

  // balances showcase container
  Widget getBalanceList(double debt, double credit, double remainingBalance) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemBuilder: ((context, index) {
        List<String> titles = ['IOU', 'UOMe'];
        List<double> amounts = [debt, credit];
        List<Color> colors = [AppColors.orange, AppColors.pieDark];
        return InkWell(
            child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider, width: 0.5),
            color: AppColors.divider,
          ),
          child: Row(
            children: [
              getColorTag(colors, index),
              const SizedBox(width: 15.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[index], style: TextStyle(color: AppColors.blackText, fontSize: 17, fontWeight: FontWeight.bold)),
                  Text(
                      '${MainApp.selectedAppCurrency} ${amounts[index].toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey),),
                  Text(
                    'Remaining ${MainApp.selectedAppCurrency}  ${remainingBalance.toStringAsFixed(2)}',
                    style: TextStyle(color: AppColors.red),
                  )
                ],
              )
            ],
          ),
        ));
      }),
      itemCount: 2,
    );
  }

// balance container
  Widget getBalanceContainer(double netBalance, double remainingBalance) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Net Balance',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            netBalance.toStringAsFixed(2),
            style: amountHeader,
          ),
          Text(
            'Remaining ${remainingBalance.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

// the wave container
  Widget getWave() {
    return WaveWidget(
      config: CustomConfig(
        colors: [AppColors.divider, AppColors.appBackgroundColor],
        durations: [3500, 1944],
        heightPercentages: [0.25, 0.35],
      ),
      waveAmplitude: 0,
      size: const Size(double.infinity, 80.0),
    );
  }

// color tag
  Widget getColorTag(List<Color> colors, int index) {
    return Container(
      height: 50.0,
      width: 7.0,
      decoration: BoxDecoration(
          color: colors[index],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0))),
    );
  }
}

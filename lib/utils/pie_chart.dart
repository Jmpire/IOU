import 'package:flutter/material.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnimatedPie extends StatefulWidget {
  final double value1, value2;
  const AnimatedPie({super.key, required this.value1, required this.value2});

  @override
  State<AnimatedPie> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPie> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120.0,
        child: SfCircularChart(
          palette: [AppColors.orange, AppColors.pieDark],
          series: <CircularSeries>[
            DoughnutSeries<AmountData, String>(
              radius: '130%',
              innerRadius: '70%',
              // Bind data source
              dataSource: <AmountData>[
                AmountData('Debt', widget.value1),
                AmountData('Credit', widget.value2),
              ],
              xValueMapper: (AmountData amount, _) => amount.type,
              yValueMapper: (AmountData amount, _) => amount.amount,
              dataLabelSettings: const DataLabelSettings(isVisible: false),
            )
          ],
        ));
  }
}

class AmountData {
  AmountData(this.type, this.amount);
  final String type;
  final double amount;
}

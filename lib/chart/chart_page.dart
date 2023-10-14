import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_demo/chart/water_bar_demo.dart';

class MonthlyExpense {
  final String month;
  final double spent;
  final double earned;
  const MonthlyExpense({
    required this.month,
    required this.spent,
    required this.earned,
  });
}

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final monthlyExpensesFirstHalf = [
    const MonthlyExpense(month: 'Jan', spent: 300.0, earned: 0),
    const MonthlyExpense(month: 'Feb', spent: 800.0, earned: 0),
    const MonthlyExpense(month: 'Mar', spent: 600.0, earned: 0),
    const MonthlyExpense(month: 'Apr', spent: 300.0, earned: 0),
    const MonthlyExpense(month: 'May', spent: 400.0, earned: 0),
    const MonthlyExpense(month: 'Jun', spent: 200.0, earned: 0)
  ];
  final monthlyExpensesSecondHalf = [
    const MonthlyExpense(month: 'Jul', spent: 700.0, earned: 0),
    const MonthlyExpense(month: 'Aug', spent: 300.0, earned: 0),
    const MonthlyExpense(month: 'Sep', spent: 400.0, earned: 0),
    const MonthlyExpense(month: 'Oct', spent: 600.0, earned: 0),
    const MonthlyExpense(month: 'Nov', spent: 550.0, earned: 0),
    const MonthlyExpense(month: 'Dec', spent: 400.0, earned: 0),
  ];

  Artboard? artboard;
  StateMachineController? controller;

  TextValueRun? bar1TooltipLabel;
  TextValueRun? bar2TooltipLabel;
  TextValueRun? bar3TooltipLabel;
  TextValueRun? bar4TooltipLabel;
  TextValueRun? bar5TooltipLabel;
  TextValueRun? bar6TooltipLabel;

  TextValueRun? month1Lable;
  TextValueRun? month2Lable;
  TextValueRun? month3Lable;
  TextValueRun? month4Lable;
  TextValueRun? month5Lable;
  TextValueRun? month6Lable;

  TextValueRun? maxValueLabel;
  TextValueRun? midValueLabel;

  SMIInput<double>? bar1Input;
  SMIInput<double>? bar2Input;
  SMIInput<double>? bar3Input;
  SMIInput<double>? bar4Input;
  SMIInput<double>? bar5Input;
  SMIInput<double>? bar6Input;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff0A84FF),
      child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          RiveAnimation.asset(
            'assets/onboarding.riv',
            artboard: 'chart',
            useArtboardSize: true,
            onInit: (artboard) {
              this.artboard = artboard;
              final controller = StateMachineController.fromArtboard(
                  artboard, 'State Machine 1')!;
              this.controller = controller;

              // run the state machine
              artboard.addController(controller);
              maxValueLabel = artboard.textRun('max value')!;
              midValueLabel = artboard.textRun('mid value')!;

              // Set month texts
              month1Lable = artboard.textRun('month1')!;
              month2Lable = artboard.textRun('month2')!;
              month3Lable = artboard.textRun('month3')!;
              month4Lable = artboard.textRun('month4')!;
              month5Lable = artboard.textRun('month5')!;
              month6Lable = artboard.textRun('month6')!;

              // Set tooltip texts
              bar1TooltipLabel = artboard.textRun('bar 1 tooltip')!;
              bar2TooltipLabel = artboard.textRun('bar 2 tooltip')!;
              bar3TooltipLabel = artboard.textRun('bar 3 tooltip')!;
              bar4TooltipLabel = artboard.textRun('bar 4 tooltip')!;
              bar5TooltipLabel = artboard.textRun('bar 5 tooltip')!;
              bar6TooltipLabel = artboard.textRun('bar 6 tooltip')!;

              // Set bar inputs
              bar1Input = controller.findInput('bar1');
              bar2Input = controller.findInput('bar2');
              bar3Input = controller.findInput('bar3');
              bar4Input = controller.findInput('bar4');
              bar5Input = controller.findInput('bar5');
              bar6Input = controller.findInput('bar6');

              updateChart(monthlyExpensesFirstHalf);
            },
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        updateChart(monthlyExpensesFirstHalf);
                      },
                      child: const Text(
                        'Show First Half',
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () {
                        updateChart(monthlyExpensesSecondHalf);
                      },
                      child: const Text(
                        'Show Second Half',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WaterBarDemo()));
                  },
                  child: const Text('View Water Bar'))
            ],
          )
        ],
      ),
    );
  }

  void updateChart(List<MonthlyExpense> expenses) {
    bar1Input?.value = 0;
    bar2Input?.value = 0;
    bar3Input?.value = 0;
    bar4Input?.value = 0;
    bar5Input?.value = 0;
    bar6Input?.value = 0;

    artboard?.removeController(controller!);
    artboard?.addController(controller!);

    month1Lable?.text = expenses.first.month;
    month2Lable?.text = expenses[1].month;
    month3Lable?.text = expenses[2].month;
    month4Lable?.text = expenses[3].month;
    month5Lable?.text = expenses[4].month;
    month6Lable?.text = expenses[5].month;

    bar1TooltipLabel?.text = '\$${expenses.first.spent}';
    bar2TooltipLabel?.text = '\$${expenses[1].spent}';
    bar3TooltipLabel?.text = '\$${expenses[2].spent}';
    bar4TooltipLabel?.text = '\$${expenses[3].spent}';
    bar5TooltipLabel?.text = '\$${expenses[4].spent}';
    bar6TooltipLabel?.text = '\$${expenses[5].spent}';

    // sort expenses
    final sortedExpensed = List.of(expenses);
    sortedExpensed.sort((p1, p2) => p1.spent.compareTo(p2.spent));
    final maxSpentValue = sortedExpensed.last.spent;

    // set max line value
    maxValueLabel?.text = '\$$maxSpentValue';

    // set midline value
    midValueLabel?.text = '\$${(maxSpentValue / 2).toStringAsFixed(0)}';

    // set each bar percentage value
    bar1Input?.value = (expenses.first.spent / maxSpentValue) * 100;
    bar2Input?.value = (expenses[1].spent / maxSpentValue) * 100;
    bar3Input?.value = (expenses[2].spent / maxSpentValue) * 100;
    bar4Input?.value = (expenses[3].spent / maxSpentValue) * 100;
    bar5Input?.value = (expenses[4].spent / maxSpentValue) * 100;
    bar6Input?.value = (expenses[5].spent / maxSpentValue) * 100;
  }
}

extension _TextExtension on Artboard {
  TextValueRun? textRun(String name) => component<TextValueRun>(name);
}

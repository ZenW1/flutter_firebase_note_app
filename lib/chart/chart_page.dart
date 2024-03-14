import 'package:flutter/material.dart';
import 'package:jong_jam/chart/line_chart.dart';
import 'package:jong_jam/chart/pie_chart_sample.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  static String routePath = '/chart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Center(
          //   child: Stack(
          //     children: [
          //       Container(
          //         height: 200,
          //         width: 200,
          //         child: Padding(
          //           padding: const EdgeInsets.all(30.0),
          //           child: CircularProgressIndicator.adaptive(
          //             value: 0.8,
          //             strokeWidth: 5,
          //             valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          //             semanticsLabel: 'Linear progress indicator',
          //             semanticsValue: '50%',
          //             backgroundColor: Colors.grey,
          //           ),
          //         ),
          //       ),
          //       Positioned(top: 60, left: 70, child: Text('80%')),
          //     ],
          //   ),
          // ),
          PieChartSample3(),
          SizedBox(
            height: 20,
          ),
          LineChartSample2()
        ],
      ),
    );
  }
}

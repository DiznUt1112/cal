import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatefulWidget {
  final List<Map<String, dynamic>> historyData;

  GraphPage({required this.historyData});

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  String? selectedName;
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    if (widget.historyData.isNotEmpty) {
      selectedName = widget.historyData[0]['name'];
      filterData();
    }
  }

  void filterData() {
    setState(() {
      filteredData = widget.historyData
          .where((data) => data['name'] == selectedName)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("กราฟแสดงแคลอรี่"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text("เลือกชื่อ"),
              value: selectedName,
              items: widget.historyData.map((data) {
                return DropdownMenuItem<String>(
                  value: data['name'],
                  child: Text(data['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedName = value;
                  filterData();
                });
              },
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1500,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String weekDay;
                        switch (group.x.toInt()) {
                          case 0:
                            weekDay = 'Monday';
                            break;
                          case 1:
                            weekDay = 'Tuesday';
                            break;
                          case 2:
                            weekDay = 'Wednesday';
                            break;
                          case 3:
                            weekDay = 'Thursday';
                            break;
                          case 4:
                            weekDay = 'Friday';
                            break;
                          case 5:
                            weekDay = 'Saturday';
                            break;
                          case 6:
                            weekDay = 'Sunday';
                            break;
                          default:
                            throw Error();
                        }
                        return BarTooltipItem(
                          '$weekDay\n',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '${rod.toY} kcal',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'M';
                              break;
                            case 1:
                              text = 'T';
                              break;
                            case 2:
                              text = 'W';
                              break;
                            case 3:
                              text = 'T';
                              break;
                            case 4:
                              text = 'F';
                              break;
                            case 5:
                              text = 'S';
                              break;
                            case 6:
                              text = 'S';
                              break;
                            default:
                              text = '';
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value % 500 == 0) {
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: filteredData.map((data) {
                    return BarChartGroupData(
                      x: filteredData.indexOf(data),
                      barRods: [
                        BarChartRodData(
                          toY: double.parse(data['calories'].toStringAsFixed(0)),
                          color: Colors.yellow,
                        )
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

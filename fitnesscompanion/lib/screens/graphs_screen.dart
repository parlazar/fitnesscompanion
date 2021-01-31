import 'package:fitnesscompanion/api/firebase_api.dart';
import 'package:fitnesscompanion/models/meal_graph.dart';
import 'package:fitnesscompanion/models/points_graph.dart';
import 'package:fitnesscompanion/models/water_graph.dart';
import 'package:fitnesscompanion/models/workout_graph.dart';
import 'package:fitnesscompanion/notifiers/date_of_reg_notifier.dart';
import 'package:fitnesscompanion/widgets/color_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphsScreen extends StatefulWidget {
  @override
  _GraphsScreenState createState() => _GraphsScreenState();
}

class _GraphsScreenState extends State<GraphsScreen> {
  DateTime fromDate;
  DateTime toDate;
  int _groupValue;
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    DateOfRegNotifier dateOfRegNotifier =
        Provider.of<DateOfRegNotifier>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Neumorphic(
            padding: EdgeInsets.all(8),
            style: NeumorphicStyle(
              depth: -8,
              border: NeumorphicBorder(
                  isEnabled: true, color: Colors.white, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: NeumorphicButton(
                    style: NeumorphicStyle(shape: NeumorphicShape.flat),
                    child: NeumorphicText(
                      (fromDate == null)
                          ? 'From: '
                          : 'From: ' +
                              fromDate.day.toString() +
                              '/' +
                              fromDate.month.toString() +
                              '/' +
                              fromDate.year.toString(),
                      textStyle: NeumorphicTextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      style: NeumorphicStyle(color: Colors.pink),
                    ),
                    onPressed: () {
                      List<String> split =
                          dateOfRegNotifier.dateOfReg.split('/');
                      if (DateTime.parse(split[2] + split[1] + split[0])
                          .isBefore(
                              DateTime.now().subtract(Duration(days: 1)))) {
                        if (DateTime(DateTime.now().year, DateTime.now().month)
                            .isBefore(
                                DateTime.now().subtract(Duration(days: 1)))) {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime(DateTime.now().year,
                                      DateTime.now().month),
                                  firstDate: DateTime.parse(
                                      split[2] + split[1] + split[0]),
                                  lastDate: DateTime.now()
                                      .subtract(Duration(days: 1)))
                              .then((value) {
                            setState(() {
                              fromDate = value;
                            });
                          });
                        } else {
                          if (DateTime.now().month != DateTime.january) {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime(DateTime.now().year,
                                        DateTime.now().month - 1),
                                    firstDate: DateTime.parse(
                                        split[2] + split[1] + split[0]),
                                    lastDate: DateTime.now()
                                        .subtract(Duration(days: 1)))
                                .then((value) {
                              setState(() {
                                fromDate = value;
                              });
                            });
                          } else {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime(DateTime.now().year-1,
                                        DateTime.december),
                                    firstDate: DateTime.parse(
                                        split[2] + split[1] + split[0]),
                                    lastDate: DateTime.now()
                                        .subtract(Duration(days: 1)))
                                .then((value) {
                              setState(() {
                                fromDate = value;
                              });
                            });
                          }
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: NeumorphicButton(
                    style: NeumorphicStyle(shape: NeumorphicShape.flat),
                    child: NeumorphicText(
                      (toDate == null)
                          ? 'To: '
                          : 'To: ' +
                              toDate.day.toString() +
                              '/' +
                              toDate.month.toString() +
                              '/' +
                              toDate.year.toString(),
                      textStyle: NeumorphicTextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      style: NeumorphicStyle(color: Colors.pink),
                    ),
                    onPressed: () {
                      List<String> split =
                          dateOfRegNotifier.dateOfReg.split('/');
                      if (DateTime.parse(split[2] + split[1] + split[0])
                          .isBefore(
                              DateTime.now().subtract(Duration(days: 1)))) {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime(
                                    DateTime.now().year, DateTime.now().month),
                                firstDate: DateTime.parse(
                                    split[2] + split[1] + split[0]),
                                lastDate: DateTime.now())
                            .then((value) {
                          setState(() {
                            toDate = value;
                          });
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NeumorphicRadio(
                value: 1,
                style: NeumorphicRadioStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                ),
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value;
                  });
                },
                padding: EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/meal_icon.png',
                  scale: 8,
                ),
              ),
              SizedBox(width: 12),
              NeumorphicRadio(
                value: 2,
                style: NeumorphicRadioStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                ),
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value;
                  });
                },
                padding: EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/workout_icon.png',
                  scale: 8,
                ),
              ),
              SizedBox(width: 12),
              NeumorphicRadio(
                style: NeumorphicRadioStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                ),
                groupValue: _groupValue,
                value: 3,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value;
                  });
                },
                padding: EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/water_icon.png',
                  scale: 8,
                ),
              ),
              SizedBox(width: 12),
              NeumorphicRadio(
                style: NeumorphicRadioStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                ),
                groupValue: _groupValue,
                value: 4,
                onChanged: (value) {
                  setState(() {
                    _groupValue = value;
                  });
                },
                padding: EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/star_icon.png',
                  scale: 8,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 32,
          ),
          if (_groupValue == 1)
            Expanded(
              child: Neumorphic(
                padding: EdgeInsets.all(8),
                style: NeumorphicStyle(depth: -8),
                child: FutureBuilder(
                  future: getMealVars(fromDate, toDate),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: PageView(
                          controller: controller,
                          children: [
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              series: <ChartSeries<MealGraph, String>>[
                                LineSeries<MealGraph, String>(
                                  color: Colors.green,
                                  dataSource: snapshot.data,
                                  xValueMapper: (MealGraph item, _) =>
                                      item.mealDate,
                                  yValueMapper: (MealGraph item, _) =>
                                      item.totalCals,
                                ),
                              ],
                            ),
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              series: <ChartSeries<MealGraph, String>>[
                                BarSeries<MealGraph, String>(
                                  color: Colors.red,
                                  dataSource: snapshot.data,
                                  xValueMapper: (MealGraph item, _) =>
                                      item.mealDate,
                                  yValueMapper: (MealGraph item, _) =>
                                      item.totalProteins,
                                ),
                                BarSeries<MealGraph, String>(
                                  color: Colors.indigo,
                                  dataSource: snapshot.data,
                                  xValueMapper: (MealGraph item, _) =>
                                      item.mealDate,
                                  yValueMapper: (MealGraph item, _) =>
                                      item.totalCarbs,
                                ),
                                BarSeries<MealGraph, String>(
                                  color: Colors.amber,
                                  dataSource: snapshot.data,
                                  xValueMapper: (MealGraph item, _) =>
                                      item.mealDate,
                                  yValueMapper: (MealGraph item, _) =>
                                      item.totalFats,
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      if (toDate == null || fromDate == null) {
                        return Center(child: Text('Select dates'));
                      } else
                        return Center(
                          child: ColorLoader(
                            color1: Colors.green,
                            color2: Colors.orange,
                            color3: Colors.blue,
                          ),
                        );
                    }
                  },
                ),
              ),
            )
          else if (_groupValue == 2)
            Expanded(
              child: Neumorphic(
                padding: EdgeInsets.all(8),
                style: NeumorphicStyle(depth: -8),
                child: FutureBuilder(
                  future: getWorkoutVars(fromDate, toDate),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: PageView(
                          controller: controller,
                          children: [
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              series: <ChartSeries<WorkoutGraph, String>>[
                                LineSeries<WorkoutGraph, String>(
                                  color: Colors.orange,
                                  dataSource: snapshot.data,
                                  xValueMapper: (WorkoutGraph item, _) =>
                                      item.workoutDate,
                                  yValueMapper: (WorkoutGraph item, _) =>
                                      item.burnedCals,
                                ),
                              ],
                            ),
                            SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              series: <ChartSeries<WorkoutGraph, String>>[
                                LineSeries<WorkoutGraph, String>(
                                  color: Colors.orange,
                                  dataSource: snapshot.data,
                                  xValueMapper: (WorkoutGraph item, _) =>
                                      item.workoutDate,
                                  yValueMapper: (WorkoutGraph item, _) =>
                                      item.timeSpent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      if (toDate == null || fromDate == null) {
                        return Center(child: Text('Select dates'));
                      } else
                        return Center(
                          child: ColorLoader(
                            color1: Colors.green,
                            color2: Colors.orange,
                            color3: Colors.blue,
                          ),
                        );
                    }
                  },
                ),
              ),
            )
          else if (_groupValue == 3)
            Expanded(
              child: Neumorphic(
                padding: EdgeInsets.all(8),
                style: NeumorphicStyle(depth: -8),
                child: FutureBuilder(
                  future: getWaterVars(fromDate, toDate),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries<WaterGraph, String>>[
                          LineSeries<WaterGraph, String>(
                            color: Colors.blue,
                            dataSource: snapshot.data,
                            xValueMapper: (WaterGraph item, _) =>
                                item.waterDate,
                            yValueMapper: (WaterGraph item, _) =>
                                item.dailyWater,
                          ),
                        ],
                      );
                    } else {
                      if (toDate == null || fromDate == null) {
                        return Center(child: Text('Select dates'));
                      } else
                        return Center(
                          child: ColorLoader(
                            color1: Colors.green,
                            color2: Colors.orange,
                            color3: Colors.blue,
                          ),
                        );
                    }
                  },
                ),
              ),
            )
          else if (_groupValue == 4)
            Expanded(
              child: Neumorphic(
                padding: EdgeInsets.all(8),
                style: NeumorphicStyle(depth: -8),
                child: FutureBuilder(
                  future: getPointsVars(fromDate, toDate),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries<PointsGraph, String>>[
                          LineSeries<PointsGraph, String>(
                            color: Colors.deepPurple[900],
                            dataSource: snapshot.data,
                            xValueMapper: (PointsGraph item, _) =>
                                item.pointsDate,
                            yValueMapper: (PointsGraph item, _) =>
                                item.dailyPoints,
                          ),
                        ],
                      );
                    } else {
                      if (toDate == null || fromDate == null) {
                        return Center(child: Text('Select dates'));
                      } else
                        return Center(
                          child: ColorLoader(
                            color1: Colors.green,
                            color2: Colors.orange,
                            color3: Colors.blue,
                          ),
                        );
                    }
                  },
                ),
              ),
            )
          else
            Expanded(child: Center()),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

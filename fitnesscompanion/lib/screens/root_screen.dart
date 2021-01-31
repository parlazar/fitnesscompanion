import 'package:fitnesscompanion/notifiers/date_of_reg_notifier.dart';
import 'package:fitnesscompanion/notifiers/target_cals_notifier.dart';
import 'package:fitnesscompanion/screens/graphs_screen.dart';
import 'package:fitnesscompanion/screens/main_screen.dart';
import 'package:fitnesscompanion/screens/selected_date.dart';
import 'package:fitnesscompanion/screens/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/firebase_api.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;
  DateTime selectedDate = DateTime.now();

  final _tabs = [
    MainScreen(),
    GraphsScreen(),
    UserDetailsScreen(),
  ];

  @override
  void initState() {
    DateOfRegNotifier dateOfRegNotifier =
        Provider.of<DateOfRegNotifier>(context, listen: false);
    getDateOfReg(dateOfRegNotifier);
    TargetCalsNotifier targetCalsNotifier =
        Provider.of<TargetCalsNotifier>(context, listen: false);
    if (targetCalsNotifier.targetCals == null) {
      getTargetCals(targetCalsNotifier);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: NeumorphicAppBar(
        title: NeumorphicText(
          'Fitness Companion',
          style: NeumorphicStyle(
            depth: 4,
            color: Colors.black,
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 24,
          ),
        ),
        actions: <Widget>[
          if (_currentIndex == 0)
            (Consumer2<DateOfRegNotifier, TargetCalsNotifier>(builder:
                (context, dateOfRegNotifier, targetCalsNotifier, child) {
              return NeumorphicButton(
                minDistance: -8,
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.pink,
                ),
                onPressed: () {
                  List<String> split = dateOfRegNotifier.dateOfReg.split('/');

                  if (DateTime.parse(split[2] + split[1] + split[0])
                      .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                    if (DateTime(DateTime.now().year, DateTime.now().month)
                        .isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime(
                                  DateTime.now().year, DateTime.now().month),
                              firstDate: DateTime.parse(
                                  split[2] + split[1] + split[0]),
                              lastDate:
                                  DateTime.now().subtract(Duration(days: 1)))
                          .then((date) {
                        if (date != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedDate(
                                  date: date,
                                  targetCalsNotifier: targetCalsNotifier),
                            ),
                          );
                        }
                      });
                    } else {
                      if (DateTime.now().month != DateTime.january) {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime(DateTime.now().year,
                                    DateTime.now().month - 1),
                                firstDate: DateTime.parse(
                                    split[2] + split[1] + split[0]),
                                lastDate:
                                    DateTime.now().subtract(Duration(days: 1)))
                            .then((date) {
                          if (date != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectedDate(
                                    date: date,
                                    targetCalsNotifier: targetCalsNotifier),
                              ),
                            );
                          }
                        });
                      } else {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime(
                                    DateTime.now().year - 1, DateTime.december),
                                firstDate: DateTime.parse(
                                    split[2] + split[1] + split[0]),
                                lastDate:
                                    DateTime.now().subtract(Duration(days: 1)))
                            .then((date) {
                          if (date != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectedDate(
                                    date: date,
                                    targetCalsNotifier: targetCalsNotifier),
                              ),
                            );
                          }
                        });
                      }
                    }
                  }
                },
              );
            }))
          else if (_currentIndex == 2)
            (NeumorphicButton(
              minDistance: -8,
              style: NeumorphicStyle(shape: NeumorphicShape.concave),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.pink,
              ),
              onPressed: () => signout(),
            )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Graphs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Personal',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _tabs[_currentIndex],
    );
  }
}

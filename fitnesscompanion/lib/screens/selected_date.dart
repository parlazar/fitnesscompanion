import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesscompanion/notifiers/target_cals_notifier.dart';
import 'package:fitnesscompanion/widgets/calc_card.dart';
import 'package:fitnesscompanion/screens/selected_meals.dart';
import 'package:fitnesscompanion/screens/selected_workouts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SelectedDate extends StatelessWidget {
  final DateTime date;
  final TargetCalsNotifier targetCalsNotifier;
  const SelectedDate({Key key, this.date, this.targetCalsNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: NeumorphicAppBar(
        leading: NeumorphicButton(
          padding: EdgeInsets.all(16),
          minDistance: -8,
          child: NeumorphicIcon(
            Icons.arrow_back,
            style: NeumorphicStyle(
                color: Colors.pink, shape: NeumorphicShape.concave),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(date.day.toString() +
            '/' +
            date.month.toString() +
            '/' +
            date.year.toString()),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(DateFormat('yyyyMMdd').format(date).toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot dailyVars = snapshot.data;
            if (dailyVars.exists) {
              return Container(
                padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CalcCard(
                      targetCals: targetCalsNotifier.targetCals,
                      foodCals: dailyVars.data()['foodCals'],
                      exerciseCals: dailyVars.data()['exerciseCals'],
                    ),
                    Neumorphic(
                      padding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                      style: NeumorphicStyle(
                        depth: -8,
                        border: NeumorphicBorder(
                            isEnabled: true,
                            color: Colors.green[100],
                            width: 2),
                      ),
                      child: NeumorphicButton(
                        child: Center(
                            child: Text(
                          'Meals',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        )),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectedMeals(
                                        date: date,
                                      )));
                        },
                      ),
                    ),
                    Neumorphic(
                      padding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                      style: NeumorphicStyle(
                        depth: -8,
                        border: NeumorphicBorder(
                            isEnabled: true,
                            color: Colors.orange[100],
                            width: 2),
                      ),
                      child: NeumorphicButton(
                        child: Center(
                            child: Text(
                          'Workouts',
                          style: TextStyle(fontSize: 20, color: Colors.orange),
                        )),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectedWorkouts(
                                        date: date,
                                      )));
                        },
                      ),
                    ),
                    Neumorphic(
                      padding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                      style: NeumorphicStyle(
                        depth: -8,
                        border: NeumorphicBorder(
                            isEnabled: true, color: Colors.blue[100], width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Neumorphic(
                              padding: EdgeInsets.all(8),
                              child: NeumorphicText(
                                  'Water: ' +
                                      dailyVars
                                          .data()['dailyWater']
                                          .toString() +
                                      'ml',
                                  textStyle: NeumorphicTextStyle(fontSize: 20),
                                  style: NeumorphicStyle(color: Colors.blue)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return NeumorphicText(
                'No data',
                textStyle: NeumorphicTextStyle(fontSize: 32),
                style: NeumorphicStyle(
                  color: Colors.blueGrey,
                ),
              );
            }
          } else {
            return Text('Loading');
          }
        },
      ),
    );
  }
}

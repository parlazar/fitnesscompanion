import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fitnesscompanion/api/firebase_api.dart';
import 'package:fitnesscompanion/models/meal.dart';
import 'package:fitnesscompanion/models/workout.dart';
import 'package:fitnesscompanion/notifiers/target_cals_notifier.dart';
import 'package:fitnesscompanion/screens/meals_view.dart';
import 'package:fitnesscompanion/screens/workouts_view.dart';
import 'package:fitnesscompanion/widgets/calc_card.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _water = 0;
  int _foodCals = 0;
  int _exerciseCals = 0;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    TargetCalsNotifier targetCalsNotifier =
        Provider.of<TargetCalsNotifier>(context, listen: false);
    return StreamBuilder(
        stream: Stream<DateTime>.periodic(const Duration(seconds: 1), (_) {
          return DateTime.now();
        }),
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(firebaseUser.uid)
                  .collection('dates')
                  .doc(DateFormat('yyyyMMdd').format(DateTime.now()).toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DocumentSnapshot dateVars = snapshot.data;
                  if (dateVars.exists) {
                    if (dateVars.data().containsKey('foodCals')) {
                      if (dateVars.data()['foodCals'] != null) {
                        _foodCals = dateVars.data()['foodCals'];
                      }
                    }
                    if (dateVars.data().containsKey('exerciseCals')) {
                      if (dateVars.data()['exerciseCals'] != null) {
                        _exerciseCals = dateVars.data()['exerciseCals'];
                      }
                    }
                    if (dateVars.data().containsKey('dailyWater')) {
                      if (dateVars.data()['dailyWater'] != null) {
                        _water = dateVars.data()['dailyWater'];
                      }
                    }
                  } else {
                    _foodCals = 0;
                    _exerciseCals = 0;
                    _water = 0;
                  }
                }
                return Container(
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CalcCard(
                        targetCals: targetCalsNotifier.targetCals,
                        foodCals: _foodCals,
                        exerciseCals: _exerciseCals,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            NeumorphicButton(
                              style:
                                  NeumorphicStyle(shape: NeumorphicShape.flat),
                              child: NeumorphicText(
                                '+',
                                textStyle: NeumorphicTextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                style: NeumorphicStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      final GlobalKey<FormState> _formMealKey =
                                          GlobalKey<FormState>();
                                      Meal _meal = Meal();
                                      return AlertDialog(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        content: Container(
                                          height: 350,
                                          width: 150,
                                          child: Form(
                                            key: _formMealKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextFormField(
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText: 'Meal Name'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(
                                                            r"^[A-Z]+[a-zA-Z]*$")
                                                        .hasMatch(value)) {
                                                      return 'A name can only contain characters';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _meal.mealName = value;
                                                  },
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText: 'Calories'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(r"^[0-9]*$")
                                                        .hasMatch(value)) {
                                                      return 'Calories can only contain numbers';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _meal.mealCals =
                                                        int.parse(value);
                                                  },
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText: 'Carbs'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(r"^[0-9]*$")
                                                        .hasMatch(value)) {
                                                      return 'Carbs can only contain numbers';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _meal.carbs =
                                                        int.parse(value);
                                                  },
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText: 'Proteins'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(r"^[0-9]*$")
                                                        .hasMatch(value)) {
                                                      return 'Proteins can only contain numbers';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _meal.proteins =
                                                        int.parse(value);
                                                  },
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText: 'Fats'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(r"^[0-9]*$")
                                                        .hasMatch(value)) {
                                                      return 'Fats can only contain numbers';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _meal.fats =
                                                        int.parse(value);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Submit'),
                                            onPressed: () {
                                              if (!_formMealKey.currentState
                                                  .validate()) {
                                                return;
                                              }
                                              _formMealKey.currentState.save();
                                              postMeal(
                                                  DateTime.now(),
                                                  _meal,
                                                  targetCalsNotifier
                                                      .targetCals);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                        elevation: 24,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: NeumorphicButton(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat),
                                child: NeumorphicText('Meals',
                                    textStyle:
                                        NeumorphicTextStyle(fontSize: 20),
                                    style: NeumorphicStyle(
                                      color: Colors.green,
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MealsView(
                                        targetCals:
                                            targetCalsNotifier.targetCals,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            NeumorphicButton(
                              style:
                                  NeumorphicStyle(shape: NeumorphicShape.flat),
                              child: NeumorphicText(
                                '+',
                                textStyle: NeumorphicTextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                style: NeumorphicStyle(color: Colors.orange),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      final GlobalKey<FormState>
                                          _formWorkoutKey =
                                          GlobalKey<FormState>();
                                      Workout _workout = Workout();
                                      return AlertDialog(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        content: Container(
                                          height: 350,
                                          width: 150,
                                          child: Form(
                                            key: _formWorkoutKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextFormField(
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText: 'Workout Name'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(
                                                            r"^[A-Z]+[a-zA-Z]*$")
                                                        .hasMatch(value)) {
                                                      return 'A name can only contain characters';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _workout.workoutName =
                                                        value;
                                                  },
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Calories Burned'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(r"^[0-9]*$")
                                                        .hasMatch(value)) {
                                                      return 'Calories can only contain numbers';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _workout.burnedCals =
                                                        int.parse(value);
                                                  },
                                                ),
                                                TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  maxLength: 32,
                                                  decoration: InputDecoration(
                                                      hintText: 'Time Spent'),
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Empty';
                                                    }
                                                    if (!RegExp(r"^[0-9]*$")
                                                        .hasMatch(value)) {
                                                      return 'Time can only contain numbers';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _workout.timeSpent =
                                                        int.parse(value);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Submit'),
                                            onPressed: () {
                                              if (!_formWorkoutKey.currentState
                                                  .validate()) {
                                                return;
                                              }
                                              _formWorkoutKey.currentState
                                                  .save();
                                              postWorkout(
                                                  DateTime.now(),
                                                  _workout,
                                                  targetCalsNotifier
                                                      .targetCals);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                        elevation: 24,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0),
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: NeumorphicButton(
                                style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat),
                                child: NeumorphicText('Workouts',
                                    textStyle:
                                        NeumorphicTextStyle(fontSize: 20),
                                    style:
                                        NeumorphicStyle(color: Colors.orange)),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WorkoutsView(
                                        targetCals:
                                            targetCalsNotifier.targetCals,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Neumorphic(
                        padding: EdgeInsets.fromLTRB(32, 24, 32, 24),
                        style: NeumorphicStyle(
                          depth: -8,
                          border: NeumorphicBorder(
                              isEnabled: true,
                              color: Colors.blue[100],
                              width: 2),
                        ),
                        child: Row(
                          children: [
                            NeumorphicButton(
                              style:
                                  NeumorphicStyle(shape: NeumorphicShape.flat),
                              child: NeumorphicIcon(
                                Icons.arrow_upward,
                                style: NeumorphicStyle(
                                    color: Colors.blue,
                                    shape: NeumorphicShape.flat),
                              ),
                              onPressed: () {
                                postWater(DateTime.now(), 250,
                                    targetCalsNotifier.targetCals);
                              },
                            ),
                            SizedBox(width: 16),
                            NeumorphicButton(
                              style:
                                  NeumorphicStyle(shape: NeumorphicShape.flat),
                              child: NeumorphicIcon(
                                Icons.arrow_downward,
                                style: NeumorphicStyle(
                                    color: Colors.blue,
                                    shape: NeumorphicShape.flat),
                              ),
                              onPressed: () {
                                postWater(DateTime.now(), -250,
                                    targetCalsNotifier.targetCals);
                              },
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Neumorphic(
                                padding: EdgeInsets.all(8),
                                child: NeumorphicText('Water: $_water ml',
                                    textStyle:
                                        NeumorphicTextStyle(fontSize: 20),
                                    style: NeumorphicStyle(color: Colors.blue)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}

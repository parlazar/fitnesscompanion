import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesscompanion/models/meal.dart';
import 'package:fitnesscompanion/models/meal_graph.dart';
import 'package:fitnesscompanion/models/points_graph.dart';
import 'package:fitnesscompanion/models/user_details.dart';
import 'package:fitnesscompanion/models/water_graph.dart';
import 'package:fitnesscompanion/models/workout.dart';
import 'package:fitnesscompanion/models/workout_graph.dart';
import 'package:fitnesscompanion/notifiers/date_of_reg_notifier.dart';
import 'package:fitnesscompanion/notifiers/target_cals_notifier.dart';
import 'package:intl/intl.dart';
import '../models/user_credentials.dart';

login(UserCredentials userCredentials) async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: userCredentials.email, password: userCredentials.password)
      .catchError((error) => print(error.code));
}

signup(UserCredentials userCredentials) async {
  UserCredential userCredential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: userCredentials.email, password: userCredentials.password)
      .catchError((error) => print(error.code));

  if (userCredential != null) {
    User user = userCredential.user;
    if (user != null) {
      await user.reload();
      print("Sign up: $user");
    }
  }
}

signout() async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));
}

setUserInfo(UserDetails userDetails, int targetCals) async {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  await databaseReference.collection("users").doc(firebaseUser.uid).set({
    'firstName': userDetails.firstName,
    'lastName': userDetails.lastName,
    'birthDate': userDetails.birthDate,
    'height': userDetails.height,
    'weight': userDetails.weight,
    'gender': userDetails.gender,
    'targetCals': targetCals,
    'dateOfReg': DateFormat('dd/MM/y').format(DateTime.now()),
    'totalPoints': 0,
    'highestStreak': 0,
  }).catchError((error) => print(error.code));
  await FirebaseAuth.instance.currentUser.updateProfile(
      displayName:
          userDetails.firstName.trim() + ' ' + userDetails.lastName.trim());
  await firebaseUser.reload();
}

postMeal(DateTime dateTime, Meal meal, int targetCals) async {
  String date = (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  await databaseReference
      .collection("users")
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .collection('meals')
      .doc(DateTime.now().toString())
      .set({
    'mealName': meal.mealName,
    'mealCals': meal.mealCals,
    'proteins': meal.proteins,
    'carbs': meal.carbs,
    'fats': meal.fats
  }).catchError((error) => print(error.code));

  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    if (onValue.exists) {
      if (onValue.data().containsKey('foodCals')) {
        await databaseReference
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(date)
            .update({'foodCals': onValue.data()['foodCals'] + meal.mealCals})
            .whenComplete(() => postDailyPoints(targetCals, dateTime))
            .catchError((error) => print(error.code));
      }
    } else {
      await databaseReference
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('dates')
          .doc(date)
          .set({
            'foodCals': meal.mealCals,
            'exerciseCals': 0,
            'dailyWater': 0,
            'dailyPoints': 0,
          })
          .whenComplete(() => postDailyPoints(targetCals, dateTime))
          .catchError((error) => print(error.code));
    }
  });
}

updateMeal(DateTime dateTime, DocumentSnapshot docSnapshot, Meal meal,
    int targetCals) async {
  String date = (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));

  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    await databaseReference
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('dates')
        .doc(date)
        .update({
      'foodCals': meal.mealCals != null
          ? onValue.data()['foodCals'] +
              meal.mealCals -
              docSnapshot.data()['mealCals']
          : onValue.data()['foodCals']
    }).whenComplete(() async {
      await databaseReference
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('dates')
          .doc(date)
          .collection('meals')
          .doc(docSnapshot.id)
          .update({
            'mealName': meal.mealName != ''
                ? meal.mealName
                : docSnapshot.data()['mealName'],
            'mealCals': meal.mealCals != null
                ? meal.mealCals
                : docSnapshot.data()['mealCals'],
            'carbs':
                meal.carbs != null ? meal.carbs : docSnapshot.data()['carbs'],
            'proteins': meal.proteins != null
                ? meal.proteins
                : docSnapshot.data()['proteins'],
            'fats': meal.fats != null ? meal.fats : docSnapshot.data()['fats']
          })
          .whenComplete(() => postDailyPoints(targetCals, dateTime))
          .catchError((error) => print(error.code));
    });
  });
}

deleteMeal(
    DateTime dateTime, DocumentSnapshot docSnapshot, int targetCals) async {
  String date = (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));

  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    await databaseReference
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('dates')
        .doc(date)
        .update({
          'foodCals':
              onValue.data()['foodCals'] - docSnapshot.data()['mealCals']
        })
        .whenComplete(() async {
          await databaseReference
              .collection('users')
              .doc(firebaseUser.uid)
              .collection('dates')
              .doc(date)
              .collection('meals')
              .doc(docSnapshot.id)
              .delete();
        })
        .whenComplete(() => postDailyPoints(targetCals, dateTime))
        .catchError((error) => print(error.code));
  });
}

postWorkout(DateTime dateTime, Workout workout, int targetCals) async {
  String date = (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));

  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .collection('workouts')
      .doc(DateTime.now().toString())
      .set({
    'workoutName': workout.workoutName,
    'burnedCals': workout.burnedCals,
    'timeSpent': workout.timeSpent
  }).catchError((error) => print(error.code));

  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    if (onValue.exists) {
      if (onValue.data().containsKey('exerciseCals')) {
        await databaseReference
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(date)
            .update({
              'exerciseCals':
                  onValue.data()['exerciseCals'] + workout.burnedCals
            })
            .whenComplete(() => postDailyPoints(targetCals, dateTime))
            .catchError((error) => print(error.code));
      }
    } else {
      await databaseReference
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('dates')
          .doc(date)
          .set({
            'foodCals': 0,
            'exerciseCals': workout.burnedCals,
            'dailyWater': 0,
            'dailyPoints': 0,
          })
          .whenComplete(() => postDailyPoints(targetCals, dateTime))
          .catchError((error) => print(error.code));
    }
  });
}

updateWorkout(DateTime dateTime, DocumentSnapshot docSnapshot, Workout workout,
    int targetCals) async {
  String date = (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));

  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    await databaseReference
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('dates')
        .doc(date)
        .update({
      'exerciseCals': workout.burnedCals != null
          ? onValue.data()['exerciseCals'] +
              workout.burnedCals -
              docSnapshot.data()['burnedCals']
          : onValue.data()['exerciseCals']
    }).whenComplete(() async {
      await databaseReference
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('dates')
          .doc(date)
          .collection('workouts')
          .doc(docSnapshot.id)
          .update({
            'workoutName': workout.workoutName != ''
                ? workout.workoutName
                : docSnapshot.data()['workoutName'],
            'burnedCals': workout.burnedCals != null
                ? workout.burnedCals
                : docSnapshot.data()['burnedCals'],
            'timeSpent': workout.timeSpent != null
                ? workout.timeSpent
                : docSnapshot.data()['timeSpent'],
          })
          .whenComplete(() => postDailyPoints(targetCals, dateTime))
          .catchError((error) => print(error.code));
    });
  });
}

deleteWorkout(
    DateTime dateTime, DocumentSnapshot docSnapshot, int targetCals) async {
  String date = (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));

  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    await databaseReference
        .collection('users')
        .doc(firebaseUser.uid)
        .collection('dates')
        .doc(date)
        .update({
          'exerciseCals':
              onValue.data()['exerciseCals'] - docSnapshot.data()['burnedCals']
        })
        .whenComplete(() async {
          await databaseReference
              .collection('users')
              .doc(firebaseUser.uid)
              .collection('dates')
              .doc(date)
              .collection('workouts')
              .doc(docSnapshot.id)
              .delete();
        })
        .whenComplete(() => postDailyPoints(targetCals, dateTime))
        .catchError((error) => print(error.code));
  });
}

postWater(DateTime dateTime, int amount, int targetCals) async {
  String date = (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));

  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    if (onValue.exists) {
      if (onValue.data().containsKey('dailyWater')) {
        if (onValue.data()['dailyWater'] > 0 || amount > 0) {
          await databaseReference
              .collection('users')
              .doc(firebaseUser.uid)
              .collection('dates')
              .doc(date)
              .update({'dailyWater': onValue.data()['dailyWater'] + amount})
              .whenComplete(() => postDailyPoints(targetCals, dateTime))
              .catchError((error) => print(error.code));
        }
      }
    } else {
      if (amount > 0) {
        await databaseReference
            .collection('users')
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(date)
            .set({
              'foodCals': 0,
              'exerciseCals': 0,
              'dailyWater': amount,
              'dailyPoints': 0,
            })
            .whenComplete(() => postDailyPoints(targetCals, dateTime))
            .catchError((error) => print(error.code));
      }
    }
  });
}

getDateOfReg(DateOfRegNotifier dateOfRegNotifier) async {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .get()
      .then((onValue) {
    if (onValue.exists) {
      if (onValue.data().containsKey('dateOfReg')) {
        dateOfRegNotifier.setDateOfReg(onValue.data()['dateOfReg']);
      }
    }
  });
}

getTargetCals(TargetCalsNotifier targetCalsNotifier) async {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .get()
      .then((onValue) {
    if (onValue.exists) {
      if (onValue.data().containsKey('targetCals')) {
        targetCalsNotifier.setTargetCals(onValue.data()['targetCals']);
      }
    }
  });
}

postDailyPoints(int targetCals, DateTime dateTime) async {
  int points = 0;
  int prev = 0;
  String date = zeroFix(dateTime);

  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  await databaseReference
      .collection('users')
      .doc(firebaseUser.uid)
      .collection('dates')
      .doc(date)
      .get()
      .then((onValue) async {
    prev = onValue.data()['dailyPoints'];
    if (onValue.data()['dailyWater'] > 0) {
      points = 250;
    }
    if (onValue.data()['exerciseCals'] > 0) {
      points = points + 250;
    }
    int percentage = ((targetCals -
            onValue.data()['foodCals'] +
            onValue.data()['exerciseCals'])
        .abs());
    double ratio = 100 - (percentage / targetCals) * 100;

    if (ratio == 100) {
      points = points + 1750;
    } else if (ratio > 90 && ratio < 100) {
      points = points + 1500;
    } else if (ratio > 80 && ratio <= 90) {
      points = points + 1250;
    } else if (ratio > 70 && ratio <= 80) {
      points = points + 1000;
    } else if (ratio > 60 && ratio <= 70) {
      points = points + 750;
    } else if (ratio > 50 && ratio <= 60) {
      points = points + 500;
    } else if (onValue.data()['foodCals'] > 0) {
      points = points + 250;
    }

    if (points == 0) {
      await databaseReference
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('dates')
          .doc(date)
          .set({'streakCount': 0}, SetOptions(merge: true));
    } else {
      DateTime prevDate = dateTime.subtract(Duration(days: 1));
      String prev = zeroFix(prevDate);
      await databaseReference
          .collection('users')
          .doc(firebaseUser.uid)
          .collection('dates')
          .doc(prev)
          .get()
          .then((onValue) async {
        if (onValue.exists) {
          if (onValue.data().containsKey('streakCount')) {
            await databaseReference
                .collection('users')
                .doc(firebaseUser.uid)
                .collection('dates')
                .doc(date)
                .set({'streakCount': onValue.data()['streakCount'] + 1},
                    SetOptions(merge: true));

            await databaseReference
                .collection('users')
                .doc(firebaseUser.uid)
                .get()
                .then((value) async {
              if (value.data().containsKey('highestStreak')) {
                if (value.data()['highestStreak'] <
                    onValue.data()['streakCount']) {
                  await databaseReference
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .set({'highestStreak': onValue.data()['streakCount'] + 1},
                          SetOptions(merge: true));
                }
              } else {
                await databaseReference
                    .collection('users')
                    .doc(firebaseUser.uid)
                    .set({'highestStreak': onValue.data()['streakCount'] + 1},
                        SetOptions(merge: true));
              }
            });
          } else {
            await databaseReference
                .collection('users')
                .doc(firebaseUser.uid)
                .collection('dates')
                .doc(date)
                .set({'streakCount': 1}, SetOptions(merge: true)).whenComplete(
                    () async {
              await databaseReference
                  .collection('users')
                  .doc(firebaseUser.uid)
                  .get()
                  .then((value) async {
                if (value.data().containsKey('highestStreak')) {
                  if (value.data()['highestStreak'] < 1) {
                    await databaseReference
                        .collection('users')
                        .doc(firebaseUser.uid)
                        .set({'highestStreak': 1}, SetOptions(merge: true));
                  }
                } else {
                  await databaseReference
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .set({'highestStreak': 1}, SetOptions(merge: true));
                }
              });
            });
          }
        } else {
          await databaseReference
              .collection('users')
              .doc(firebaseUser.uid)
              .collection('dates')
              .doc(date)
              .set({'streakCount': 1}, SetOptions(merge: true)).whenComplete(
                  () async {
            await databaseReference
                .collection('users')
                .doc(firebaseUser.uid)
                .get()
                .then((value) async {
              if (value.data().containsKey('highestStreak')) {
                if (value.data()['highestStreak'] < 1) {
                  await databaseReference
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .set({'highestStreak': 1}, SetOptions(merge: true));
                }
              } else {
                await databaseReference
                    .collection('users')
                    .doc(firebaseUser.uid)
                    .set({'highestStreak': 1}, SetOptions(merge: true));
              }
            });
          });
        }
      });
    }
    await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection('dates')
        .doc(date)
        .update({'dailyPoints': points}).whenComplete(() async {
      await databaseReference
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((onValue) async {
        await databaseReference
            .collection('users')
            .doc(firebaseUser.uid)
            .update({
          'totalPoints': onValue.data()['totalPoints'] - prev + points
        }).catchError((error) => print(error.code));
      });
    }).catchError((error) => print(error.code));
  });
}

Future<List<MealGraph>> getMealVars(DateTime fromDate, DateTime toDate) async {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<MealGraph> data = List<MealGraph>();
  if (fromDate != null && toDate != null) {
    if (toDate.difference(fromDate).inDays > 0) {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        await databaseReference
            .collection("users")
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(zeroFix(fromDate.add(Duration(days: i))))
            .collection('meals')
            .get()
            .then((onValue) {
          if (onValue != null) {
            MealGraph item = MealGraph('', 0, 0, 0, 0);
            item.mealDate = zeroFix(fromDate.add(Duration(days: i)));
            for (int j = 0; j < onValue.docs.length; j++) {
              if (onValue.docs[j].exists) {
                if (onValue.docs[j].data().isNotEmpty)
                  item.totalCals =
                      item.totalCals + onValue.docs[j].data()['mealCals'];
                item.totalProteins =
                    item.totalProteins + onValue.docs[j].data()['proteins'];
                item.totalCarbs =
                    item.totalCarbs + onValue.docs[j].data()['carbs'];
                item.totalFats =
                    item.totalFats + onValue.docs[j].data()['fats'];
              }
            }
            data.add(item);
          }
        });
      }
    }
  }
  if (data.isNotEmpty) {
    return Future.value(data);
  } else
    return Future.value(null);
}

Future<List<WorkoutGraph>> getWorkoutVars(
    DateTime fromDate, DateTime toDate) async {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<WorkoutGraph> data = List<WorkoutGraph>();
  if (fromDate != null && toDate != null) {
    if (toDate.difference(fromDate).inDays > 0) {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        await databaseReference
            .collection("users")
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(zeroFix(fromDate.add(Duration(days: i))))
            .collection('workouts')
            .get()
            .then((onValue) {
          if (onValue != null) {
            WorkoutGraph item = WorkoutGraph('', 0, 0);
            item.workoutDate = zeroFix(fromDate.add(Duration(days: i)));
            for (int j = 0; j < onValue.docs.length; j++) {
              if (onValue.docs[j].exists) {
                if (onValue.docs[j].data().isNotEmpty)
                  item.burnedCals =
                      item.burnedCals + onValue.docs[j].data()['burnedCals'];
                item.timeSpent =
                    item.timeSpent + onValue.docs[j].data()['timeSpent'];
              }
            }
            data.add(item);
          }
        });
      }
    }
  }
  if (data.isNotEmpty) {
    return Future.value(data);
  } else
    return Future.value(null);
}

Future<List<WaterGraph>> getWaterVars(
    DateTime fromDate, DateTime toDate) async {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<WaterGraph> data = List<WaterGraph>();
  if (fromDate != null && toDate != null) {
    if (toDate.difference(fromDate).inDays > 0) {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        await databaseReference
            .collection("users")
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(zeroFix(fromDate.add(Duration(days: i))))
            .get()
            .then((onValue) {
          if (onValue != null) {
            WaterGraph item = WaterGraph('', 0);
            item.waterDate = zeroFix(fromDate.add(Duration(days: i)));
            if (onValue.exists) {
              if (onValue.data().isNotEmpty)
                item.dailyWater =
                    item.dailyWater + onValue.data()['dailyWater'];
            }
            data.add(item);
          }
        });
      }
    }
  }
  if (data.isNotEmpty) {
    return Future.value(data);
  } else
    return Future.value(null);
}

Future<List<PointsGraph>> getPointsVars(
    DateTime fromDate, DateTime toDate) async {
  final databaseReference = FirebaseFirestore.instance;
  final firebaseUser = FirebaseAuth.instance.currentUser;
  List<PointsGraph> data = List<PointsGraph>();
  if (fromDate != null && toDate != null) {
    if (toDate.difference(fromDate).inDays > 0) {
      for (int i = 0; i <= toDate.difference(fromDate).inDays; i++) {
        await databaseReference
            .collection("users")
            .doc(firebaseUser.uid)
            .collection('dates')
            .doc(zeroFix(fromDate.add(Duration(days: i))))
            .get()
            .then((onValue) {
          if (onValue != null) {
            PointsGraph item = PointsGraph('', 0);
            item.pointsDate = zeroFix(fromDate.add(Duration(days: i)));
            if (onValue.exists) {
              if (onValue.data().isNotEmpty)
                item.dailyPoints =
                    item.dailyPoints + onValue.data()['dailyPoints'];
            }
            data.add(item);
          }
        });
      }
    }
  }
  if (data.isNotEmpty) {
    return Future.value(data);
  } else
    return Future.value(null);
}

String zeroFix(DateTime dateTime) {
  return (dateTime.year.toString() +
      ((dateTime.month.toString().length == 1)
          ? ('0' + dateTime.month.toString())
          : dateTime.month.toString()) +
      ((dateTime.day.toString().length == 1)
          ? ('0' + dateTime.day.toString())
          : dateTime.day.toString()));
}

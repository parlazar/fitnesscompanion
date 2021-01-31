import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesscompanion/api/firebase_api.dart';
import 'package:fitnesscompanion/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class WorkoutsView extends StatelessWidget {
  final int targetCals;
  const WorkoutsView({Key key, this.targetCals}) : super(key: key);
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return NeumorphicButton(
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            document.data()['workoutName'],
            style: TextStyle(color: Colors.orange, fontSize: 32),
          ),
          Row(
            children: <Widget>[
              Text('Burned: ',
                  style: TextStyle(color: Colors.orange, fontSize: 16)),
              Text(document.data()['burnedCals'].toString(),
                  style: TextStyle(color: Colors.orange, fontSize: 16)),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Time: ',
                  style: TextStyle(color: Colors.orange, fontSize: 16)),
              Text(document.data()['timeSpent'].toString(),
                  style: TextStyle(color: Colors.orange, fontSize: 16)),
            ],
          )
        ],
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              final GlobalKey<FormState> _formWorkoutKey =
                  GlobalKey<FormState>();
              Workout _workout = Workout();
              return AlertDialog(
                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                content: Container(
                  height: 350,
                  width: 150,
                  child: Form(
                    key: _formWorkoutKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          maxLength: 32,
                          decoration: InputDecoration(hintText: 'Workout Name'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return null;
                            }
                            if (!RegExp(r"^[A-Z]+[a-zA-Z]*$").hasMatch(value)) {
                              return 'A name can only contain characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _workout.workoutName = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 32,
                          decoration:
                              InputDecoration(hintText: 'Calories Burned'),
                          validator: (value) {
                            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
                              return 'Calories can only contain numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value.isNotEmpty) {
                              _workout.burnedCals = int.parse(value);
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 32,
                          decoration: InputDecoration(hintText: 'Time Spent'),
                          validator: (value) {
                            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
                              return 'Carbs can only contain numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value.isNotEmpty) {
                              _workout.timeSpent = int.parse(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Delete'),
                    onPressed: () {
                      deleteWorkout(
                          DateTime.now(), document, targetCals);
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (!_formWorkoutKey.currentState.validate()) {
                        return;
                      }
                      _formWorkoutKey.currentState.save();
                      updateWorkout(DateTime.now(), document,
                          _workout, targetCals);
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
    );
  }

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
              color: Colors.orange,
              shape: NeumorphicShape.concave,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Workouts'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(firebaseUser.uid)
              .collection('dates')
              .doc(DateFormat('yyyyMMdd').format(DateTime.now()).toString())
              .collection('workouts')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading..");
            }
            return ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: Container(
                padding: EdgeInsets.all(8),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Divider(
                      height: 16,
                    ),
                  ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return _buildList(
                        context, snapshot.data.documents[index]);
                  },
                ),
              ),
            );
          }),
    );
  }
}

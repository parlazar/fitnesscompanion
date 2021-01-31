import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesscompanion/api/firebase_api.dart';
import 'package:fitnesscompanion/models/meal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class MealsView extends StatelessWidget {
  final int targetCals;
  const MealsView({Key key, this.targetCals}) : super(key: key);
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return NeumorphicButton(
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            document.data()['mealName'],
            style: TextStyle(color: Colors.green, fontSize: 32),
          ),
          Row(
            children: <Widget>[
              Text('Calories: ',
                  style: TextStyle(color: Colors.green, fontSize: 16)),
              Text(document.data()['mealCals'].toString(),
                  style: TextStyle(color: Colors.green, fontSize: 16)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Carbs: ',
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                  Text(document.data()['carbs'].toString(),
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Proteins: ',
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                  Text(document.data()['proteins'].toString(),
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Fats: ',
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                  Text(document.data()['fats'].toString(),
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                ],
              ),
            ],
          )
        ],
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              final GlobalKey<FormState> _formMealKey = GlobalKey<FormState>();
              Meal _meal = Meal();
              return AlertDialog(
                contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                content: Container(
                  height: 350,
                  width: 150,
                  child: Form(
                    key: _formMealKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          maxLength: 32,
                          decoration: InputDecoration(hintText: 'Meal Name'),
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
                            _meal.mealName = value;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 32,
                          decoration: InputDecoration(hintText: 'Calories'),
                          validator: (value) {
                            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
                              return 'Calories can only contain numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value.isNotEmpty) {
                              _meal.mealCals = int.parse(value);
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 32,
                          decoration: InputDecoration(hintText: 'Carbs'),
                          validator: (value) {
                            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
                              return 'Carbs can only contain numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value.isNotEmpty) {
                              _meal.carbs = int.parse(value);
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 32,
                          decoration: InputDecoration(hintText: 'Proteins'),
                          validator: (value) {
                            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
                              return 'Proteins can only contain numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value.isNotEmpty) {
                              _meal.proteins = int.parse(value);
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 32,
                          decoration: InputDecoration(hintText: 'Fats'),
                          validator: (value) {
                            if (!RegExp(r"^[0-9]*$").hasMatch(value)) {
                              return 'Fats can only contain numbers';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value.isNotEmpty) {
                              _meal.fats = int.parse(value);
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
                      deleteMeal(DateTime.now(), document, targetCals);
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
                      if (!_formMealKey.currentState.validate()) {
                        return;
                      }
                      _formMealKey.currentState.save();
                      updateMeal(DateTime.now(), document, _meal, targetCals);
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
              color: Colors.green,
              shape: NeumorphicShape.concave,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Meals'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(firebaseUser.uid)
              .collection('dates')
              .doc(DateFormat('yyyyMMdd').format(DateTime.now()).toString())
              .collection('meals')
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
                    return _buildList(context, snapshot.data.documents[index]);
                  },
                ),
              ),
            );
          }),
    );
  }
}

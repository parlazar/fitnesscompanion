import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class SelectedMeals extends StatelessWidget {
  final DateTime date;
  const SelectedMeals({Key key, this.date}) : super(key: key);
  Widget _buildList(BuildContext context, DocumentSnapshot document) {
    return Neumorphic(
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Container(
        padding: EdgeInsets.all(8),
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
      ),
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
              .doc(DateFormat('yyyyMMdd').format(date).toString())
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

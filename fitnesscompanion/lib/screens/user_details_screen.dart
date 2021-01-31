import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesscompanion/screens/trophy_collection.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    return Container(
      padding: EdgeInsets.all(16),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot userVars = snapshot.data;
            return Neumorphic(
                padding: EdgeInsets.all(16),
                style: NeumorphicStyle(depth: -8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'First Name: ',
                                  style: TextStyle(
                                      color: Colors.pink[300],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Neumorphic(
                                  padding: EdgeInsets.all(16),
                                  style: NeumorphicStyle(
                                    depth: -8,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Container(
                                    width: 84,
                                    child: Text(userVars
                                        .data()['firstName']
                                        .toString()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Last Name: ',
                                  style: TextStyle(
                                      color: Colors.pink[300],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Neumorphic(
                                  padding: EdgeInsets.all(16),
                                  style: NeumorphicStyle(
                                    depth: -8,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Container(
                                    width: 84,
                                    child: Text(
                                        userVars.data()['lastName'].toString()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date of Birth: ',
                                  style: TextStyle(
                                      color: Colors.pink[300],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Neumorphic(
                                  padding: EdgeInsets.all(16),
                                  style: NeumorphicStyle(
                                    depth: -8,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Container(
                                    width: 84,
                                    child: Text(userVars
                                        .data()['birthDate']
                                        .toString()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Height: ',
                                  style: TextStyle(
                                      color: Colors.pink[300],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Neumorphic(
                                  padding: EdgeInsets.all(16),
                                  style: NeumorphicStyle(
                                    depth: -8,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Container(
                                    width: 84,
                                    child: Text(
                                        userVars.data()['height'].toString()+' cm'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Weight: ',
                                  style: TextStyle(
                                      color: Colors.pink[300],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Neumorphic(
                                  padding: EdgeInsets.all(16),
                                  style: NeumorphicStyle(
                                    depth: -8,
                                    boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Container(
                                    width: 84,
                                    child: Text(
                                        userVars.data()['weight'].toString()+' kg'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: NeumorphicButton(
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat, color: Colors.white),
                        child: Text(
                          'Trophy collection',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[900]),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrophyCollection(
                                        totalPoints:
                                            userVars.data()['totalPoints'],
                                        highestStreak:
                                            userVars.data()['highestStreak'],
                                      )));
                        },
                      ),
                    )
                  ],
                ));
          } else
            return Text('');
        },
      ),
    );
  }
}

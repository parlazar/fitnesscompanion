import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CalcCard extends StatefulWidget {
  final int targetCals, foodCals, exerciseCals;
  CalcCard({
    @required this.targetCals,
    @required this.foodCals,
    @required this.exerciseCals,
  });

  @override
  _CalcCardState createState() => _CalcCardState();
}

class _CalcCardState extends State<CalcCard> {
  @override
  Widget build(BuildContext context) {
    int _target = (widget.targetCals != null) ? widget.targetCals : 0;
    int _foodCals = (widget.foodCals != null) ? widget.foodCals : 0;
    int _exerciseCals = (widget.exerciseCals != null) ? widget.exerciseCals : 0;
    int _remainingCals = _target - _foodCals + _exerciseCals;

    return Neumorphic(
      padding: EdgeInsets.fromLTRB(32, 24, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '$_target',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Target',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '-',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('')
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '$_foodCals',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Food',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '+',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('')
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '$_exerciseCals',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Exersice',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '=',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('')
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                '$_remainingCals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Remaining',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }
}

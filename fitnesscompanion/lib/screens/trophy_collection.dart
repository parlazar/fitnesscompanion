import 'package:fitnesscompanion/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TrophyCollection extends StatelessWidget {
  final int totalPoints;
  final int highestStreak;

  const TrophyCollection({Key key, this.totalPoints, this.highestStreak})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        leading: NeumorphicButton(
          padding: EdgeInsets.all(16),
          minDistance: -8,
          child: NeumorphicIcon(
            Icons.arrow_back,
            style: NeumorphicStyle(
              color: Colors.deepPurple[900],
              shape: NeumorphicShape.concave,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Trophy Collection'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Neumorphic(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    style: NeumorphicStyle(
                      depth: -8,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(4)),
                      oppositeShadowLightSource: false,
                      border: NeumorphicBorder(
                        color: Colors.white,
                        width: 2,
                        isEnabled: true,
                      ),
                    ),
                    child: Neumorphic(
                      padding: EdgeInsets.fromLTRB(64, 8, 64, 8),
                      style: NeumorphicStyle(
                        depth: 8,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(4)),
                        oppositeShadowLightSource: false,
                        border: NeumorphicBorder(
                          color: Colors.white,
                          width: 2,
                          isEnabled: true,
                        ),
                      ),
                      child: NeumorphicText(
                        'Point Badges',
                        style: NeumorphicStyle(
                          color: Colors.deepPurple[900],
                          depth: 8,
                        ),
                        textStyle: NeumorphicTextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Badge(
                      badgeName: 'assets/bp.png',
                      isGrey: (totalPoints > 2500 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/sp.png',
                      isGrey: (totalPoints > 10000 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/gp.png',
                      isGrey: (totalPoints > 100000 ? false : true),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Badge(
                      badgeName: 'assets/pp.png',
                      isGrey: (totalPoints > 250000 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/dp.png',
                      isGrey: (totalPoints > 500000 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/ip.png',
                      isGrey: (totalPoints > 1000000 ? false : true),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Neumorphic(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    style: NeumorphicStyle(
                      depth: -8,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(4)),
                      oppositeShadowLightSource: false,
                      border: NeumorphicBorder(
                        color: Colors.white,
                        width: 2,
                        isEnabled: true,
                      ),
                    ),
                    child: Neumorphic(
                      padding: EdgeInsets.fromLTRB(64, 8, 64, 8),
                      style: NeumorphicStyle(
                        depth: 8,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(4)),
                        oppositeShadowLightSource: false,
                        border: NeumorphicBorder(
                          color: Colors.white,
                          width: 2,
                          isEnabled: true,
                        ),
                      ),
                      child: NeumorphicText(
                        'Streak Badges',
                        style: NeumorphicStyle(
                          color: Colors.deepPurple[900],
                          depth: 8,
                        ),
                        textStyle: NeumorphicTextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Badge(
                      badgeName: 'assets/bs.png',
                      isGrey: (highestStreak > 7 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/ss.png',
                      isGrey: (highestStreak > 28 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/gs.png',
                      isGrey: (highestStreak > 90 ? false : true),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Badge(
                      badgeName: 'assets/ps.png',
                      isGrey: (highestStreak > 180 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/ds.png',
                      isGrey: (highestStreak > 270 ? false : true),
                    ),
                    Badge(
                      badgeName: 'assets/is.png',
                      isGrey: (highestStreak > 365 ? false : true),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

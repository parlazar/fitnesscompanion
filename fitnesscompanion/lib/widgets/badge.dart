import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shimmer/shimmer.dart';

class Badge extends StatelessWidget {
  final String badgeName;
  final bool isGrey;

  const Badge({Key key, this.badgeName, this.isGrey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: EdgeInsets.all(8),
      style: NeumorphicStyle(
        depth: 8,
        boxShape: NeumorphicBoxShape.circle(),
        oppositeShadowLightSource: false,
        border: NeumorphicBorder(
          color: Colors.white,
          width: 2,
          isEnabled: true,
        ),
      ),
      child: Neumorphic(
        padding: EdgeInsets.all(8),
        style: NeumorphicStyle(
          depth: 8,
          boxShape: NeumorphicBoxShape.circle(),
          oppositeShadowLightSource: false,
          border: NeumorphicBorder(
            color: Colors.white,
            width: 2,
            isEnabled: true,
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Image.asset(
              badgeName,
              scale: 6,
              color: (isGrey) ? Colors.grey : null,
            ),
            Shimmer.fromColors(
                child: Image.asset(
                  badgeName,
                  scale: 6,
                  color: (isGrey) ? Colors.grey : null,
                ),
                loop: 1,
                enabled: !isGrey,
                baseColor: Colors.transparent,
                highlightColor: Colors.white),
          ],
        ),
      ),
    );
  }
}

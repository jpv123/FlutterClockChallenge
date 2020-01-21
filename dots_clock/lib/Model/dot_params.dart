import 'package:flutter/material.dart';

class DotParams {
    double alpha = 0;
    Color color;
    double endInterval;
    Duration fullAnimationDuration;
    double scale;
    double startInterval;

    DotParams({ @required this.alpha, @required this.color, @required this.endInterval, @required this.fullAnimationDuration, @required this.scale, @required this.startInterval });

    DotParams.zero(BuildContext context) {
        this.alpha = 0;
        this.color = Colors.white;
        this.endInterval = 1;  
        this.fullAnimationDuration = Duration(milliseconds: 0);
        this.scale = 0;
        this.startInterval = 0;
    }
}
import 'dart:io';

import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Manager/animation_manager.dart';
import 'Widgets/dots_clock.dart';


void main() {
  // A temporary measure until Platform supports web and TargetPlatform supports
  // macOS.
  if (!kIsWeb && Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  // This creates a clock that enables you to customize it.
  //
  // The [ClockCustomizer] takes in a [ClockBuilder] that consists of:
  //  - A clock widget (in this case, [DigitalClock])
  //  - A model (provided to you by [ClockModel])
  // For more information, see the flutter_clock_helper package.
  //
  // Your job is to edit [DigitalClock], or replace it with your
  // own clock widget. (Look in digital_clock.dart for more details!)
  runApp(
        ChangeNotifierProvider(
            builder: (context) => AnimationManager(),
            child: ClockCustomizer(
                (ClockModel model) => DotsClock(model)
            )
        )
    );
}

import 'package:flutter/material.dart';

class Utilities {
    ///Is dark mode enabled
    ///
    ///- returns: Boolean indicating if app has dark mode enabled
    static bool isDarkModeEnabled(BuildContext context) {
        return Theme.of(context).brightness == Brightness.dark;
    }
}
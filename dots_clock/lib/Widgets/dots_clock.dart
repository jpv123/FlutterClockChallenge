import 'dart:async';

import 'package:dots_clock/Constants/constants.dart';
import 'package:dots_clock/Manager/animation_manager.dart';
import 'package:dots_clock/Model/dot_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import 'dot.dart';

class DotsClock extends StatefulWidget {
    final ClockModel model;

    const DotsClock(this.model);

    @override
    _DotsClockState createState() => _DotsClockState();
}

class _DotsClockState extends State<DotsClock> {

    DateTime _dateTime = DateTime.now();
    Timer _timer;

    @override
    void initState() {
        super.initState();

        _startClockAnimation();
        _startClock();
    }

    @override
    void didUpdateWidget(DotsClock oldWidget) {
        super.didUpdateWidget(oldWidget);

        if (widget.model != oldWidget.model) {
            oldWidget.model.removeListener(_updateModel);
            widget.model.addListener(_updateModel);
        }
    }

    @override
    Widget build(BuildContext context) {
        return Stack(
            children: <Widget>[
                _createMainContainer()
            ],
        );
    }

    @override
    void dispose() {
        _timer?.cancel();
        widget.model.removeListener(_updateModel);
        widget.model.dispose();
        super.dispose();
    }

    /// MARK: - Private Methods
    /// Creates row with dots
    /// returns: Row with dots based on constants
    Widget _createDotsRow({ int columnIndex, int numberIndex }) {
        List<Dot> dots = [];

        for (int i = 0; i < kVerticalDotsNumber; i++) {
            DotInfo dotInfo = DotInfo(column: columnIndex, numberIndex: numberIndex, row: i);

            dots.add(
                Dot(dotInfo: dotInfo)
            );
        }

        return Expanded(
            child: Column(
                children: dots,
            )
        );
    }

    ///Create main container
    Widget _createMainContainer() {
        return Row(
            children: <Widget>[
                _createNumberBlock(numberIndex: 0),
                _createNumberBlock(numberIndex: 1),
                _createNumberBlock(numberIndex: 2),
                _createNumberBlock(numberIndex: 3),
                _createNumberBlock(numberIndex: 4),
                _createNumberBlock(numberIndex: 5),
            ],
            mainAxisSize: MainAxisSize.max,
        );
    }

    /// Creates number block for the clock
    /// parameter numberIndex: Number index. 0 is the first number of the clock, 1 the next one and so on...
    Widget _createNumberBlock({ int numberIndex }) {
        List<Widget> columns = [];

        for (int i = 0; i < kHorizontalDotsNumber; i++) {
            columns.add(_createDotsRow(columnIndex: i, numberIndex: numberIndex));
        }

        return Expanded(
            child: Row(
                children: columns,
                mainAxisSize: MainAxisSize.max,
            ),
        );
    }

    ///Start clock animation
    _startClockAnimation() {
        Provider.of<AnimationManager>(context, listen: false).startClockAnimation();
    }

    _startClock() {
        Future.delayed(Duration(seconds: 5), (){
            widget.model.addListener(_updateModel);
            _updateTime();
        });
    }

    /// MARK: - Utility Methods
    /// Update current numbers
    void _updateCurrentNumbers() {
        final hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
        final minute = DateFormat('mm').format(_dateTime);
        final seconds = DateFormat('ss').format(_dateTime);
        final hour0 = int.parse(hour[0]);
        final hour1 = int.parse(hour[1]);
        final minutes0 = int.parse(minute[0]);
        final minutes1 = int.parse(minute[1]);
        final seconds0 = int.parse(seconds[0]);
        final seconds1 = int.parse(seconds[1]);

        Provider.of<AnimationManager>(context, listen: false).setNumberAnimation(number: hour0, numberIndex: 0);
        Provider.of<AnimationManager>(context, listen: false).setNumberAnimation(number: hour1, numberIndex: 1);
        Provider.of<AnimationManager>(context, listen: false).setNumberAnimation(number: minutes0, numberIndex: 2);
        Provider.of<AnimationManager>(context, listen: false).setNumberAnimation(number: minutes1, numberIndex: 3);
        Provider.of<AnimationManager>(context, listen: false).setNumberAnimation(number: seconds0, numberIndex: 4);
        Provider.of<AnimationManager>(context, listen: false).setNumberAnimation(number: seconds1, numberIndex: 5);
    }

    ///Called when model is updated by the user through interface
    void _updateModel() {
        setState(() {
        // Cause the clock to rebuild when the model changes.
        });
    }

    //Updates time every second and calls animation provider to updat UI accordingly
    void _updateTime() {
        _dateTime = DateTime.now();
        
        // Update once per second, but make sure to do it at the beginning of each
        // new second, so that the clock is accurate.
        _timer = Timer(Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,);
        _updateCurrentNumbers();
    }
}
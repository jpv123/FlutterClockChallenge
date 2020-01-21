import 'dart:math';

import 'package:dots_clock/Constants/constants.dart';
import 'package:dots_clock/Model/dot_info.dart';
import 'package:dots_clock/Model/dot_params.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum _Animation {
    none,
    removeNumber,
    setNumber,
    startClock
}

class AnimationManager extends ChangeNotifier {

    _Animation currentAnimation = _Animation.none;
    int _numberIndex0 = 0;
    int _numberIndex1 = 1;
    int _numberIndex2 = 2;
    int _numberIndex3 = 3;
    int _numberIndex4 = 4;
    int _numberIndex5 = 5;

    ///Get dot animation parameters
    ///parameter currentParams: Dot current params
    ///parameter dotInfo: Dot info
    DotParams getDotAnimationParams({ DotParams currentParams, DotInfo dotInfo }) {
        if (currentAnimation == _Animation.none) {
            return currentParams;
        }

        return _getDotParamsWithCurrentAnimation(
            currentParams: currentParams,
            dotInfo: dotInfo
        );
    }

    ///Set number in number index
    setNumberAnimation({ int number, int numberIndex}) {
        currentAnimation = _Animation.setNumber;

        switch (numberIndex) {
            case 0:
                _numberIndex0 = number;
                break;
            case 1:
                _numberIndex1 = number;
                break;
            case 2:
                _numberIndex2 = number;
                break;
            case 3:
                _numberIndex3 = number;
                break;
            case 4:
                _numberIndex4 = number;
                break;
            case 5:
                _numberIndex5 = number;
                break;
        }

        notifyListeners();
    }

    ///Set initial animation
    startClockAnimation() {
        currentAnimation = _Animation.startClock;

        notifyListeners();
    }

    /// MARK: - Private Methods
    /// Get Current Animation Duration
    /// returns: Animation duration time in miliseconds
    int _getCurrentAnimationDuration() {
        switch (currentAnimation) {
            case _Animation.none:
                return 0;
            case _Animation.removeNumber:
                return kRemoveNumberAnimationDuration;
            case _Animation.setNumber:
                return kSetNumberAnimationDuration;
            case _Animation.startClock:
                return kStartClockAnimationDuration;
        }

        return 0;
    }
    
    /// Get dot params with current animation
    ///parameter currentParams: Dot current params
    ///parameter dotInfo: Dot info
    DotParams _getDotParamsWithCurrentAnimation({ DotParams currentParams, DotInfo dotInfo }) {
        switch (currentAnimation) {
            case _Animation.none:
                return currentParams;
            case _Animation.removeNumber:
                return currentParams;
            case _Animation.setNumber:
                return _dotParamsForSetNumberAnimation(currentParams: currentParams, dotInfo: dotInfo);
            case _Animation.startClock:
                return _dotParamsForStartAnimation(currentParams: currentParams, dotInfo: dotInfo);
        }

        return currentParams;
    }

    /// Get Number Array
    /// parameter number: Number to search array
    /// returns: Number array for number
    List<int> _getNumberArray({ int number }) {
        switch (number) {
            case 0:
                return kDotsNumber0;
            case 1:
                return kDotsNumber1;
            case 2:
                return kDotsNumber2;
            case 3:
                return kDotsNumber3;
            case 4:
                return kDotsNumber4;
            case 5:
                return kDotsNumber5;
            case 6:
                return kDotsNumber6;
            case 7:
                return kDotsNumber7;
            case 8:
                return kDotsNumber8;
            case 9:
                return kDotsNumber9;
        }

        return [];
    }

    /// Get Number at index
    /// parameter numberIndex: Number index to get number
    /// returns: Number at index
    int _getNumberAtIndex({ int numberIndex }) {
        switch (numberIndex) {
            case 0:
                return _numberIndex0;
            case 1:
                return _numberIndex1;
            case 2:
                return _numberIndex2;
            case 3:
                return _numberIndex3;
            case 4:
                return _numberIndex4;
            case 5:
                return _numberIndex5;
        }

        return 0;
    }

    ///MARK: - Dot Params for animations
    /// Get dot params for set number animation
    ///parameter currentParams: Dot current params
    ///parameter dotInfo: Dot info
    DotParams _dotParamsForSetNumberAnimation({ DotParams currentParams, DotInfo dotInfo }) {
        int number = _getNumberAtIndex(numberIndex: dotInfo.numberIndex);
        List<int> numbersArray = _getNumberArray(number: number);
        int dotNumber = dotInfo.row * kHorizontalDotsNumber + dotInfo.column;
        bool isInArray = numbersArray.contains(dotNumber);

        Color color = isInArray ? Colors.blue : Colors.grey;
        double scale = isInArray ? 1 : kScaleSmall;

        DotParams params = DotParams(
            alpha: 1,
            color: color,
            endInterval: 1,
            fullAnimationDuration: Duration(milliseconds: _getCurrentAnimationDuration()),
            scale: scale,
            startInterval: 0
        );

        return params;
    }
    
    /// Get dot params for start clock animation
    ///parameter currentParams: Dot current params
    ///parameter dotInfo: Dot info
    DotParams _dotParamsForStartAnimation({ DotParams currentParams, DotInfo dotInfo }) {
        
        DotParams params = DotParams(
            alpha: 1,
            color: Colors.blue,
            endInterval: 1,
            fullAnimationDuration: Duration(milliseconds: _getCurrentAnimationDuration()),
            scale: 1,
            startInterval: 0
        );

        return params;
    }
}
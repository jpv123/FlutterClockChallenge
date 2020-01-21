import 'dart:math';

import 'package:dots_clock/Manager/animation_manager.dart';
import 'package:dots_clock/Model/dot_info.dart';
import 'package:dots_clock/Model/dot_params.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dot extends StatefulWidget {
    final DotInfo dotInfo;

    Dot({ @required this.dotInfo });

    @override
    _DotState createState() => _DotState();
}

class _DotState extends State<Dot> with TickerProviderStateMixin {

    DotParams params;
    Animation _scaleAnimation;
    AnimationController _scaleController;

    /// MARK: - Lifecycle
    @override
    void initState() {
        super.initState();
        params = DotParams.zero(context);
        _setScaleAnimation(params.scale);
    }

    @override
    Widget build(BuildContext context) {
        return Consumer<AnimationManager>(
            builder: _buildMainContainer,
        );
    }

    @override
    dispose() {
        _scaleController.dispose();
        super.dispose();
    }

    /// MARK: - Public Methods
    ///Build Alpha Widget
    ///parameter child: Child container
    Widget _buildAlpha({ Widget child }) {
        return AnimatedOpacity(
            child: child,
            curve: Interval(
                params.startInterval,
                params.endInterval,
                curve: Curves.easeInOutBack,
            ),
            duration: params.fullAnimationDuration,
            opacity: params.alpha,
        );
    }

    ///Build main container
    ///parameter animationManager: Animation manager from consumer
    ///parameter context: Build context
    ///parameter widget: Widget if any
    Widget _buildMainContainer(context, AnimationManager animationManager, widget) {
        if (animationManager != null) { 
            double pastScale = params.scale;
            params = animationManager.getDotAnimationParams(
                currentParams: params,
                dotInfo: this.widget.dotInfo
            );
            _setScaleAnimation(pastScale);
        }

        return Expanded(
            child: _buildAlpha(
                child: ScaleTransition(
                    child: AnimatedContainer(
                        curve: Interval(
                            params.startInterval,
                            params.endInterval,
                            curve: Curves.easeInOutBack,
                        ),
                        decoration: BoxDecoration(
                            color: params.color,
                            shape: BoxShape.circle
                        ),
                        duration: params.fullAnimationDuration,
                        margin: EdgeInsets.all(1),
                    ),
                    scale: _scaleAnimation,
                )
            )
        );
    }

    ///Set scale animation
    _setScaleAnimation(double pastScale) {
        _scaleController = AnimationController(
            duration: params.fullAnimationDuration,
            vsync: this
        );
        _scaleAnimation = Tween<double>(
            begin: pastScale ?? 0,
            end: params.scale
        ).animate(
            CurvedAnimation(
                curve: Interval(
                    params.startInterval,
                    params.endInterval,
                    curve: Curves.easeInOutBack,
                ),
                parent: _scaleController,
            )
        );
        _scaleController.forward();
    }
}
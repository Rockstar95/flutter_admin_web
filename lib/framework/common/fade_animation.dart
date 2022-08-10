import 'package:flutter/cupertino.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final MultiTween<String> tween = MultiTween<String>();
    tween.add(
        "opacity", Tween(begin: 0.0, end: 1.0), Duration(milliseconds: 500));
    tween.add("translateY", Tween(begin: -30.0, end: 0.0),
        Duration(milliseconds: 500), Curves.easeOut);

    return CustomAnimation<MultiTweenValues<String>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (BuildContext context, Widget? child,
              MultiTweenValues<String> animation) =>
          Opacity(
        opacity: animation.getOrElse("opacity", 1) ?? 1,
        child: Transform.translate(
            offset: Offset(0, animation.getOrElse("translateY", 0)),
            child: child),
      ),
    );
  }
}

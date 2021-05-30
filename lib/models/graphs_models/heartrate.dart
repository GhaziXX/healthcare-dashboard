import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HeartRate extends StatefulWidget {
  HeartRate(this.heartRate);

  int heartRate;

  @override
  _HeartRateState createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> with TickerProviderStateMixin {
  Animation _heartAnimation;
  AnimationController _heartAnimationController;
  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _heartAnimation = Tween(begin: 150.0, end: 160.0).animate(CurvedAnimation(
        curve: Curves.bounceOut, parent: _heartAnimationController));

    _heartAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _heartAnimationController.repeat();
      }
    });
  }

  void dispose() {
    _heartAnimationController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    if (widget.heartRate != 0) _heartAnimationController.forward();

    return FittedBox(
      child: Column(
        children: [
          Text("Heart Rate", style: Theme.of(context).textTheme.headline5),
          SizedBox(
            height: _size.height * 0.05,
          ),
          Center(
            child: Align(
              child: Stack(alignment: AlignmentDirectional.center, children: [
                AnimatedBuilder(
                  animation: _heartAnimationController,
                  builder: (context, child) {
                    return Container(
                      child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: primaryColor,
                              size: 2.25 * _heartAnimation.value,
                            ),
                            Icon(
                              Icons.favorite,
                              color: secondaryColor,
                              size: 2.2 * _heartAnimation.value,
                            ),
                          ]),
                    );
                  },
                ),
                Text(
                  widget.heartRate.toString() + '\nbpm',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .apply(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

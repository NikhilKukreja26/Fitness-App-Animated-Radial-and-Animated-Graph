import 'package:flutter/material.dart';

import '../themes/colors.dart';
import '../fitness_data.dart';

class Graph extends StatelessWidget {
  final AnimationController animationController;
  final List<GraphData> values;
  final double height;

  const Graph({
    Key key,
    this.animationController,
    this.height = 120.0,
    this.values,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildBars(values),
      ),
    );
  }

  _buildBars(List<GraphData> values) {
    GraphData maxGraphData = values.reduce(
        (current, next) => (next.compareTo(current) >= 1) ? next : current);
    List<GraphBar> _bars = List();

    values.forEach((graphData) {
      double percentage = graphData.value / maxGraphData.value;
      print(percentage);
      _bars.add(GraphBar(
        height: height,
        percentage: percentage,
        graphAnimationController: animationController,
      ));
    });
    return _bars;
  }
}

class GraphBar extends StatefulWidget {
  final double height, percentage;
  final AnimationController graphAnimationController;

  const GraphBar({
    Key key,
    this.height,
    this.percentage,
    this.graphAnimationController,
  }) : super(key: key);
  @override
  _GraphBarState createState() => _GraphBarState();
}

class _GraphBarState extends State<GraphBar> {
  Animation<double> _percentageAnimation;

  @override
  void initState() {
    super.initState();

    _percentageAnimation = Tween<double>(
      begin: 0.0,
      end: widget.percentage,
    ).animate(widget.graphAnimationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BarPainter(percentage: _percentageAnimation.value),
      child: Container(),
    );
  }
}

class BarPainter extends CustomPainter {
  final double percentage;

  BarPainter({
    this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint greyPaint = Paint()
      ..color = greyColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    Offset topPoint = Offset(0, 0);
    Offset bottomPoint = Offset(0, (size.height + 20));
    Offset centerPoint = Offset(0, (size.height + 20) / 2);

    canvas.drawLine(topPoint, bottomPoint, greyPaint);

    Paint filledPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        colors: [Colors.pink.shade500, Colors.blue.shade500],
      ).createShader(Rect.fromPoints(topPoint, bottomPoint))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    double filledHeight = percentage * size.height;
    double filledHalfHeight = filledHeight / 2;

    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy - filledHalfHeight), filledPaint);
    canvas.drawLine(
        centerPoint, Offset(0, centerPoint.dy + filledHalfHeight), filledPaint);
  }

  @override
  bool shouldRepaint(BarPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BarPainter oldDelegate) => true;
}

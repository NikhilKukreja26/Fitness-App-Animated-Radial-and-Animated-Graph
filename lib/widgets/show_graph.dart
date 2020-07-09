import 'package:flutter/material.dart';

import '../fitness_data.dart';
import '../widgets/graph.dart';

class ShowGraph extends StatefulWidget {
  @override
  _ShowGraphState createState() => _ShowGraphState();
}

class _ShowGraphState extends State<ShowGraph>
    with SingleTickerProviderStateMixin {
  AnimationController _graphAnimationController;

  @override
  void initState() {
    super.initState();
    _graphAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _graphAnimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _graphAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {},
        child: Graph(
          animationController: _graphAnimationController,
          values: runningDayData,
        ),
      ),
    );
  }
}

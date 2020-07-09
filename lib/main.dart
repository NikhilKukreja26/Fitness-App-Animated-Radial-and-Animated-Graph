import 'package:fitness_app/widgets/activities_widget.dart';
import 'package:flutter/material.dart';

import './themes/colors.dart';
import './widgets/top_bar.dart';
import './widgets/radial_progress.dart';
import './widgets/show_graph.dart';
import './date_utils.dart';
import './blocs/home_page_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: appTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  HomePageBloc _homePageBloc;

  AnimationController _iconAnimationController;
  Animation<double> _animation;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _homePageBloc = HomePageBloc();

    _iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    super.dispose();
    _homePageBloc.dispose();
    _iconAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  TopBar(),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 60.0,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: () {
                            _homePageBloc.subtractDate();
                          },
                        ),
                        StreamBuilder<Object>(
                            stream: _homePageBloc.dateStream,
                            initialData: _homePageBloc.selectedDate,
                            builder: (context, snapshot) {
                              return Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      formattedDayOfWeek
                                          .format(snapshot.data)
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formattedDate.format(snapshot.data),
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.3,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        Transform.rotate(
                          angle: 135.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 35.0,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              _homePageBloc.addDate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              RadialProgress(),
              MonthlyStatusListing(),
            ],
          ),
          // ActivitiesWidget(
          //     _iconAnimationController, MediaQuery.of(context).size.height),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 5.0,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red,
                  width: 4.0,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.menu),
                color: Colors.red,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return ShowGraph();
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onIconPressed() {
    animationStatus
        ? _iconAnimationController.reverse()
        : _iconAnimationController.forward();
  }

  bool get animationStatus {
    final AnimationStatus status = _iconAnimationController.status;
    return status == AnimationStatus.completed;
  }
}

class MonthlyStatusListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              MonthlyStatusRow('July 2020', 'On going'),
              MonthlyStatusRow('June 2020', 'Failed'),
              MonthlyStatusRow('May 2020', 'Completed'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              MonthlyTargetRow('Lose weight', '3.8 ktgt/7 kg'),
              MonthlyTargetRow('Running per month', '15.3 km/20 km'),
              MonthlyTargetRow('Avg steps Per day', '10000/10000'),
            ],
          ),
        ],
      ),
    );
  }
}

class MonthlyStatusRow extends StatelessWidget {
  final String monthYear, status;

  MonthlyStatusRow(this.monthYear, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            monthYear,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          Text(
            status,
            style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class MonthlyTargetRow extends StatelessWidget {
  final String target, targetAchieved;

  MonthlyTargetRow(this.target, this.targetAchieved);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            target,
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          Text(
            targetAchieved,
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_admin_web/framework/bloc/mylearning/model/dummy_my_catelog_response_entity.dart';

class DashboardGridScreen extends StatefulWidget {
  final List<DummyMyCatelogResponseTable2> mylearningplusdashdayWishlist;
  final List<DummyMyCatelogResponseTable2> mylearningplusDashWeeklist;
  final List<DummyMyCatelogResponseTable2> mylearningplusDashMonthlist;

  const DashboardGridScreen({
    required this.mylearningplusdashdayWishlist,
    required this.mylearningplusDashWeeklist,
    required this.mylearningplusDashMonthlist,
  });

  @override
  State<DashboardGridScreen> createState() => DashboardGrid();
}

class DashboardGrid extends State<DashboardGridScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text(
              'Grid',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}

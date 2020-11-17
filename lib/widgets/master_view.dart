import 'package:flutter/material.dart';
import 'package:movie_admin/widgets/my_drawer.dart';

class MasterView extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Widget child;

  MasterView({this.title, this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: onPressed,
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: child,
    );
  }
}

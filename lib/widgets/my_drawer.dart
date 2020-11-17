import 'package:flutter/material.dart';
import 'package:movie_admin/my_router.dart';

class MyDrawer extends StatelessWidget {
  ListTile _buildDrawerItem(BuildContext context,
      {@required String title, @required String routeName}) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Movie Admin",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          _buildDrawerItem(context,
              title: 'Genres', routeName: MyRouter.GENRES_SCREEN),
          _buildDrawerItem(context,
              title: 'Movies', routeName: MyRouter.MOVIES_SCREEN),
        ],
      ),
    );
  }
}

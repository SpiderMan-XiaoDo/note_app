import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  dynamic _deviceHeigh;
  dynamic _deviceWidth;

  @override
  Widget build(context) {
    _deviceHeigh = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: _deviceWidth * 0.6,
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.fromLTRB(_deviceWidth * 0.03,
                _deviceHeigh * 0.03, _deviceWidth * 0.03, _deviceHeigh * 0.03),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(colors: [
            //     Color.fromARGB(1, 0, 0, 0),
            //     Color.fromARGB(1, 0, 0, 0)
            //   ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            // ),
            decoration:
                const BoxDecoration(color: Color.fromARGB(207, 1, 47, 88)),
            child: Row(
              children: [
                Center(
                  child: Image.asset('assets/image/diary_image.png', scale: 4),
                ),
                // const SizedBox(
                //   width: 18,
                // ),
                Text('My Diary',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Color.fromARGB(255, 36, 216, 222),
                          fontSize: 24,
                        ))
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.restaurant,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Meal',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              // onSelectScreen('Meal');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Setting',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              // onSelectScreen('filters');
            },
          )
        ],
      ),
    );
  }
}

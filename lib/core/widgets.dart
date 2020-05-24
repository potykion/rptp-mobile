import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rptpmobile/theme.dart';

import 'blocs.dart';

class AppBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UIBloc, UIState>(
        builder: (BuildContext context, UIState state) => BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.videocam),
              title: Text("Видео"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recent_actors),
              title: Text("Актрисы"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Настройки"),
            ),
          ],
          backgroundColor: Pallete[Colors.pink],
          selectedItemColor: Pallete[Colors.black],
          currentIndex: state.currentPageIndex,
          onTap: (index) =>
              context.bloc<UIBloc>().add(PageChangedEvent.fromIndex(index)),
        ),
      );
}

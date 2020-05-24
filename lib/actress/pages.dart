import 'package:flutter/material.dart';
import 'package:rptpmobile/actress/widgets.dart';
import 'package:rptpmobile/core/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs.dart';
import 'models.dart';

class ActressPage extends StatelessWidget {
  @override
  Widget build(context) => BlocBuilder<ActressBloc, ActressState>(
        builder: (context, state) {
          if (state.pageState == ActressPageState.dbCheck) {
            return DbCheckPage();
          } else if (state.pageState == ActressPageState.notEmptyDb) {
            return ActressListPage(actresses: state.matchingActresses);
          } else if (state.pageState == ActressPageState.emptyDb) {
            return DbRefreshButtonPage();
          } else if (state.pageState == ActressPageState.dbRefresh) {
            return DbRefreshPage(progress: state.dbRefreshProgress);
          }
          throw Exception("Неизвестный стейт: ${state.pageState}");
        },
      );
}

class DbCheckPage extends StatefulWidget {
  @override
  _DbCheckPageState createState() => _DbCheckPageState();
}

class _DbCheckPageState extends State<DbCheckPage> {
  @override
  void initState() {
    super.initState();
    context.bloc<ActressBloc>().add(DbCheckedEvent());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Проверяем базу")),
        body: Center(child: CircularProgressIndicator()),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

class ActressListPage extends StatelessWidget {
  final List<Actress> actresses;

  const ActressListPage({Key key, this.actresses}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: ActressNamePatternInput()),
        body: ActressGrid(actresses: actresses),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

class DbRefreshButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("База пустая - загрузи ее")),
        body: Center(
            child: RaisedButton(
          onPressed: () =>
              context.bloc<ActressBloc>().add(DbRefreshStartedEvent()),
          child: Text("Загрузить базу"),
        )),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

class DbRefreshPage extends StatelessWidget {
  final double progress;

  const DbRefreshPage({Key key, this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Загружаем базу...")),
        body: Center(child: CircularProgressIndicator(value: progress)),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

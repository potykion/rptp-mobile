import 'package:flutter/material.dart';
import 'package:rptpmobile/widgets.dart';

class ActressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Для начала загрузи базу"),
        ),
        body: Center(
            child: RaisedButton(
          onPressed: () {},
          child: Text("Загрузить базу"),
        )),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

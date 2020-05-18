import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rptpmobile/ui_bloc.dart';

import '../widgets.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Настроечки"),
        ),
        body: ListView(
          children: [
            BlocBuilder<UIBloc, UIState>(
              builder: (BuildContext context, UIState state) => ListTile(
                title: Text("Превьюшки-котики"),
                trailing: Checkbox(
                  value: state.kittenPreview,
                  onChanged: (newKittenPreview) => context
                      .bloc<UIBloc>()
                      .add(KittenPreviewChanged(newKittenPreview)),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

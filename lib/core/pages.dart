import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rptpmobile/core/widgets.dart';

import 'blocs.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Настроечки"),
        ),
        body: ListView(
          children: [
            BlocBuilder<UIBloc, UIState>(
              builder: (BuildContext context, UIState state) =>
                  CheckboxListTile(
                title: Text("Превьюшки-котики"),
                value: state.kittenPreview,
                onChanged: (newKittenPreview) => context
                    .bloc<UIBloc>()
                    .add(KittenPreviewChanged(newKittenPreview)),
              ),
            )
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

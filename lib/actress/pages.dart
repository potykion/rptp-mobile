import 'package:flutter/material.dart';
import 'package:rptpmobile/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs.dart';

class ActressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Для начала загрузи базу"),
        ),
        body: Center(
            child: BlocBuilder<ActressBloc, ActressState>(
          builder: (context, state) => state.actressBaseRefreshProgress == 0
              ? RaisedButton(
                  onPressed: () => context
                      .bloc<ActressBloc>()
                      .add(ActressBaseRefreshStartedEvent()),
                  child: Text("Загрузить базу"),
                )
              : LinearProgressIndicator(
                  value: state.actressBaseRefreshProgress,
                ),
        )),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

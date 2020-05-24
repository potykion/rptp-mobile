import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rptpmobile/actress/blocs.dart';
import 'package:rptpmobile/actress/pages.dart';
import 'package:rptpmobile/theme.dart';
import 'package:rptpmobile/vk/blocs.dart';

import 'actress/db.dart';
import 'core/blocs.dart';
import 'core/pages.dart';
import 'vk/pages.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(RptpApp());
}

class RptpApp extends StatelessWidget {
  @override
  Widget build(context) => MultiProvider(
        providers: [
          Provider<MyDatabase>(create: (_) => MyDatabase()),
          Provider<ActressRepo>(
            create: (context) => ActressRepo(context.read<MyDatabase>()),
          ),
          BlocProvider<VKBloc>(create: (_) => VKBloc()),
          BlocProvider<UIBloc>(create: (_) => UIBloc()),
          BlocProvider<ActressBloc>(
            create: (context) => ActressBloc(context.read<ActressRepo>()),
          ),
        ],
        child: MaterialApp(
          // TODO: replace with routes
          home: BlocBuilder<UIBloc, UIState>(
            builder: (_, state) {
              switch (state.currentPage) {
                case AppPage.videos:
                  return VideosPage();
                case AppPage.actress:
                  return ActressPage();
                case AppPage.settings:
                  return SettingsPage();
                default:
                  throw Exception("Неизвестная страница: ${state.currentPage}");
              }
            },
          ),
          routes: {
            "/vk-auth": (_) => VKAuthWebviewPage(),
          },
          theme: buildTheme(context),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rptpmobile/actress/widgets.dart';
import 'package:rptpmobile/core/widgets.dart';
import 'auth/services.dart';
import 'auth/widgets.dart';
import 'blocs.dart';
import 'video/widgets.dart';

class VideosPage extends StatelessWidget {
  @override
  Widget build(context) => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) => state.accessTokenValid
            ? state.videoQuery == null ? EmptyVideoQueryPage() : VKVideosPage()
            : VKAuthPage(),
      );
}

class EmptyVideoQueryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: VKVideoQueryInput()),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Нажми на кнопку'),
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.autorenew),
                  ),
                ],
              ),
              Text("или введи итересующий запрос выше")
            ],
          ),
        ),
        floatingActionButton: RandomActressFAB(),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

class VKVideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) => Scaffold(
          appBar:
              AppBar(title: VKVideoQueryInput(initialQuery: state.videoQuery)),
          body: state.loadingStatus == LoadingStatus.finished
              ? VKVideosGrid(videos: state.videos)
              : Center(child: CircularProgressIndicator()),
          floatingActionButton: RandomActressFAB(),
          bottomNavigationBar: AppBottomNavBar(),
        ),
      );
}

class VKAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Для начала войди в ВК")),
        body: Center(
          child: VKAuthButton(
            onAuthComplete: () =>
                context.bloc<VKBloc>().add(VKVideoSearchStarted()),
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(),
      );
}

class VKAuthWebviewPage extends StatefulWidget {
  final VKAuth auth;

  VKAuthWebviewPage({auth}) : this.auth = auth ?? VKAuth();

  @override
  _VKAuthWebviewPageState createState() => _VKAuthWebviewPageState();
}

class _VKAuthWebviewPageState extends State<VKAuthWebviewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      var accessToken = widget.auth.tryParseToken(url);
      if (accessToken != null) {
        Navigator.pop(context, accessToken);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebviewPlugin.close();
  }

  @override
  Widget build(BuildContext context) =>
      WebviewScaffold(url: widget.auth.authUrl);
}

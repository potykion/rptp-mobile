import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rptpmobile/actress/db.dart';
import 'package:rptpmobile/core/widgets.dart';
import 'package:provider/provider.dart';
import 'auth/services.dart';
import 'auth/widgets.dart';
import 'blocs.dart';
import 'video/widgets.dart';

class VideosPage extends StatefulWidget {
  final String initialQuery;

  VideosPage({this.initialQuery});

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      context.bloc<VKBloc>().add(VKVideoSearchStarted(widget.initialQuery));
    }
  }

  @override
  Widget build(context) => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) =>
            state.accessTokenValid ? VKVideosPage() : VKAuthPage(),
      );
}

class VKVideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: state.videoQuery == null
                ? TapOnIconButtonHint(icon: Icons.autorenew)
                : VKVideoQueryInput(initialQuery: state.videoQuery),
          ),
          body: state.videoQuery == null
              ? Container()
              : state.loadingStatus == LoadingStatus.finished
                  ? VKVideosGrid(videos: state.videos)
                  : Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var actress = await context.read<ActressRepo>().getRandom();
              context.bloc<VKBloc>().add(VKVideoSearchStarted(actress.name));
            },
            child: Icon(Icons.autorenew),
          ),
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

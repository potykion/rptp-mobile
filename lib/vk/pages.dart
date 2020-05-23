import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rptpmobile/core/widgets.dart';

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
      var event = context.bloc<VKBloc>().state.accessTokenValid
          ? VKVideoSearchStarted(widget.initialQuery)
          : VideoQuerySetEvent(widget.initialQuery);

      context.bloc<VKBloc>().add(event);
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: state.accessTokenValid
                ? state.videoQuery == null
                    ? TapOnIconButtonHint(icon: Icons.autorenew)
                    : VKVideoQueryInput(initialQuery: state.videoQuery)
                : Text("Для начала войди в ВК"),
          ),
          body: state.accessTokenValid
              ? buildVideoListView()
              : VKAuthButton(
                  onAuthComplete: () => context
                      .bloc<VKBloc>()
                      .add(VKVideoSearchStarted(state.videoQuery)),
                ),
          floatingActionButton: state.accessTokenValid
              ? FloatingActionButton(
                  onPressed: () => context
                      .bloc<VKBloc>()
                      .add(VKVideoSearchStarted(state.videoQuery)),
                  child: Icon(Icons.autorenew),
                )
              : null,
          bottomNavigationBar: AppBottomNavBar(),
        ),
      );

  Widget buildVideoListView() => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) =>
            state.loadingStatus == LoadingStatus.finished
                ? VKVideosGrid(videos: state.videos)
                : Center(child: CircularProgressIndicator()),
      );
}

class VKAuthPage extends StatefulWidget {
  final VKAuth auth;

  VKAuthPage({auth}) : this.auth = auth ?? VKAuth();

  @override
  _VKAuthPageState createState() => _VKAuthPageState();
}

class _VKAuthPageState extends State<VKAuthPage> {
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

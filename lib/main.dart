import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:rptpmobile/vk.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) => MultiProvider(
        child: MaterialApp(
          home: VideosPage(),
          theme: ThemeData(
            primaryColor: Colors.pink[100],
            accentColor: Colors.pink[100],
            cursorColor: Colors.black,
            textSelectionHandleColor: Colors.black,
          ),
        ),
        providers: [
          BlocProvider<VKBloc>(create: (context) => VKBloc()),
        ],
      );
}

class VideosPage extends StatelessWidget {
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
                  onAuthComplete: () => context.bloc<VKBloc>().add(
                        VKVideoSearchStarted(state.videoQuery),
                      ),
                ),
          floatingActionButton: state.accessTokenValid
              ? FloatingActionButton(
                  onPressed: () => context
                      .bloc<VKBloc>()
                      .add(VKVideoSearchStarted(state.videoQuery)),
                  child: Icon(Icons.autorenew),
                )
              : null,
        ),
      );

  Widget buildVideoListView() => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) =>
            state.loadingStatus == LoadingStatus.finished
                ? VKVideosGrid(videos: state.videos)
                : Center(child: CircularProgressIndicator()),
      );
}

typedef OnAuthComplete = void Function();

class VKAuthButton extends StatelessWidget {
  final OnAuthComplete onAuthComplete;

  const VKAuthButton({Key key, this.onAuthComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: RaisedButton(
          child: Text("Войти в ВК"),
          onPressed: () async {
            var accessToken = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VKAuthPage()),
            );
            context.bloc<VKBloc>().add(VKAccessTokenSetEvent(accessToken));

            if (onAuthComplete != null) {
              onAuthComplete();
            }
          },
        ),
      );
}

class VKVideosGrid extends StatelessWidget {
  final List<VKVideo> videos;

  const VKVideosGrid({Key key, this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) => OrientationBuilder(
        builder: (_, orientation) => orientation == Orientation.portrait
            ? ListView.builder(
                itemBuilder: (_, index) => VKVideoCard(video: videos[index]),
                itemCount: videos.length,
              )
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.75,
                children: videos.map((v) => VKVideoCard(video: v)).toList(),
              ),
      );
}

class TapOnIconButtonHint extends StatelessWidget {
  final IconData icon;

  const TapOnIconButtonHint({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text('Нажми на кнопку'),
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(icon),
          ),
        ],
      );
}

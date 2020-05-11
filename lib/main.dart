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
            title: Text(
              state.accessToken == null
                  ? "Для начала войди в ВК"
                  : state.videoQuery ?? 'Нажми "Загрузить видео"',
            ),
            centerTitle: true,
          ),
          body: state.accessToken != null
              ? buildVideoListView()
              : buildVKAuthButton(),
          floatingActionButton: state.accessToken != null
              ? FloatingActionButton(
                  onPressed: () => context
                      .bloc<VKBloc>()
                      .add(VKVideoSearchStarted("riley reid")),
                  child: Icon(Icons.autorenew),
                )
              : null,
        ),
      );

  Widget buildVKAuthButton() => Builder(
        builder: (context) => Center(
          child: RaisedButton(
            child: Text("Войти в ВК"),
            onPressed: () async {
              var accessToken = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VKAuthPage()),
              );
              context.bloc<VKBloc>().add(VKAccessTokenSetEvent(accessToken));
            },
          ),
        ),
      );

  Widget buildVideoListView() => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) => OrientationBuilder(
          builder: (context, orientation) =>
              orientation == Orientation.portrait
                  ? ListView.builder(
                      itemBuilder: (context, index) =>
                          VKVideoCard(video: state.videos[index]),
                      itemCount: state.videos.length,
                    )
                  : GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.75,
                      children: state.videos
                          .map((v) => VKVideoCard(video: v))
                          .toList(),
                    ),
        ),
      );
}

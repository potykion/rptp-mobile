import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rptpmobile/theme.dart';
import 'package:rptpmobile/vk.dart';
import 'package:rptpmobile/widgets.dart';

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
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.videocam),
                title: Text("Видео"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.recent_actors),
                title: Text("Актрисы"),
              ),
            ],
            backgroundColor: Pallete[Colors.pink],
            selectedItemColor: Pallete[Colors.black],
          ),
        ),
      );

  Widget buildVideoListView() => BlocBuilder<VKBloc, VKState>(
        builder: (context, state) =>
            state.loadingStatus == LoadingStatus.finished
                ? VKVideosGrid(videos: state.videos)
                : Center(child: CircularProgressIndicator()),
      );
}

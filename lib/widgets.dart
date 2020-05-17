import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rptpmobile/vk.dart';

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

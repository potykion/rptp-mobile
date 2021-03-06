import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rptpmobile/core/blocs.dart';
import 'package:rptpmobile/vk/video/view_models.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs.dart';
import 'models.dart';

class VKVideosGrid extends StatelessWidget {
  final List<VideoVM> videos;

  const VKVideosGrid({Key key, this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) => videos.length == 0
      ? Center(child: Text("Ничего не нашлось"))
      : OrientationBuilder(
          builder: (_, orientation) => orientation == Orientation.portrait
              ? ListView.builder(
                  itemBuilder: (_, index) => VKVideoCard(video: videos[index]),
                  itemCount: videos.length,
                )
              : StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: videos.length,
                  staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  itemBuilder: (_, index) => VKVideoCard(video: videos[index]),
                ),
        );
}

class VKVideoCard extends StatelessWidget {
  final VideoVM video;

  VKVideoCard({@required this.video});

  @override
  Widget build(BuildContext context) => Card(
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              BlocBuilder<UIBloc, UIState>(
                builder: (_, state) => state.kittenPreview
                    ? Image.asset("assets/kitten1.jpg")
                    : Image.network(video.preview, fit: BoxFit.fill),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        video.title,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Chip(label: Text(video.duration)),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            ],
          ),
          onTap: () => launch(video.url),
        ),
      );
}

class VKVideoQueryInput extends StatefulWidget {
  final String initialQuery;

  const VKVideoQueryInput({Key key, this.initialQuery}) : super(key: key);

  @override
  _VKVideoQueryInputState createState() => _VKVideoQueryInputState();
}

class _VKVideoQueryInputState extends State<VKVideoQueryInput> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialQuery;
  }

  @override
  void didUpdateWidget(VKVideoQueryInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.text = widget.initialQuery;
  }

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "что будем искать?",
        suffixIcon: IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {
            context.bloc<VKBloc>().add(VKVideoSearchStarted(controller.text));
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),
      ),
    );
}

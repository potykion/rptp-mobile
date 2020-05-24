import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rptpmobile/core/blocs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs.dart';
import 'models.dart';

class VKVideosGrid extends StatelessWidget {
  final List<VKVideo> videos;

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
              : GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  children: videos.map((v) => VKVideoCard(video: v)).toList(),
                ),
        );
}

class VKVideoCard extends StatelessWidget {
  final VKVideo video;

  VKVideoCard({@required this.video});

  @override
  Widget build(BuildContext context) => Card(
        child: GestureDetector(
          child: Column(
            children: <Widget>[
              BlocBuilder<UIBloc, UIState>(
                builder: (_, state) => state.kittenPreview
                    ? Image.asset("assets/kitten1.jpg")
                    : Image.network(video.imageMoreThan600px, fit: BoxFit.fill),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(video.title),
                    ),
                    Chip(label: Text(video.durationString)),
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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              context.bloc<VKBloc>().add(VKVideoSearchStarted(controller.text));
              FocusScope.of(context).requestFocus(new FocusNode());
            },
          )),
    );
  }
}

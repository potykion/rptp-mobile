import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rptpmobile/actress/blocs.dart';
import 'package:rptpmobile/core/blocs.dart';
import '../vk/blocs.dart';
import 'db.dart';
import 'models.dart';

class ActressCard extends StatelessWidget {
  final Actress actress;

  const ActressCard({Key key, this.actress}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  child: Image.network(actress.ptgThumbnail),
                  borderRadius: BorderRadius.circular(5),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    actress.name,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          context.bloc<UIBloc>().add(PageChangedEvent(AppPage.videos));
          context.bloc<VKBloc>().add(VKVideoSearchStarted(actress.name));
        },
      );
}

class RandomActressFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: () async {
          var actress = await context.read<ActressRepo>().getRandom();
          context.bloc<VKBloc>().add(VKVideoSearchStarted(actress.name));
        },
        child: Icon(Icons.autorenew),
      );
}

class ActressNamePatternInput extends StatefulWidget {
  @override
  _ActressNamePatternInputState createState() =>
      _ActressNamePatternInputState();
}

class _ActressNamePatternInputState extends State<ActressNamePatternInput> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = context.bloc<ActressBloc>().state.actressNamePattern;
    controller.addListener(() => context
        .bloc<ActressBloc>()
        .add(ActressNamePatternSet(controller.text)));
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: "кого будем искать?"
    ),
  );
}

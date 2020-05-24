import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
        decoration: InputDecoration(hintText: "кого будем искать?"),
      );
}

class ActressGrid extends StatelessWidget {
  final List<Actress> actresses;

  const ActressGrid({Key key, this.actresses}) : super(key: key);

  @override
  Widget build(BuildContext context) => StaggeredGridView.countBuilder(
        itemCount: actresses.length,
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        padding: EdgeInsets.all(8),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        itemBuilder: (_, index) => ActressCard(actress: actresses[index]),
      );
}

class ActressStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<ActressBloc, ActressState>(
        builder: (BuildContext context, ActressState state) => Column(
          children: [
            ListTile(
              title: Text("Актрис в базе: ${state.actresses.length}"),
              subtitle:
                  Text("Последнее обновление: ${state.lastActressDbUpdateStr}"),
              trailing: IconButton(
                icon: Icon(Icons.autorenew),
                onPressed: state.pageState == ActressPageState.dbRefresh
                    ? null
                    : () => context
                        .bloc<ActressBloc>()
                        .add(DbRefreshStartedEvent()),
              ),
            ),
            BlocBuilder<ActressBloc, ActressState>(
              builder: (BuildContext context, state) =>
                  state.pageState == ActressPageState.dbRefresh
                      ? LinearProgressIndicator(value: state.dbRefreshProgress)
                      : Container(),
            ),
          ],
        ),
      );
}

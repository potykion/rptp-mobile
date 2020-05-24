import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rptpmobile/core/blocs.dart';
import '../vk/blocs.dart';
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

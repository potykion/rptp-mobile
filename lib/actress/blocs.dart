import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:rptpmobile/actress/db.dart';
import 'package:rptpmobile/ptg/services.dart';
import 'package:rptpmobile/ptg/view_models.dart';

import 'models.dart';

enum ActressPageState {
  dbCheck,
  emptyDb,
  notEmptyDb,
  dbRefresh,
}

class ActressState {
  final ActressPageState pageState;
  final double dbRefreshProgress;
  final String ptgProxyKey;
  final List<Actress> actresses;
  final String actressNamePattern;
  final DateTime lastActressDbUpdate;

  ActressState(
      {this.pageState = ActressPageState.dbCheck,
      this.dbRefreshProgress = 0,
      ptgProxyKey,
      this.actresses = const [],
      this.actressNamePattern = "",
      this.lastActressDbUpdate})
      : this.ptgProxyKey = ptgProxyKey ?? DotEnv().env['PTG_PROXY_KEY'];

  List<Actress> get matchingActresses => actresses
      .where(
        (actress) => actress.name
            .toLowerCase()
            .contains(actressNamePattern.toLowerCase()),
      )
      .toList();

  String get lastActressDbUpdateStr => lastActressDbUpdate != null
      ? DateFormat.yMMMMd("ru_RU").format(lastActressDbUpdate)
      : "Давненько не было";

  copyWith({
    ActressPageState pageState,
    double actressBaseRefreshProgress,
    List<Actress> actresses,
    String actressNamePattern,
    DateTime lastActressDbUpdate,
  }) =>
      ActressState(
        pageState: pageState ?? this.pageState,
        dbRefreshProgress: actressBaseRefreshProgress ?? this.dbRefreshProgress,
        actresses: actresses ?? this.actresses,
        actressNamePattern: actressNamePattern ?? this.actressNamePattern,
        lastActressDbUpdate: lastActressDbUpdate ?? this.lastActressDbUpdate,
      );
}

class ActressEvent {}

class DbCheckedEvent extends ActressEvent {}

class DbRefreshStartedEvent extends ActressEvent {}

class ActressNamePatternSet extends ActressEvent {
  final String pattern;

  ActressNamePatternSet(this.pattern);
}

class ActressBloc extends Bloc<ActressEvent, ActressState> {
  final ActressRepo actressRepo;

  ActressBloc(this.actressRepo);

  @override
  ActressState get initialState => ActressState();

  @override
  Stream<ActressState> mapEventToState(ActressEvent event) async* {
    if (event is DbCheckedEvent) {
      var actresses = await actressRepo.list();
      yield state.copyWith(
        pageState: actresses.length > 0
            ? ActressPageState.notEmptyDb
            : ActressPageState.emptyDb,
        actresses: actresses,
      );
    } else if (event is DbRefreshStartedEvent) {
      yield state.copyWith(
        pageState: ActressPageState.dbRefresh,
        actressBaseRefreshProgress: 0,
      );

      List<Actress> actresses = [];
      var actressLoad = AlphabetPTGActressLoad(proxyKey: state.ptgProxyKey);
      await for (var letterActress in actressLoad.actressStream) {
        await this.actressRepo.bulkInsert(letterActress.actresses);
        actresses.addAll(letterActress.actresses);

        var progress = LetterProgress(letterActress.letter).letterProgress;
        yield state.copyWith(actressBaseRefreshProgress: progress);
      }

      yield state.copyWith(
        pageState: ActressPageState.notEmptyDb,
        actresses: actresses,
        lastActressDbUpdate: DateTime.now(),
      );
    } else if (event is ActressNamePatternSet) {
      yield state.copyWith(actressNamePattern: event.pattern);
    }
  }
}

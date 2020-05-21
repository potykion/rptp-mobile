import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rptpmobile/actress/db.dart';

import '../ptg.dart';
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

  ActressState({
    this.pageState = ActressPageState.dbCheck,
    this.dbRefreshProgress = 0,
    ptgProxyKey,
    this.actresses = const [],
  }) : this.ptgProxyKey = ptgProxyKey ?? DotEnv().env['PTG_PROXY_KEY'];

  copyWith({
    ActressPageState pageState,
    double actressBaseRefreshProgress,
    List<Actress> actresses,
  }) =>
      ActressState(
        pageState: pageState ?? this.pageState,
        dbRefreshProgress: actressBaseRefreshProgress ?? this.dbRefreshProgress,
        actresses: actresses ?? this.actresses,
      );
}

class ActressEvent {}

class DbCheckedEvent extends ActressEvent {}

class DbRefreshStartedEvent extends ActressEvent {}

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
      yield state.copyWith(pageState: ActressPageState.dbRefresh);

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
      );
    }
  }
}

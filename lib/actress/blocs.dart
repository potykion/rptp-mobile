import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rptpmobile/actress.dart';
import '../ptg.dart';

class ActressState {
  final double actressBaseRefreshProgress;
  final String ptgProxyKey;

  ActressState({this.actressBaseRefreshProgress = 0, ptgProxyKey})
      : this.ptgProxyKey = ptgProxyKey ?? DotEnv().env['PTG_PROXY_KEY'];

  copyWith({double actressBaseRefreshProgress}) => ActressState(
        actressBaseRefreshProgress:
            actressBaseRefreshProgress ?? this.actressBaseRefreshProgress,
      );
}

class ActressEvent {}

class ActressBaseRefreshStartedEvent extends ActressEvent {}

class ActressBloc extends Bloc<ActressEvent, ActressState> {
  @override
  ActressState get initialState => ActressState();

  @override
  Stream<ActressState> mapEventToState(ActressEvent event) async* {
    if (event is ActressBaseRefreshStartedEvent) {
      var actressLoad = AlphabetPTGActressLoad(proxyKey: state.ptgProxyKey);
      await for (var letterActress in actressLoad.actressStream) {
        // TODO: save letter actress
        var progress =
            (actressLoad.alphabet.indexOf(letterActress.letter) + 1) /
                actressLoad.alphabet.length;
        yield state.copyWith(actressBaseRefreshProgress: progress);
      }
    }
  }
}

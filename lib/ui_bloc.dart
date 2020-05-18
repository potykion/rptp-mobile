import 'package:bloc/bloc.dart';

enum AppPage { videos, actress, settings }

class UIState {
  final AppPage currentPage;
  final bool kittenPreview;

  UIState({this.currentPage, this.kittenPreview = true});

  get currentPageIndex => currentPage.index;

  copyWith({
    AppPage currentPage,
  }) =>
      UIState(
        currentPage: currentPage ?? this.currentPage,
      );
}

abstract class UIEvent {}

class PageChangedEvent extends UIEvent {
  final AppPage page;

  PageChangedEvent(this.page);

  factory PageChangedEvent.fromIndex(int index) =>
      PageChangedEvent(AppPage.values[index]);
}

class UIBloc extends Bloc<UIEvent, UIState> {
  @override
  UIState get initialState => UIState(currentPage: AppPage.videos);

  @override
  Stream<UIState> mapEventToState(UIEvent event) async* {
    if (event is PageChangedEvent) {
      yield state.copyWith(currentPage: event.page);
    }
  }
}

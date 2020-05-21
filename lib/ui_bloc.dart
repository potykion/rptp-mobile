import 'package:bloc/bloc.dart';

enum AppPage { videos, actress, settings }

class UIState {
  final AppPage currentPage;
  final dynamic initialPageData;
  final bool kittenPreview;
  

  UIState({this.currentPage, this.initialPageData, this.kittenPreview = true});

  get currentPageIndex => currentPage.index;

  copyWith({
    AppPage currentPage,
    bool kittenPreview,
    dynamic initialPageData
  }) =>
      UIState(
        currentPage: currentPage ?? this.currentPage,
        initialPageData: initialPageData ?? this.initialPageData,
        kittenPreview: kittenPreview ?? this.kittenPreview,
      );
}

abstract class UIEvent {}

class PageChangedEvent extends UIEvent {
  final AppPage page;
  final dynamic extra;

  PageChangedEvent(this.page, {this.extra});

  factory PageChangedEvent.fromIndex(int index) =>
      PageChangedEvent(AppPage.values[index]);
}

class KittenPreviewChanged extends UIEvent {
  final bool kittenPreview;

  KittenPreviewChanged(this.kittenPreview);
}

class UIBloc extends Bloc<UIEvent, UIState> {
  @override
  UIState get initialState => UIState(currentPage: AppPage.videos);

  @override
  Stream<UIState> mapEventToState(UIEvent event) async* {
    if (event is PageChangedEvent) {
      yield state.copyWith(currentPage: event.page, initialPageData: event.extra);
    }
    else if (event is KittenPreviewChanged) {
      yield state.copyWith(kittenPreview: event.kittenPreview);
    }
  }
}

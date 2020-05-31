import 'models.dart';

class NotExistingActressesFilter {
  final List<Actress> actressesToFilter;
  final List<Actress> existingActresses;

  NotExistingActressesFilter({this.actressesToFilter, this.existingActresses});

  get filtered {
    List<String> existingActressIds =
        existingActresses.map((a) => a.ptgId).toList();
    List<Actress> notExistingActresses = actressesToFilter
        .where((a) => !existingActressIds.contains(a.ptgId))
        .toList();
    return notExistingActresses;
  }
}

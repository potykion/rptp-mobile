intToBool(int int_) => int_ == 1;

timestampToDateTime(int timestamp) =>
    DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

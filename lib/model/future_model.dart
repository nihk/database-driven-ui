import 'dart:async';

import 'package:flutter/foundation.dart';

// todo: pagination
class FutureModel<Data> extends ChangeNotifier {
  Future<List<Data>> _future;
  Future<List<Data>> get future => _future;

  FutureModel(this._future);

  void setFuture(Future<List<Data>> future) {
    _future = future;
    notifyListeners();
  }
}
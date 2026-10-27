import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Coalesces related writes into one refresh notification.
class RefreshCubit extends Cubit<int> {
  RefreshCubit() : super(0);
  bool _scheduled = false;
  void refresh() {
    if (_scheduled || isClosed) return;
    _scheduled = true;
    scheduleMicrotask(() {
      _scheduled = false;
      if (!isClosed) emit(state + 1);
    });
  }
}

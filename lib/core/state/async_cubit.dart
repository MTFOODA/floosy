import 'package:flutter_bloc/flutter_bloc.dart';
import 'load_state.dart';

/// Prevents obsolete loads (including loads for a previous account) from
/// overwriting newer state. Errors remain observable without escaping the zone.
abstract class AsyncCubit<T> extends Cubit<LoadState<T>> {
  AsyncCubit() : super(const LoadState.loading());
  int _generation = 0;

  Future<void> load(Future<T> Function() read) async {
    if (isClosed) return;
    final generation = ++_generation;
    emit(LoadState.loading(value: state.value));
    try {
      final result = await read();
      if (!isClosed && generation == _generation) emit(LoadState.data(result));
    } catch (error, stack) {
      if (!isClosed && generation == _generation) {
        emit(LoadState.failure(error, stack, value: state.value));
      }
    }
  }

  void clear(T empty) {
    _generation++;
    if (!isClosed) emit(LoadState.data(empty));
  }

  /// A committed command supersedes any read that began before it.
  void replace(LoadState<T> next) {
    _generation++;
    if (!isClosed) emit(next);
  }
}

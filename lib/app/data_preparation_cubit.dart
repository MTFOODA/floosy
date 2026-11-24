import 'package:flutter_bloc/flutter_bloc.dart';

class DataPreparationState {
  final bool loading;
  final bool failed;
  final String? userId;
  final bool timedOut;
  const DataPreparationState({
    this.loading = false,
    this.failed = false,
    this.userId,
    this.timedOut = false,
  });
}

class DataPreparationCubit extends Cubit<DataPreparationState> {
  DataPreparationCubit() : super(const DataPreparationState());
  void loading(String user) =>
      emit(DataPreparationState(loading: true, userId: user));
  void failed(String user, {bool timedOut = false}) => emit(
    DataPreparationState(failed: true, userId: user, timedOut: timedOut),
  );
  void ready(String? user) => emit(DataPreparationState(userId: user));
}

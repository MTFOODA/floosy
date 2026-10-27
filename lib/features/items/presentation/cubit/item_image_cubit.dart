import '../../../../core/state/async_cubit.dart';
import '../../../../domain/repositories/financial_queries_repository.dart';

class ItemImageCubit extends AsyncCubit<String?> {
  final FinancialQueriesRepository _queries;
  ItemImageCubit(this._queries);
  Future<void> resolve(String reference) =>
      load(() => _queries.resolveImage(reference));
}

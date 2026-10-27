import '../../domain/entities/user_model.dart';
import '../../domain/repositories/financial_queries_repository.dart';
import 'async_cubit.dart';

class BankCatalogCubit extends AsyncCubit<List<Bank>> {
  final FinancialQueriesRepository _queries;
  BankCatalogCubit(this._queries);
  Future<List<Bank>> getBanks() => _queries.getBanks();
  Future<void> reload() => load(_queries.getBanks);
}

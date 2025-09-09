import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_latest_products_use_case.dart';
import 'latest_products_state.dart';

class LatestProductsCubit extends Cubit<LatestProductsState> {
  final GetLatestProductsUseCase getLatestProductsUseCase;

  LatestProductsCubit({required this.getLatestProductsUseCase})
    : super(LatestProductsInitial());

  Future<void> getLatestProducts() async {
    if (isClosed) return;
    
    try {
      emit(LatestProductsLoading());
      final products = await getLatestProductsUseCase();
      
      if (!isClosed) {
        emit(LatestProductsLoaded(products: products));
      }
    } catch (e) {
      if (!isClosed) {
        emit(LatestProductsError(message: e.toString()));
      }
    }
  }
}

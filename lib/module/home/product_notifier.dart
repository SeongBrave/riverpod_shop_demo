import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_shop_demo/api/produt_api.dart';
import 'package:riverpod_shop_demo/state/list_view_notifier.dart';
import 'package:riverpod_shop_demo/state/list_view_state.dart';

import 'model/product_model/product_model.dart';

// final sessionTimeProvider StreamProvider<int>((_=getSessionTime(),

final productListProvider = StateNotifierProvider<
    ListViewStateNotifier<ProductModel>,
    ListViewState<List<ProductModel>>>((ref) {
  final api = ref.watch(apiService);
  return ListViewStateNotifier<ProductModel>(
      pageIndex: 1,
      pageSize: 10,
      fetchItems: (int pageIndex, int pageSize) {
        return api.fetchProducts(pageIndex: pageIndex, pageSize: pageSize);
      });
});

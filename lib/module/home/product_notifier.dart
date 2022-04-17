import 'package:flutter_easyrefresh/easy_refresh.dart';
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

class ProductStateNotifier
    extends StateNotifier<ListViewState<List<ProductModel>>> {
  ProductStateNotifier({required this.api})
      : super(const ListViewState.loading()) {
    init();
  }
  final EasyRefreshController _refreshController = EasyRefreshController();

  EasyRefreshController get refreshController => _refreshController;

  final PoductAPI api;

  int _page = 0;
  List<ProductModel> _products = [];

  void init() {
    firstLoadPage();
  }

  Future<void> firstLoadPage() async {
    _page = 1;
    try {
      final List<ProductModel> list =
          await api.fetchProducts(pageIndex: _page, pageSize: 10);
      if (list.isEmpty) {
        state = const ListViewState.empty();
      } else {
        _products = list;
        state = ListViewState.ready(list);
      }
      _refreshController.finishRefresh(success: true);
    } catch (e) {
      state = ListViewState.error(error: e.toString());
    }
  }

  Future<void> refreshData({ToastFunction? fnToast}) async {
    _page = 1;
    try {
      // state = const ListViewState.loading();
      final List<ProductModel> list =
          await api.fetchProducts(pageIndex: _page, pageSize: 10);
      if (list.isEmpty) {
        state = const ListViewState.empty();
      } else {
        _products = list;
        state = ListViewState.ready(list);
      }
      _refreshController.finishRefresh(success: true);
    } catch (e) {
      _refreshController.finishRefresh(success: false);
      if (fnToast != null) {
        fnToast(e.toString());
      }
    }
  }

  Future<void> loadMore({ToastFunction? fnToast}) async {
    _page += 1;
    try {
      final List<ProductModel> list =
          await api.fetchProducts(pageIndex: _page, pageSize: 10);
      if (list.isNotEmpty) {
        _products.addAll(list);
        state = ListViewState.ready(_products);
      }
      _refreshController.finishLoad(success: true, noMore: true);
    } catch (e) {
      _refreshController.finishLoad(success: false, noMore: false);
      if (fnToast != null) {
        fnToast(e.toString());
      }
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

final productModelProvider = StateNotifierProvider<ProductStateNotifier,
        ListViewState<List<ProductModel>>>(
    (ref) => ProductStateNotifier(api: ref.watch(apiService)));

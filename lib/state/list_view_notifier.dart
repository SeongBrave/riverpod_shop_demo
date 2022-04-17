import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'list_view_state.dart';

typedef ToastFunction = void Function(String error, {Error? e});

/*
1. 首次进来显示loadding，第二次就系那是refresh的动画
2. 错误也是首次进来发生错误才显示，第二次就toast
*/
class ListViewStateNotifier<T> extends StateNotifier<ListViewState<List<T>>> {
  ListViewStateNotifier({
    required this.fetchItems,
    this.pageSize = 10,
    this.pageIndex = 1,
  }) : super(const ListViewState.loading()) {
    init();
  }
  final EasyRefreshController _refreshController = EasyRefreshController();

  EasyRefreshController get refreshController => _refreshController;

  final Future<List<T>> Function(int pageIndex, int pageSize) fetchItems;

  int _page = 0;
  int pageSize = 10;
  int pageIndex = 1;
  List<T> _items = [];

  void init() {
    firstLoadPage();
  }

  Future<void> firstLoadPage() async {
    _page = pageIndex;
    try {
      final List<T> list = await fetchItems(_page, pageSize);
      if (list.isEmpty) {
        state = const ListViewState.empty();
      } else {
        _items = list;
        state = ListViewState.ready(list);
      }
      _refreshController.finishRefresh(
          success: true, noMore: list.length < pageSize);
      _refreshController.resetLoadState();
      _page += 1;
    } catch (e) {
      state = ListViewState.error(error: e.toString());
    }
  }

  Future<void> refreshData({ToastFunction? fnToast}) async {
    _page = pageIndex;
    try {
      final List<T> list = await fetchItems(_page, pageSize);
      if (list.isEmpty) {
        state = const ListViewState.empty();
      } else {
        _items = list;
        // state = ListViewState.ready(list);
        state = const ListViewState.error(error: "发生错误啦");
      }
      _refreshController.finishRefresh(
          success: true, noMore: list.length < pageSize);
      _refreshController.resetLoadState();
      _page += 1;
    } catch (e) {
      _refreshController.finishRefresh(success: false);
      if (fnToast != null) {
        fnToast(e.toString());
      }
      // state = ListViewState.error(error: e.toString());
    }
  }

  Future<void> loadMore({ToastFunction? fnToast}) async {
    try {
      final List<T> list = await fetchItems(_page, pageSize);
      if (list.isNotEmpty) {
        _items.addAll(list);
        state = ListViewState.ready(_items);
      }
      _refreshController.finishLoad(
          success: true, noMore: list.length < pageSize);
      _page += 1;
    } catch (e) {
      _refreshController.finishLoad(success: false);
      // state = ListViewState.error(error: e.toString());
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

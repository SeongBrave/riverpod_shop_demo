// Flutter imports:
// Project imports:

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_shop_demo/module/home/product_notifier.dart';

import 'model/product_model/product_model.dart';

final sessionTimeProvider = StreamProvider<int>((ref) {
  return getsessionTime();
});

Stream<int> getsessionTime() {
  return Stream.periodic(
      const Duration(seconds: 1), (sessionTime) => sessionTime.toInt());
}

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习下商品信息'),
        leading: Center(child: Consumer(
          builder: (context, ref, child) {
            final ret = ref.watch(sessionTimeProvider);
            return ret.maybeWhen(
              data: (data) => Text(
                data.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              orElse: () => const Text(
                '获取中',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          },
        )),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(productListProvider);
          return state.when(
            empty: () => const Text(
              'empty',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            ready: (data) => _buildContent(context, ref, data),
            error: (String error) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(error),
                    ),
                    TextButton(
                      child: const Text("重试下"),
                      onPressed: () {
                        ref.refresh(productListProvider);
                      },
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: Text("loading..")),
          );
        },
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(productListProvider.notifier);
          return FloatingActionButton(
            onPressed: () {
              state.refreshData(fnToast: ((error, {e}) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      error,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                );
              }));
            },
            child: const Icon(Icons.refresh),
          );
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext ctx, WidgetRef ref, List<ProductModel> data) {
    return Center(
      child: EasyRefresh(
        controller: ref.watch(productListProvider.notifier).refreshController,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: ((context, index) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 6,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,
              ),
              child: Text(
                data[index].title ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }),
        ),
        onRefresh: () async {
          ref.watch(productListProvider.notifier).refreshData(
              fnToast: ((error, {e}) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                  content: Text(
                error,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              )),
            );
          }));
        },
        onLoad: () async {
          ref.watch(productListProvider.notifier).loadMore(
              fnToast: ((error, {e}) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                  content: Text(
                error,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              )),
            );
          }));
        },
      ),
    );
  }
}

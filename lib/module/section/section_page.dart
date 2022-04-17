import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_shop_demo/module/home/product_page.dart';
import 'package:riverpod_shop_demo/provider/navigation_provider.dart';

class SectionPage extends ConsumerWidget {
  const SectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageModel navigation = ref.watch(navigationProvider);
    return Scaffold(
      body: currentScreen(navigation.index),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: navigation.index,
          onTap: (index) {
            ref.read(navigationProvider.notifier).selectPage(index);
          },
          items: const [
            BottomNavigationBarItem(
              label: "首页",
              icon: Icon(
                Icons.home,
                // key: Keys.NAV_HOME,
              ),
            ),
            BottomNavigationBarItem(
              label: "搜索",
              icon: Icon(
                Icons.search,
              ),
            ),
            BottomNavigationBarItem(
              label: "设置",
              icon: Icon(
                Icons.settings,
              ),
            ),
          ]),
    );
  }

  Widget currentScreen(int index) {
    switch (index) {
      case 0:
        return const ProductPage();
      case 1:
        return const PageDetail(
          title: "分类",
        );
      case 2:
        return const PageDetail(
          title: "购物车",
        );
      default:
        return const PageDetail(
          title: "我的",
        );
    }
  }
}

class PageDetail extends StatelessWidget {
  const PageDetail({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}

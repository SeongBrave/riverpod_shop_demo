// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_shop_demo/module/home/model/product_model/product_model.dart';
// final apiService Provider((ref)=>PoductAPI());

final apiService = Provider((ref) => PoductAPI());

class PoductAPI {
  Future<List<ProductModel>> fetchProducts(
      {required int pageIndex, required int pageSize}) async {
    var dio = Dio(BaseOptions(
      connectTimeout: 3000,
      receiveTimeout: 3000,
    ));
    var response = await dio.get(
        'https://jsonplaceholder.typicode.com/photos?_start=$pageIndex&_limit=$pageSize');
    var modelList = List<ProductModel>.from(
        response.data.map((x) => ProductModel.fromJson(x)));
    return modelList;
  }
}

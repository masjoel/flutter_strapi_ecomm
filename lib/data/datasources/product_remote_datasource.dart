// import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_strapi_ecomm/common/global_variables.dart';
import 'package:flutter_strapi_ecomm/data/models/responses/list_product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  Future<Either<String, ListProductResponseModel>> getAllProduct() async {
    final response =
        await http.get(Uri.parse('${GlobalVariables.baseUrl}/api/products'));

    if (response.statusCode == 200) {
      return Right(ListProductResponseModel.fromRawJson(response.body));
    } else {
      return const Left('proses gagal');
    }
  }

  Future<Either<String, ListProductResponseModel>> search(String name) async {
    final response =
        await http.get(Uri.parse('${GlobalVariables.baseUrl}/api/products?filters[name][\$contains]=$name'));

    if (response.statusCode == 200) {
      return Right(ListProductResponseModel.fromRawJson(response.body));
    } else {
      return const Left('proses gagal');
    }
  }
}

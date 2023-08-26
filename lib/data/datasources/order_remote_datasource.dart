import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_strapi_ecomm/data/datasources/auth_local_datasource.dart';
import 'package:flutter_strapi_ecomm/data/models/order_request_model.dart';
import 'package:flutter_strapi_ecomm/data/models/responses/list_order_response_model.dart';
import 'package:flutter_strapi_ecomm/data/models/responses/order_response_model.dart';
import 'package:http/http.dart' as http;

import '../../common/global_variables.dart';

class OrderRemoteDatasource {
  Future<Either<String, OrderResponseModel>> order(
      OrderRequestModel model) async {
    // ignore: unused_local_variable
    final tokenJwt = await AuthLocalDatasource().getToken();
    // print(tokenJwt);
    // print(model.toRawJson());
    final response = await http.post(
      Uri.parse('${GlobalVariables.baseUrl}/api/orders'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenJwt'
      },
      body: model.toRawJson(),
    );

    if (response.statusCode == 200) {
      return Right(OrderResponseModel.fromJson(response.body));
    } else {
      return const Left('server error');
    }
  }

  Future<Either<String, ListOrderResponseModel>> listOrder() async {
    final authData = await AuthLocalDatasource().getAuthData();

    final response = await http.get(
      Uri.parse(
          '${GlobalVariables.baseUrl}/api/orders?filters[userId][\$eq]=${authData.user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData.jwt}'
      },
    );

    if (response.statusCode == 200) {
      return Right(ListOrderResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return const Left('server error');
    }
  }
}
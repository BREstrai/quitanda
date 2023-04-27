import 'package:quitanda/src/constants/endpoints.dart';
import 'package:quitanda/src/models/cart_item_model.dart';
import 'package:quitanda/src/models/order_model.dart';
import 'package:quitanda/src/pages/orders/result/orders_result.dart';
import 'package:quitanda/src/services/http_manager.dart';

class OrdersRepository {
  final _httpManager = HttpManager();

  Future<OrdersResult<List<OrderModel>>> getAllOrders({
    required String userId,
    required String token,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllOrders,
        method: HttMethods.post,
        body: {
          'user': userId,
        },
        header: {
          'X-Parse-Session-Token': token,
        });

    if (result['result'] != null) {
      List<OrderModel> order = List<Map<String, dynamic>>.from(result['result'])
          .map(OrderModel.fromJson)
          .toList();
      return OrdersResult<List<OrderModel>>.success(order);
    } else {
      return OrdersResult.error("Não foi possível recuperar os pedidos.");
    }
  }

  Future<OrdersResult<List<CartItemModel>>> getOrderItems({
    required String orderId,
    required String token,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getOrderItems,
        method: HttMethods.post,
        body: {
          'orderId': orderId,
        },
        header: {
          'X-Parse-Session-Token': token,
        });

    if (result['result'] != null) {
      List<CartItemModel> items =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();
      return OrdersResult<List<CartItemModel>>.success(items);
    } else {
      return OrdersResult.error("Não foi possível recuperar os pedidos.");
    }
  }
}

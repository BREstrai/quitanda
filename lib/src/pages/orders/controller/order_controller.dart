import 'package:get/get.dart';
import 'package:quitanda/src/models/cart_item_model.dart';
import 'package:quitanda/src/models/order_model.dart';
import 'package:quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda/src/pages/orders/repository/orders_repository.dart';
import 'package:quitanda/src/pages/orders/result/orders_result.dart';
import 'package:quitanda/src/services/utils_service.dart';

class OrderController extends GetxController {
  final ordersRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();
  bool isLoading = false;

  OrderModel order;
  OrderController(this.order);

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOderItems() async {
    setLoading(true);

    final OrdersResult<List<CartItemModel>> result =
        await ordersRepository.getOrderItems(
      orderId: order.id,
      token: authController.user.token!,
    );

    setLoading(false);

    result.when(
      success: (items) {
        order.items = items;
        update();
      },
      error: (message) {
        utilsServices.showToasts(
          descricao: message,
          isError: true,
        );
      },
    );
  }
}

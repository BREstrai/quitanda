import 'package:get/get.dart';
import 'package:quitanda/src/models/order_model.dart';
import 'package:quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda/src/pages/orders/repository/orders_repository.dart';
import 'package:quitanda/src/pages/orders/result/orders_result.dart';
import 'package:quitanda/src/services/utils_service.dart';

class AllOrdersControllers extends GetxController {
  List<OrderModel> allOrders = [];
  final ordersRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
      userId: authController.user.id!,
      token: authController.user.token!,
    );

    result.when(
      success: (order) {
        allOrders = order
          ..sort(((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!)));
        update();
      },
      error: (message) {
        utilsServices.showToasts(descricao: message);
      },
    );
  }
}

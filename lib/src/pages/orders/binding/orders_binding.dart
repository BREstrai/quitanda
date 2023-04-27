import 'package:get/get.dart';
import 'package:quitanda/src/pages/orders/controller/all_orders_controller.dart';

class OrdersBindigs extends Bindings {
  @override
  void dependencies() {
    Get.put(AllOrdersControllers());
  }
}

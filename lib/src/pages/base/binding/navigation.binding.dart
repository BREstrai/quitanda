import 'package:get/get.dart';
import 'package:quitanda/src/pages/base/controller/navigation_controller.dart';

class NavigationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavigationController());
  }
}

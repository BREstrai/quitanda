import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda/src/pages/orders/controller/all_orders_controller.dart';
import 'package:quitanda/src/pages/orders/view/components/order_tile.dart';

class OrderTab extends StatelessWidget {
  const OrderTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos"),
      ),
      body: GetBuilder<AllOrdersControllers>(builder: (controller) {
        return RefreshIndicator(
          onRefresh: () => controller.getAllOrders(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (_, index) =>
                OrderTile(order: controller.allOrders[index]),
            itemCount: controller.allOrders.length,
          ),
        );
      }),
    );
  }
}

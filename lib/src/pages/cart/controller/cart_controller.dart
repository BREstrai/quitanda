import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda/src/models/cart_item_model.dart';
import 'package:quitanda/src/models/item_model.dart';
import 'package:quitanda/src/models/order_model.dart';
import 'package:quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda/src/pages/cart/repository/cart_repository.dart';
import 'package:quitanda/src/pages/cart/result/cart_result.dart';
import 'package:quitanda/src/pages/common_widgets/payment_dialog.dart';
import 'package:quitanda/src/services/utils_service.dart';

class CartController extends GetxController {
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();

  List<CartItemModel> cartItems = [];

  bool isCheckoudloading = false;

  @override
  void onInit() {
    super.onInit();

    getItemsCart();
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item.id == item.id);
  }

  Future<bool> changeItemQuantity({
    required CartItemModel item,
    required int quantity,
  }) async {
    final result = await cartRepository.changeItemQuantity(
      token: authController.user.token!,
      cartItemId: item.id,
      quantity: quantity,
    );

    if (result) {
      if (quantity == 0) {
        cartItems.removeWhere(
          (cartItem) => cartItem.id == item.id,
        );
      } else {
        cartItems.firstWhere((cartItem) => cartItem.id == item.id).quantity =
            quantity;
      }

      update();
    } else {
      utilsServices.showToasts(
        descricao: 'Ocorreu um erro ao alterar a quantidade do produto',
        isError: true,
      );
    }

    return result;
  }

  Future<void> addItemToCart(
      {required ItemModel item, int quantity = 1}) async {
    int itemIndex = getItemIndex(item);

    if (itemIndex >= 0) {
      final product = cartItems[itemIndex];
      final result = await changeItemQuantity(
          item: product, quantity: (product.quantity + quantity));
    } else {
      final CartResult<String> result = await cartRepository.addItemToCart(
        userId: authController.user.id!,
        token: authController.user.token!,
        productId: item.id,
        quantity: quantity,
      );

      result.when(
        success: (cartItemId) {
          cartItems.add(
            CartItemModel(id: cartItemId, item: item, quantity: quantity),
          );
        },
        error: (message) {
          utilsServices.showToasts(
            descricao: message,
            isError: true,
          );
        },
      );
    }

    update();
  }

  double cartTotalPrice() {
    double total = 0;

    for (final item in cartItems) {
      total += item.totalPrice();
    }
    return total;
  }

  void setCheckoutLoading(bool value) {
    isCheckoudloading = value;
    update();
  }

  //<CartResult<OrderModel>>
  Future checkouCart() async {
    setCheckoutLoading(true);

    CartResult<OrderModel> result = await cartRepository.checkoutCart(
      token: authController.user.token!,
      total: cartTotalPrice(),
    );

    setCheckoutLoading(false);

    result.when(
      success: (order) {
        cartItems.clear;
        update();

        showDialog(
          context: Get.context!,
          builder: (_) {
            return PaymentDialog(
              order: order,
            );
          },
        );
      },
      error: (message) {
        utilsServices.showToasts(
          descricao: message,
        );
      },
    );
  }

  Future<void> getItemsCart() async {
    final CartResult<List<CartItemModel>> result =
        await cartRepository.getCartItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    result.when(
      success: (data) {
        cartItems = data;
        update();
        print(cartItems);
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

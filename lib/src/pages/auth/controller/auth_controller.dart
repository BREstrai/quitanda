import 'package:get/get.dart';
import 'package:quitanda/src/constants/storage_keys.dart';
import 'package:quitanda/src/models/user_model.dart';
import 'package:quitanda/src/pages/auth/repository/auth_repository.dart';
import 'package:quitanda/src/pages/auth/result/auth_result.dart';
import 'package:quitanda/src/pages_routes/app_pages.dart';
import 'package:quitanda/src/services/utils_service.dart';

class AuthController extends GetxController {
  final authRepository = AuthRepository();
  final utilsServices = UtilsServices();

  UserModel user = UserModel();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    validateToken();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;

    final result = await authRepository.changePassword(
      email: user.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
      token: user.token!,
    );

    isLoading.value = false;

    if (result) {
      utilsServices.showToasts(
        descricao: 'A senha atual está incorreta',
        isError: true,
      );

      signOut();
    } else {
      utilsServices.showToasts(
        descricao: 'A senha atual está incorreta',
        isError: true,
      );
    }
  }

  Future<void> signUp() async {
    AuthResult result = await authRepository.signUp(user);

    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProccedToBase();
      },
      error: (message) {
        utilsServices.showToasts(
          descricao: message,
          isError: true,
        );
      },
    );
  }

  Future<void> forgotPassword(String email) async {
    await authRepository.forgotPassword(email);
  }

  Future<void> validateToken() async {
    String? token = await utilsServices.getLocalData(key: StorageKeys.token);

    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    } else {
      AuthResult result = await authRepository.validateToken(token);

      result.when(
        success: (user) {
          this.user = user;
          saveTokenAndProccedToBase();
        },
        error: (message) {
          signOut();
        },
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    AuthResult result =
        await authRepository.signIn(email: email, password: password);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;

        saveTokenAndProccedToBase();
      },
      error: (message) {
        utilsServices.showToasts(
          descricao: message,
          isError: true,
        );
      },
    );
  }

  void saveTokenAndProccedToBase() {
    utilsServices.saveLocalData(
      key: StorageKeys.token,
      data: user.token!,
    );

    Get.offAllNamed(PagesRoutes.homeRoute);
  }

  Future<void> signOut() async {
    user = UserModel();

    utilsServices.removeLocalData(key: StorageKeys.token);

    Get.offAllNamed(PagesRoutes.signInRoute);
  }
}

import 'package:quitanda/src/constants/endpoints.dart';
import 'package:quitanda/src/models/user_model.dart';
import 'package:quitanda/src/pages/auth/repository/auth_errors.dart';
import 'package:quitanda/src/pages/auth/result/auth_result.dart';
import 'package:quitanda/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErrorsString(result['error']));
    }
  }

  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signin,
      method: HttMethods.post,
      body: {
        'email': email,
        'password': password,
      },
    );

    return handleUserOrError(result);
  }

  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.validateToken,
      method: HttMethods.post,
      header: {'X-Parse-Session-Token': token},
    );

    return handleUserOrError(result);
  }

  Future<AuthResult> signUp(UserModel user) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signup,
      method: HttMethods.post,
      body: user.toJson(),
    );

    return handleUserOrError(result);
  }

  Future<void> forgotPassword(String email) async {
    await _httpManager.restRequest(
        url: Endpoints.forgotPassword,
        method: HttMethods.post,
        body: {
          "email": email,
        });
  }
}

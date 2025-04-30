import 'package:get/get.dart';
import 'package:task_management/data/models/login_model.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';

class LoginController extends GetxController {
  bool _logInProgress = false;
  bool get logInProgress => _logInProgress;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    bool isSuccess = false;
    _logInProgress = true;
    update();
    Map<String, dynamic> requestBody = {"email": email, "password": password};
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      await AuthController.saveUserInformation(
        loginModel.token,
        loginModel.userModel,
      );
      isSuccess = true;
      _errorMessage = null;
    } else {
      response.errorMessage;
    }

    _logInProgress = false;
    update();
    return isSuccess;
  }
}

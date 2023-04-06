import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda/src/pages/common_widgets/custom_text_field.dart';
import 'package:quitanda/src/config/custom_colors.dart';
import 'package:quitanda/src/services/validators.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Cadastro",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),

                  //Fomulário
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(45)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            iconData: Icons.email,
                            label: "Email",
                            onSaved: (value) {
                              authController.user.email = value;
                            },
                            validator: emailValidator,
                            textInputType: TextInputType.emailAddress,
                          ),
                          CustomTextField(
                            iconData: Icons.lock,
                            label: "Senha",
                            onSaved: (value) {
                              authController.user.password = value;
                            },
                            validator: passwordValidator,
                            isSecret: true,
                          ),
                          CustomTextField(
                            iconData: Icons.person,
                            label: "Nome",
                            onSaved: (value) {
                              authController.user.name = value;
                            },
                          ),
                          CustomTextField(
                              iconData: Icons.phone,
                              label: "Celular",
                              validator: phoneValidator,
                              onSaved: (value) {
                                authController.user.phone = value;
                              },
                              inputFormatter: [phoneFormatter],
                              textInputType: TextInputType.phone),
                          CustomTextField(
                              iconData: Icons.file_copy,
                              label: "CPF",
                              onSaved: (value) {
                                authController.user.cpf = value;
                              },
                              validator: cpfValidator,
                              inputFormatter: [cpfFormatter],
                              textInputType: TextInputType.number),
                          SizedBox(
                            height: 50,
                            child: Obx(() {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: authController.isLoading.value
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();

                                          authController.signUp();

                                          FocusScope.of(context).unfocus();

                                          print(authController.user);
                                        }
                                      },
                                child: authController.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : const Text(
                                        "Cadastrar usuário",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: SafeArea(
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

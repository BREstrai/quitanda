import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda/src/pages/common_widgets/custom_text_field.dart';
import 'package:quitanda/src/services/validators.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perfil do usuário",
        ),
        actions: [
          IconButton(
            onPressed: () {
              authController.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          CustomTextField(
            iconData: Icons.email,
            label: "Email",
            initialValue: authController.user.email,
            isReadOnly: true,
          ),
          CustomTextField(
            iconData: Icons.person,
            label: "Nome",
            initialValue: authController.user.name,
            isReadOnly: true,
          ),
          CustomTextField(
            iconData: Icons.phone,
            label: "Celular",
            initialValue: authController.user.phone,
            isReadOnly: true,
          ),
          CustomTextField(
            iconData: Icons.file_copy,
            label: "CPF",
            isSecret: true,
            initialValue: authController.user.cpf,
            isReadOnly: true,
          ),

          //Botão de atualização de senha
          SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: const BorderSide(
                    color: Colors.green,
                  )),
              onPressed: () {
                updatePassword();
              },
              child: const Text(
                "Atualizar senha",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> updatePassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: Text(
                          "Atualização de senha",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: currentPasswordController,
                        iconData: Icons.lock,
                        label: "Senha atual",
                        isSecret: true,
                        validator: passwordValidator,
                      ),
                      CustomTextField(
                        controller: newPasswordController,
                        iconData: Icons.lock_outline,
                        label: "Nova Senha",
                        isSecret: true,
                        validator: passwordValidator,
                      ),
                      CustomTextField(
                        iconData: Icons.lock_outline,
                        label: "Confirmar nova senha",
                        isSecret: true,
                        validator: (password) {
                          final result = passwordValidator(password);
                          if (result != null) {
                            return result;
                          }

                          if (password != newPasswordController.text) {
                            return "As senhas não são equivalentes";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 45,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: authController.isLoading.value
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      authController.changePassword(
                                        currentPassword:
                                            currentPasswordController.text,
                                        newPassword: newPasswordController.text,
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: authController.isLoading.value
                                ? const CircularProgressIndicator()
                                : const Text("Atualizar"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

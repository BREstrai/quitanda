import 'package:quitanda/src/config/app_data.dart' as appData;
import 'package:flutter/material.dart';
import 'package:quitanda/src/pages/common_widgets/custom_text_field.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Perfil do usuário",
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          CustomTextField(
            iconData: Icons.email,
            label: "Email",
            initialValue: appData.userModel.email,
            isReadOnly: true,
          ),
          CustomTextField(
            iconData: Icons.person,
            label: "Nome",
            initialValue: appData.userModel.name,
            isReadOnly: true,
          ),
          CustomTextField(
            iconData: Icons.phone,
            label: "Celular",
            initialValue: appData.userModel.phone,
            isReadOnly: true,
          ),
          CustomTextField(
            iconData: Icons.file_copy,
            label: "CPF",
            isSecret: true,
            initialValue: appData.userModel.cpf,
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
                    const CustomTextField(
                      iconData: Icons.lock,
                      label: "Senha atual",
                      isSecret: true,
                    ),
                    const CustomTextField(
                      iconData: Icons.lock_outline,
                      label: "Nova Senha",
                      isSecret: true,
                    ),
                    const CustomTextField(
                      iconData: Icons.lock_outline,
                      label: "Confirmar nova senha",
                      isSecret: true,
                    ),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Atualizar"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    )
                  ],
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

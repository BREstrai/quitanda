import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final IconData iconData;
  final String label;
  final bool isSecret;
  final List<TextInputFormatter>? inputFormatter;
  final String? initialValue;
  final bool isReadOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final void Function(String?)? onSaved;
  final GlobalKey<FormFieldState>? formFieldKey;

  const CustomTextField({
    Key? key,
    required this.iconData,
    required this.label,
    this.inputFormatter,
    this.isSecret = false,
    this.initialValue,
    this.isReadOnly = false,
    this.validator,
    this.controller,
    this.textInputType,
    this.onSaved,
    this.formFieldKey,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;

  @override
  void initState() {
    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        key: widget.formFieldKey,
        controller: widget.controller,
        readOnly: widget.isReadOnly,
        initialValue: widget.initialValue,
        keyboardType: widget.textInputType,
        onSaved: widget.onSaved,
        inputFormatters: widget.inputFormatter,
        obscureText: isObscure,
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.iconData),
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon:
                      Icon(isObscure ? Icons.visibility : Icons.visibility_off),
                )
              : null,
          labelText: widget.label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quitanda/src/config/custom_colors.dart';

class QuantityWidget extends StatelessWidget {
  final int value;
  final String suffixText;
  final Function(int count) result;

  const QuantityWidget({
    Key? key,
    required this.suffixText,
    required this.value,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          //Subtrair qtd
          _QuantityWidget(
            icon: Icons.remove,
            color: Colors.grey,
            onPressed: () {
              if (value == 1) return;
              int resultCount = value - 1;
              result(resultCount);
            },
          ),

          //Texto
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: Text(
              '${value} ${suffixText}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),

          //Somar qtd
          _QuantityWidget(
            icon: Icons.add,
            color: CustomColors.customSwatchColor,
            onPressed: () {
              int resultCount = value + 1;
              result(resultCount);
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityWidget extends StatelessWidget {
  const _QuantityWidget({
    Key? key,
    required this.color,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      //Utilizado Material e Ink... para dar animação quando clicado
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onPressed,
        child: Ink(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onTap,
    this.icon,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        margin: const EdgeInsets.all(2),
        height: 35,
        width: 35,
        child: icon,
      ),
    );
  }
}

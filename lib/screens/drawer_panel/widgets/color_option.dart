import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/constants/constants.dart';
import '../provider/drawer_panel.dart';

class ColorOption extends StatelessWidget {
  const ColorOption({
    Key? key,
    required this.color,
    required this.selectedColor,
  }) : super(key: key);

  final Color color;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    final panelActions = context.read<DrawerPanel>();

    return GestureDetector(
      onTap: () {
        panelActions.changeLineColor = color;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: color == Colors.white
              ? Border.all(
                  color: Colors.black,
                  width: 1,
                )
              : Border.all(
                  color: color,
                ),
          boxShadow: selectedColor == color
              ? [
                  circleShadow,
                ]
              : [],
        ),
        margin: const EdgeInsets.all(2),
        height: selectedColor == color ? 25 : 20,
        width: selectedColor == color ? 25 : 20,
      ),
    );
  }
}

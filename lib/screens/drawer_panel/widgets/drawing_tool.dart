import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/constants/constants.dart';
import '../classes/tool.dart';
import '../provider/drawer_panel.dart';

class DrawingTool extends StatelessWidget {
  const DrawingTool({
    Key? key,
    required this.tool,
    required this.selectedTool,
  }) : super(key: key);

  final Tool tool;
  final Tools selectedTool;

  @override
  Widget build(BuildContext context) {
    final panelActions = context.read<DrawerPanel>();

    return GestureDetector(
      onTap: () {
        panelActions.changeToolSelected = tool;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: selectedTool == tool.tool
              ? [
                  circleShadow,
                ]
              : [],
        ),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        height: selectedTool == tool.tool ? 30 : 25,
        width: 30,
        child: SvgPicture.asset(
          tool.srcUrl!,
          color: Colors.black,
        ),
      ),
    );
  }
}

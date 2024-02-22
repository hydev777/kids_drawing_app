import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/drawer_panel/provider/provider.dart';

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DrawerProvider(),
        )
      ],
      child: child,
    );
  }
}

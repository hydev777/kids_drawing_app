import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../drawer_panel/provider/drawer_panel.dart';
import '../drawer_panel/view/drawing_panel.dart';

class KidsDrawingApp extends StatelessWidget {
  const KidsDrawingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DrawerPanel(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Panel(),
      ),
    );
  }
}

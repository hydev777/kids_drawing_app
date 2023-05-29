import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/drawer_panel/view/drawing_panel.dart';
import 'screens/drawer_panel/provider/drawer_panel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

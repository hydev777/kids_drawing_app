import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/drawer_panel/drawing_panel.dart';
import './provider/drawer_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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


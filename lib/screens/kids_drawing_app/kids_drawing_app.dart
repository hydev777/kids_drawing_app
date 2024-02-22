import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/router.dart';
import '../drawer_panel/provider/provider.dart';

class KidsDrawingApp extends StatelessWidget {
  const KidsDrawingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DrawerProvider(),
        )
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

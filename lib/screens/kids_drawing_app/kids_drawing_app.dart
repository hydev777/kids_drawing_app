import 'package:flutter/material.dart';

import '../../provider_wrapper/provider_wrapper.dart';
import '../../router/router.dart';

class KidsDrawingApp extends StatelessWidget {
  const KidsDrawingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWrapper(
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

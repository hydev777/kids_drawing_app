import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/drawer_panel/view/drawing_panel.dart';

final _rootKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
  routes: [
    GoRoute(
      path: '/panel',
      builder: (context, state) => const Panel(),
    ),
  ],
  initialLocation: "/panel",
);

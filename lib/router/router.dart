import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kids_drawing_app/screens/drawer_panel/view/view.dart';

import '../screens/privacy_policy/view/privacy_policy.dart';

final _rootKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootKey,
  routes: [
    GoRoute(
      path: '/panel',
      builder: (context, state) => const Panel(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicy(),
    ),
  ],
  initialLocation: "/panel",
);

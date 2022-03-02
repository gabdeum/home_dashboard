import 'package:flutter/material.dart';
import 'pages/settings.dart';
import 'pages/home.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/settings',
  routes: {
    '/settings': (context) => const Settings(),
    '/': (context) => const Home()
  },
));
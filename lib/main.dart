import 'package:flutter/material.dart';
import 'pages/settings.dart';
import 'pages/home.dart';

void main() => runApp(MaterialApp(
  routes: {
    '/settings': (context) => const Settings(),
    '/': (context) => Home()
  },
));
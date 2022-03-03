import 'package:flutter/material.dart';
import 'pages/settings.dart';
import 'pages/home.dart';

void main() => runApp(MaterialApp(
  routes: {
    '/': (context) => const Settings(),
    '/home': (context) => const Home()
  },
));
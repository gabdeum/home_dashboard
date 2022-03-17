import 'package:flutter/material.dart';
import 'package:home_dashboard/pages/loading.dart';
import 'pages/settings.dart';
import 'pages/home.dart';

void main() => runApp(MaterialApp(
  // initialRoute: '/home',
  routes: {
    '/settings': (context) => Settings(),
    '/home': (context) => Home(),
    '/': (context) => const Loading()
  },
));
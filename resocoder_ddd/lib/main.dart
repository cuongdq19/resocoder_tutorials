import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:resocoder_ddd/injection.dart';
import 'package:resocoder_ddd/presentation/core/app_widget.dart';

Future<void> main() async {
  configureInjection(Environment.prod);
  runApp(AppWidget());
}

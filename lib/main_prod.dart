import 'package:flutter/material.dart';

import 'app_config.dart';
import 'main.dart';

void main() {
  AppConfig.setupEnv(Environment.prod);
  runApp(OlaCarWash());
}

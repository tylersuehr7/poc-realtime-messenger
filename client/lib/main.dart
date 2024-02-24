import 'package:client/application/application.dart';
import 'package:flutter/material.dart';

import 'injector.dart';

void main() {
  initializeDependencies();
  runApp(const ClientApplication());
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'app.dart';
import 'core/database/local_database.dart';
import 'core/services/local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await LocalDatabase.instance.database;
    await LocalNotificationService.instance.initialize();
  }
  runApp(const SubCutApp());
}

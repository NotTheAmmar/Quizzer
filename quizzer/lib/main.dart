import 'package:flutter/material.dart';
import 'package:quizzer/material_app.dart';
import 'package:quizzer/sqlite.dart';

final SqliteService db = SqliteService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  db.init().then((_) => runApp(const MaterialAPP()));
}

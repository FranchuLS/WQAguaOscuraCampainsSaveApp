import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wqaguaoscura_app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización de Hive para persistencia local
  await Hive.initFlutter();
  
  runApp(const WQApp());
}
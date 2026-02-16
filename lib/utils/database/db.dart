// Source - https://stackoverflow.com/a/78016268
// Posted by Aprendendo Next
// Retrieved 2026-02-16, License - CC BY-SA 4.0
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> openDatabaseFromAssets() async {
    // Get the temporary directory (cache)
    final directory = await getTemporaryDirectory();
    final path = join(directory.path, 'main.db');

    // Check if the database file exists
    final exists = await File(path).exists();

    if (!exists) {
      // Copy from assets
      ByteData data = await rootBundle.load('assets/database/main.db');
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open the database
    return await openDatabase(path);
  }
}

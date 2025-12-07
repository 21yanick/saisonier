import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/open.dart';

void setupSqlite() {
  if (Platform.isLinux) {
    open.overrideFor(OperatingSystem.linux, () {
      try {
        return DynamicLibrary.open('libsqlite3.so.0');
      } catch (e) {
        // Fallback or rethrow
        return DynamicLibrary.open('libsqlite3.so');
      }
    });
  }
}

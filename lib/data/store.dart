import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../model/models.dart';

/// Persists all app data as one JSON file in the app's private storage.
class Store {
  final Future<Directory> Function() _dir;

  Store({Future<Directory> Function()? dir}) : _dir = dir ?? getApplicationDocumentsDirectory;

  Future<File> get _file async => File('${(await _dir()).path}/trackher.json');

  Future<AppData> load() async {
    try {
      final f = await _file;
      if (!await f.exists()) return AppData();
      return AppData.fromJson(jsonDecode(await f.readAsString()) as Map<String, dynamic>);
    } catch (_) {
      return AppData();
    }
  }

  Future<void> save(AppData data) async {
    final f = await _file;
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(encode(data));
    await tmp.rename(f.path);
  }

  Future<void> wipe() async {
    final f = await _file;
    if (await f.exists()) await f.delete();
  }

  static String encode(AppData d) => const JsonEncoder.withIndent('  ').convert(d.toJson());

  /// Parses an exported file; throws [FormatException] if invalid.
  static AppData decode(String s) {
    final j = jsonDecode(s);
    if (j is! Map<String, dynamic> || !j.containsKey('periods')) {
      throw const FormatException('Not a Tempo backup');
    }
    return AppData.fromJson(j);
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/level.dart';

class LevelsRepository {
  LevelsRepository({this._prefs});

  static const assetPath = 'assets/levels.json';
  static const _doneKey = 'pix_puzzle_done_codes';

  SharedPreferences? _prefs;
  List<Level>? _levels;

  Future<SharedPreferences> _preferences() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<Level>> loadLevels() async {
    if (_levels != null) return _levels!;

    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = (decoded['levelList'] as List<dynamic>)
        .map((e) => Level.fromJson(e as Map<String, dynamic>))
        .toList();

    final doneCodes = await _loadDoneCodes();
    _levels = list
        .map((level) => level.copyWith(done: doneCodes.contains(level.code)))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _levels!;
  }

  List<Level> levelsForDifficulty(String prefix) {
    final levels = _levels;
    if (levels == null) return const [];
    return levels.where((l) => l.name.startsWith(prefix)).toList();
  }

  Level? levelByCode(int code) {
    final levels = _levels;
    if (levels == null) return null;
    for (final level in levels) {
      if (level.code == code) return level;
    }
    return null;
  }

  /// Next level in the same difficulty (name prefix), after [current], or null.
  Level? nextLevel(Level current) {
    final prefix = _prefixOf(current.name);
    final group = levelsForDifficulty(prefix);
    final index = group.indexWhere((l) => l.code == current.code);
    if (index < 0 || index + 1 >= group.length) return null;
    return group[index + 1];
  }

  /// Whether every level in [current]'s difficulty group is marked done.
  bool isDifficultyComplete(Level current) {
    final group = levelsForDifficulty(_prefixOf(current.name));
    return group.isNotEmpty && group.every((level) => level.done);
  }

  bool get hasLoadedLevels {
    final levels = _levels;
    return levels != null && levels.isNotEmpty;
  }

  Future<void> markDone(int code) async {
    final levels = await loadLevels();
    _levels = [
      for (final level in levels)
        if (level.code == code) level.copyWith(done: true) else level,
    ];
    final prefs = await _preferences();
    final codes = _levels!.where((l) => l.done).map((l) => l.code).toList();
    await prefs.setString(_doneKey, jsonEncode(codes));
  }

  Future<Set<int>> _loadDoneCodes() async {
    final prefs = await _preferences();
    final raw = prefs.getString(_doneKey);
    if (raw == null || raw.isEmpty) return {};
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as int).toSet();
  }

  static String _prefixOf(String name) {
    final match = RegExp(r'^(\d+_)').firstMatch(name);
    return match?.group(1) ?? name;
  }
}

import 'package:equatable/equatable.dart';

import 'board_cell.dart';

/// Indices are [x][y] (column, row), matching the original Android app.
class Level extends Equatable {
  const Level({
    required this.code,
    required this.size,
    required this.difficulty,
    required this.number,
    required this.title,
    required this.tableBoard,
    required this.tableModel,
    required this.tableBrush,
    this.done = false,
  });

  final int code;
  final int size;

  /// 1 fácil, 2 media, 3 difícil.
  final int difficulty;

  /// Order within [difficulty]. Unique in that group.
  final int number;

  /// Display names keyed by language code (`es`, `en`).
  final Map<String, String> title;

  /// Name for [languageCode], or the Spanish name when that language is missing.
  String localizedTitle(String languageCode) {
    final translated = title[languageCode];
    if (translated != null && translated.isNotEmpty) return translated;
    return title['es'] ?? '';
  }

  final List<List<BoardCell>> tableBoard;
  final List<List<BoardCell>> tableModel;
  final List<List<BoardCell>> tableBrush;
  final bool done;

  Level copyWith({
    int? code,
    int? size,
    int? difficulty,
    int? number,
    Map<String, String>? title,
    List<List<BoardCell>>? tableBoard,
    List<List<BoardCell>>? tableModel,
    List<List<BoardCell>>? tableBrush,
    bool? done,
  }) {
    return Level(
      code: code ?? this.code,
      size: size ?? this.size,
      difficulty: difficulty ?? this.difficulty,
      number: number ?? this.number,
      title: title ?? this.title,
      tableBoard: tableBoard ?? this.tableBoard,
      tableModel: tableModel ?? this.tableModel,
      tableBrush: tableBrush ?? this.tableBrush,
      done: done ?? this.done,
    );
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      code: json['code'] as int,
      size: json['size'] as int,
      difficulty: json['difficulty'] as int,
      number: json['number'] as int,
      title: _titleFromJson(json['title']),
      tableBoard: _tableFromJson(json['tableBoard']),
      tableModel: _tableFromJson(json['tableModel']),
      tableBrush: _tableFromJson(json['tableBrush']),
      done: json['done'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'size': size,
    'difficulty': difficulty,
    'number': number,
    'title': title,
    'tableBoard': _tableToJson(tableBoard),
    'tableModel': _tableToJson(tableModel),
    'tableBrush': _tableToJson(tableBrush),
    'done': done,
  };

  static Map<String, String> _titleFromJson(dynamic raw) {
    final map = raw as Map<dynamic, dynamic>;
    return map.map((key, value) => MapEntry(key as String, value as String));
  }

  static List<List<BoardCell>> _tableFromJson(dynamic raw) {
    final outer = raw as List<dynamic>;
    return outer
        .map(
          (col) => (col as List<dynamic>)
              .map((cell) => BoardCell.fromJson(cell as Map<String, dynamic>))
              .toList(),
        )
        .toList();
  }

  static List<List<dynamic>> _tableToJson(List<List<BoardCell>> table) {
    return table.map((col) => col.map((e) => e.toJson()).toList()).toList();
  }

  /// Deep-copy board cells (selected cleared, fill cleared).
  Level reset() {
    return copyWith(
      tableBoard: List.generate(
        size,
        (_) => List.generate(size, (_) => const BoardCell()),
      ),
    );
  }

  /// Fresh playable copy: empty board, same model/brush, done flag preserved.
  Level forPlay() {
    return copyWith(
      tableBoard: List.generate(
        size,
        (_) => List.generate(size, (_) => const BoardCell()),
      ),
      tableModel: _cloneTable(tableModel),
      tableBrush: _cloneTable(tableBrush),
    );
  }

  bool validate() {
    for (var j = 0; j < size; j++) {
      for (var i = 0; i < size; i++) {
        if (tableBoard[i][j].fill != tableModel[i][j].fill) {
          return false;
        }
      }
    }
    return true;
  }

  /// Port of LevelActivity.recalcTable(): XOR stamp of brush at each selected cell.
  Level recalcFills() {
    final board = _cloneTable(tableBoard);
    for (var j = 0; j < size; j++) {
      for (var i = 0; i < size; i++) {
        board[i][j] = board[i][j].copyWith(fill: false);
      }
    }

    void xor(int x, int y) {
      board[x][y] = board[x][y].copyWith(fill: !board[x][y].fill);
    }

    for (var j = 0; j < size; j++) {
      for (var i = 0; i < size; i++) {
        if (!board[i][j].selected) continue;

        if (tableBrush[1][1].fill) {
          xor(i, j);
        }
        if (i > 0 && tableBrush[0][1].fill) {
          xor(i - 1, j);
        }
        if (i < size - 1 && tableBrush[2][1].fill) {
          xor(i + 1, j);
        }
        if (j > 0 && tableBrush[1][0].fill) {
          xor(i, j - 1);
        }
        if (j < size - 1 && tableBrush[1][2].fill) {
          xor(i, j + 1);
        }
        if (i > 0 && j > 0 && tableBrush[0][0].fill) {
          xor(i - 1, j - 1);
        }
        if (i > 0 && j < size - 1 && tableBrush[0][2].fill) {
          xor(i - 1, j + 1);
        }
        if (i < size - 1 && j > 0 && tableBrush[2][0].fill) {
          xor(i + 1, j - 1);
        }
        if (i < size - 1 && j < size - 1 && tableBrush[2][2].fill) {
          xor(i + 1, j + 1);
        }
      }
    }

    return copyWith(tableBoard: board);
  }

  Level toggleSelected(int x, int y) {
    final board = _cloneTable(tableBoard);
    final cell = board[x][y];
    board[x][y] = cell.copyWith(selected: !cell.selected);
    return copyWith(tableBoard: board).recalcFills();
  }

  static List<List<BoardCell>> _cloneTable(List<List<BoardCell>> table) {
    return table.map((col) => col.map((e) => e.copyWith()).toList()).toList();
  }

  @override
  List<Object?> get props => [
    code,
    size,
    difficulty,
    number,
    title,
    tableBoard,
    tableModel,
    tableBrush,
    done,
  ];
}

import 'package:equatable/equatable.dart';

class BoardCell extends Equatable {
  const BoardCell({this.selected = false, this.fill = false});

  final bool selected;
  final bool fill;

  BoardCell copyWith({bool? selected, bool? fill}) {
    return BoardCell(
      selected: selected ?? this.selected,
      fill: fill ?? this.fill,
    );
  }

  factory BoardCell.fromJson(Map<String, dynamic> json) {
    return BoardCell(
      selected: json['selected'] as bool? ?? false,
      fill: json['fill'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'selected': selected,
        'fill': fill,
      };

  @override
  List<Object?> get props => [selected, fill];
}

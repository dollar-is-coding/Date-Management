import 'package:json_annotation/json_annotation.dart';
part 'date.g.dart';

@JsonSerializable()
class Date {
  int? id;
  DateTime mfg;
  DateTime exp;
  DateTime fourtyPercent;
  DateTime thirtyPercent;
  DateTime twentyPercent;
  Date({
    this.id,
    required this.mfg,
    required this.exp,
    required this.fourtyPercent,
    required this.thirtyPercent,
    required this.twentyPercent,
  });

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);

  Map<String, dynamic> toJson() => _$DateToJson(this);
}

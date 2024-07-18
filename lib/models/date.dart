import 'package:json_annotation/json_annotation.dart';
part 'date.g.dart';

@JsonSerializable()
class Date {
  int? id;
  int sku;
  String mfg;
  String exp;
  @JsonKey(name: 'twenty_pct')
  String twentyPercent;
  @JsonKey(name: 'thirty_pct')
  String thirtyPercent;
  @JsonKey(name: 'fourty_pct')
  String fourtyPercent;
  String note;

  Date({
    this.id,
    required this.sku,
    required this.mfg,
    required this.exp,
    required this.twentyPercent,
    required this.thirtyPercent,
    required this.fourtyPercent,
    required this.note,
  });

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);

  Map<String, dynamic> toJson() => _$DateToJson(this);
}

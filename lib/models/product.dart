import 'package:json_annotation/json_annotation.dart';
import 'package:sg_date/models/date.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String barCode;
  String sku;
  String name;
  List<Date> dates;
  Product({
    this.id,
    required this.barCode,
    required this.sku,
    required this.name,
    required this.dates,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

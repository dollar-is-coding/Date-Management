import 'package:json_annotation/json_annotation.dart';
import 'package:sg_date/models/date.dart';
import 'package:sg_date/models/tag.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String barcode;
  int sku;
  String name;
  List<Date> dates;
  Tag tag;
  int favorite;
  Product({
    this.id,
    required this.barcode,
    required this.sku,
    required this.name,
    required this.dates,
    required this.tag,
    required this.favorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

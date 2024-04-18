import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;
  String barcode;
  int sku;
  String name;
  Product({
   this.id,
    required this.barcode,
    required this.sku,
    required this.name,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

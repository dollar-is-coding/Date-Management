// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int?,
      barcode: json['barcode'] as String,
      sku: json['sku'] as int,
      name: json['name'] as String,
      dates: (json['dates'] as List<dynamic>)
          .map((e) => Date.fromJson(e as Map<String, dynamic>))
          .toList(),
      tag: Tag.fromJson(json['tag'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'barcode': instance.barcode,
      'sku': instance.sku,
      'name': instance.name,
      'dates': instance.dates,
      'tag': instance.tag,
    };

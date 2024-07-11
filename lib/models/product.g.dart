// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num?)?.toInt(),
      barcode: json['barcode'] as String,
      sku: (json['sku'] as num).toInt(),
      name: json['name'] as String,
      dates: (json['dates'] as List<dynamic>)
          .map((e) => Date.fromJson(e as Map<String, dynamic>))
          .toList(),
      tag: Tag.fromJson(json['tag'] as Map<String, dynamic>),
      favorite: (json['favorite'] as num).toInt(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'barcode': instance.barcode,
      'sku': instance.sku,
      'name': instance.name,
      'dates': instance.dates,
      'tag': instance.tag,
      'favorite': instance.favorite,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int?,
      barCode: json['barCode'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      dates: (json['dates'] as List<dynamic>)
          .map((e) => Date.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'barCode': instance.barCode,
      'sku': instance.sku,
      'name': instance.name,
      'dates': instance.dates,
    };

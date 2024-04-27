// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Date _$DateFromJson(Map<String, dynamic> json) => Date(
      id: json['id'] as int?,
      sku: json['sku'] as int,
      mfg: json['mfg'] as String,
      exp: json['exp'] as String,
      twentyPercent: json['twenty_pct'] as String,
      thirtyPerrcent: json['thirty_pct'] as String,
      fourtyPercent: json['fourty_pct'] as String,
    );

Map<String, dynamic> _$DateToJson(Date instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'mfg': instance.mfg,
      'exp': instance.exp,
      'twenty_pct': instance.twentyPercent,
      'thirty_pct': instance.thirtyPerrcent,
      'fourty_pct': instance.fourtyPercent,
    };

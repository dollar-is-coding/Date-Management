// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Date _$DateFromJson(Map<String, dynamic> json) => Date(
      id: json['id'] as int?,
      mfg: DateTime.parse(json['mfg'] as String),
      exp: DateTime.parse(json['exp'] as String),
      fourtyPercent: DateTime.parse(json['fourtyPercent'] as String),
      thirtyPercent: DateTime.parse(json['thirtyPercent'] as String),
      twentyPercent: DateTime.parse(json['twentyPercent'] as String),
    );

Map<String, dynamic> _$DateToJson(Date instance) => <String, dynamic>{
      'id': instance.id,
      'mfg': instance.mfg.toIso8601String(),
      'exp': instance.exp.toIso8601String(),
      'fourtyPercent': instance.fourtyPercent.toIso8601String(),
      'thirtyPercent': instance.thirtyPercent.toIso8601String(),
      'twentyPercent': instance.twentyPercent.toIso8601String(),
    };

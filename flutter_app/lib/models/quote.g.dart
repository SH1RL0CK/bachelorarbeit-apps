// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quote _$QuoteFromJson(Map<String, dynamic> json) => _Quote(
  id: json['id'] as String?,
  text: json['text'] as String,
  movie: json['movie'] as String,
  character: json['character'] as String?,
  year: (json['year'] as num?)?.toInt(),
  rating: (json['rating'] as num?)?.toInt() ?? 1,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$QuoteToJson(_Quote instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'movie': instance.movie,
  'character': instance.character,
  'year': instance.year,
  'rating': instance.rating,
  'createdAt': instance.createdAt?.toIso8601String(),
};

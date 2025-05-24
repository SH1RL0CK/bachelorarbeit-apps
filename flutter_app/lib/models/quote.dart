import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote.freezed.dart';
part 'quote.g.dart';

@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    String? id,
    required String text,
    required String movie,
    String? character,
    int? year,
    DateTime? createdAt,
    bool? isFavorite,
  }) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}

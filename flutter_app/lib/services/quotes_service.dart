import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/models/quote.dart';

class QuotesService {
  final _sharedPreferences = SharedPreferencesAsync();
  static const String _quotesKey = 'quotes';

  Future<List<Quote>> getQuotes() async {
    final quotesJson = await _sharedPreferences.getStringList(_quotesKey) ?? [];
    return quotesJson.map((json) => Quote.fromJson(jsonDecode(json))).toList();
  }

  Future<void> addQuote(Quote quote) async {
    final quotes = await getQuotes();
    quotes.add(quote);
    await _sharedPreferences.setStringList(
      _quotesKey,
      quotes.map((q) => jsonEncode(q.toJson())).toList(),
    );
  }

  Future<void> updateQuote(Quote quote) async {
    final quotes = await getQuotes();
    final index = quotes.indexWhere((q) => q.id == quote.id);
    if (index != -1) {
      quotes[index] = quote;
      await _sharedPreferences.setStringList(
        _quotesKey,
        quotes.map((q) => jsonEncode(q.toJson())).toList(),
      );
    }
  }

  Future<void> deleteQuote(String id) async {
    final quotes = await getQuotes();
    quotes.removeWhere((q) => q.id == id);
    await _sharedPreferences.setStringList(
      _quotesKey,
      quotes.map((q) => jsonEncode(q.toJson())).toList(),
    );
  }
}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

import '../domain/question_models.dart';
import 'ielts_markdown_parser.dart';

class QuestionRepository {
  QuestionRepository({
    AssetBundle? bundle,
    IeltsMarkdownParser? parser,
  })  : _bundle = bundle ?? rootBundle,
        _parser = parser ?? IeltsMarkdownParser();

  static const String _assetPath = 'IELTS.md';

  final AssetBundle _bundle;
  final IeltsMarkdownParser _parser;

  QuestionBank? _cache;

  Future<QuestionBank> loadQuestionBank({bool forceRefresh = false}) async {
    final markdown = await _bundle.loadString(_assetPath);
    final contentHash = sha256.convert(utf8.encode(markdown)).toString();

    if (!forceRefresh && _cache != null && _cache!.contentHash == contentHash) {
      return _cache!;
    }

    final parsed = _parser.parse(markdown, contentHash: contentHash);
    _cache = parsed;
    return parsed;
  }
}

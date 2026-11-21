import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RuntimeLocalization {
  RuntimeLocalization({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 8),
              sendTimeout: const Duration(seconds: 8),
            ),
          );

  final Dio _dio;
  final Map<String, String> _memoryCache = {};

  Future<String> translate({
    required String source,
    required Locale locale,
  }) async {
    final languageCode = locale.languageCode;
    if (languageCode == 'pt') return source;

    final cacheKey =
        'runtime_translation:$languageCode:${base64Url.encode(utf8.encode(source))}';
    final memory = _memoryCache[cacheKey];
    if (memory != null) return memory;

    final preferences = await SharedPreferences.getInstance();
    final cached = preferences.getString(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      _memoryCache[cacheKey] = cached;
      return cached;
    }

    try {
      final response = await _dio.get(
        'https://translate.googleapis.com/translate_a/single',
        queryParameters: {
          'client': 'gtx',
          'sl': 'pt',
          'tl': languageCode,
          'dt': 't',
          'q': source,
        },
      );
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        final translatedParts = data.first;
        if (translatedParts is List) {
          final translated = translatedParts
              .whereType<List>()
              .map((part) => part.isNotEmpty ? part.first : null)
              .whereType<String>()
              .join();
          if (translated.isNotEmpty) {
            await preferences.setString(cacheKey, translated);
            _memoryCache[cacheKey] = translated;
            return translated;
          }
        }
      }
    } on DioException {
      // Keep the source text visible instead of replacing it with an error.
    }
    return source;
  }
}

class RuntimeLocalizedText extends StatefulWidget {
  const RuntimeLocalizedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<RuntimeLocalizedText> createState() => _RuntimeLocalizedTextState();
}

class _RuntimeLocalizedTextState extends State<RuntimeLocalizedText> {
  static final RuntimeLocalization _localization = RuntimeLocalization();
  String? _translated;
  String? _localeCode;
  int _requestId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeCode = Localizations.localeOf(context).languageCode;
    if (_localeCode == localeCode) return;
    _localeCode = localeCode;
    _translated = null;
    _requestId++;
    _translate();
  }

  @override
  void didUpdateWidget(covariant RuntimeLocalizedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _translate();
  }

  Future<void> _translate() async {
    final requestId = ++_requestId;
    final locale = Localizations.localeOf(context);
    final translated = await _localization.translate(
      source: widget.text,
      locale: locale,
    );
    if (!mounted || requestId != _requestId) return;
    setState(() => _translated = translated);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _translated ?? widget.text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}

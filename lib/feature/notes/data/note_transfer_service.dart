import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:markdown/markdown.dart' as markdown;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_document/pdf_document.dart';
import 'package:pdf_graphics/pdf_graphics.dart';
import 'package:xml/xml.dart';

enum NoteExportFormat {
  quillJson('Quill Delta (.json)', 'json', 'application/json'),
  markdown('Markdown (.md)', 'md', 'text/markdown'),
  plainText('Texto simples (.txt)', 'txt', 'text/plain'),
  html('Página HTML (.html)', 'html', 'text/html'),
  word('Documento Word (.docx)', 'docx',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
  pdf('Documento PDF (.pdf)', 'pdf', 'application/pdf');

  const NoteExportFormat(this.label, this.extension, this.mimeType);

  final String label;
  final String extension;
  final String mimeType;
}

class ImportedNoteContent {
  const ImportedNoteContent({
    required this.title,
    required this.contentQuillJson,
  });

  final String title;
  final String contentQuillJson;
}

class NoteTransferService {
  static const importExtensions = [
    'json',
    'md',
    'markdown',
    'txt',
    'html',
    'htm',
    'docx',
    'pdf',
  ];
  static const maximumImportBytes = 20 * 1024 * 1024;

  static Future<Uint8List> exportNote({
    required String title,
    required String contentQuillJson,
    required NoteExportFormat format,
  }) async {
    final delta = _decodeDelta(contentQuillJson);
    final text = _deltaToPlainText(delta);
    final safeTitle = title.trim().isEmpty ? 'Anotação' : title.trim();
    switch (format) {
      case NoteExportFormat.quillJson:
        return Uint8List.fromList(
          utf8.encode(
            const JsonEncoder.withIndent('  ').convert({
              'format': 'noema-quill-delta',
              'version': 1,
              'title': safeTitle,
              'delta': delta,
            }),
          ),
        );
      case NoteExportFormat.markdown:
        return Uint8List.fromList(
          utf8.encode('# $safeTitle\n\n${_deltaToMarkdown(delta)}'),
        );
      case NoteExportFormat.plainText:
        return Uint8List.fromList(utf8.encode('$safeTitle\n\n$text'));
      case NoteExportFormat.html:
        final body = markdown.markdownToHtml(
          _deltaToMarkdown(delta),
          encodeHtml: true,
        );
        return Uint8List.fromList(
          utf8.encode(
            '<!doctype html><html lang="pt"><head>'
            '<meta charset="utf-8"><meta name="viewport" '
            'content="width=device-width, initial-scale=1">'
            '<title>${_escapeHtml(safeTitle)}</title></head><body>'
            '<article><h1>${_escapeHtml(safeTitle)}</h1>$body</article>'
            '</body></html>',
          ),
        );
      case NoteExportFormat.word:
        return _exportDocx(title: safeTitle, text: text);
      case NoteExportFormat.pdf:
        final pdf = pw.Document();
        pdf.addPage(
          pw.MultiPage(
            build: (_) => [
              pw.Text(
                safeTitle,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 18),
              pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
            ],
          ),
        );
        return Uint8List.fromList(await pdf.save());
    }
  }

  static ImportedNoteContent importNote({
    required String fileName,
    required Uint8List bytes,
  }) {
    if (bytes.isEmpty) throw const FormatException('O arquivo está vazio.');
    if (bytes.length > maximumImportBytes) {
      throw const FormatException(
        'O arquivo excede o limite de importação de 20 MB.',
      );
    }

    final extension = fileName.split('.').last.toLowerCase();
    final fallbackTitle = _titleFromFileName(fileName);
    late final String title;
    late final List<dynamic> delta;
    switch (extension) {
      case 'json':
        final imported = _importJson(utf8.decode(bytes));
        title = imported.$1 ?? fallbackTitle;
        delta = imported.$2;
      case 'md':
      case 'markdown':
        final source = utf8.decode(bytes);
        title = _titleFromMarkdown(source, fallbackTitle);
        delta = _htmlToDelta(markdown.markdownToHtml(source));
      case 'html':
      case 'htm':
        final document = html_parser.parse(utf8.decode(bytes));
        title = document.querySelector('title')?.text.trim().isNotEmpty == true
            ? document.querySelector('title')!.text.trim()
            : fallbackTitle;
        delta = _htmlToDelta(
          document.body?.innerHtml ?? document.documentElement?.innerHtml ?? '',
        );
      case 'txt':
        title = fallbackTitle;
        delta = _plainTextToDelta(utf8.decode(bytes));
      case 'docx':
        final imported = _importDocx(bytes);
        title = fallbackTitle;
        delta = _plainTextToDelta(imported);
      case 'pdf':
        final imported = _importPdf(bytes);
        title = fallbackTitle;
        delta = _plainTextToDelta(imported);
      default:
        throw FormatException(
          'Formato .$extension não suportado. Importe JSON, Markdown, texto, HTML, Word (.docx) ou PDF com texto selecionável.',
        );
    }

    final document = Document.fromJson(_ensureTerminalNewline(delta));
    return ImportedNoteContent(
      title: _validateTitle(title),
      contentQuillJson: jsonEncode(document.toDelta().toJson()),
    );
  }

  static (String?, List<dynamic>) _importJson(String source) {
    final decoded = jsonDecode(source);
    if (decoded is List) return (null, decoded);
    if (decoded is! Map) {
      throw const FormatException('O JSON não contém uma nota ou Delta válido.');
    }
    final title = decoded['title'];
    final rawDelta = decoded['delta'] ?? decoded['ops'];
    final rawContent = decoded['contentQuillJson'];
    if (rawContent is String) {
      final content = jsonDecode(rawContent);
      if (content is List) {
        return (title is String ? title : null, content);
      }
    }
    if (rawDelta is List) return (title is String ? title : null, rawDelta);
    throw const FormatException(
      'O JSON deve conter um Delta Quill em "delta" ou "ops".',
    );
  }

  static String _importDocx(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes, verify: true);
    final file = archive.findFile('word/document.xml');
    if (file == null) {
      throw const FormatException('O documento Word está incompleto.');
    }
    final xml = XmlDocument.parse(utf8.decode(file.content));
    final paragraphs = xml.findAllElements('w:p');
    final text = paragraphs.map((paragraph) {
      final buffer = StringBuffer();
      for (final node in paragraph.descendants) {
        if (node is! XmlElement) continue;
        if (node.name.local == 't') buffer.write(node.innerText);
        if (node.name.local == 'tab') buffer.write('\t');
        if (node.name.local == 'br') buffer.write('\n');
      }
      return buffer.toString();
    }).join('\n');
    return text;
  }

  static String _importPdf(Uint8List bytes) {
    final document = PdfDocument.open(bytes);
    final text = List.generate(
      document.pageCount,
      (index) => PdfTextExtractor.extract(document, index).text,
    ).join('\n\n').trim();
    if (text.isEmpty) {
      throw const FormatException(
        'O PDF não contém texto selecionável. PDFs digitalizados precisam de OCR.',
      );
    }
    return text;
  }

  static Uint8List _exportDocx({required String title, required String text}) {
    final paragraphs = [
      title,
      '',
      ...text.split('\n'),
    ].map((line) {
      final escaped = _escapeXml(line);
      return '<w:p><w:r><w:t xml:space="preserve">$escaped</w:t></w:r></w:p>';
    }).join();
    final documentXml =
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
        '<w:body>$paragraphs<w:sectPr/></w:body></w:document>';
    const contentTypes =
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
        '<Default Extension="xml" ContentType="application/xml"/>'
        '<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>'
        '</Types>';
    const relationships =
        '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>'
        '</Relationships>';
    final archive = Archive()
      ..addFile(
        ArchiveFile.bytes('[Content_Types].xml', utf8.encode(contentTypes)),
      )
      ..addFile(ArchiveFile.bytes('_rels/.rels', utf8.encode(relationships)))
      ..addFile(ArchiveFile.bytes('word/document.xml', utf8.encode(documentXml)));
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  static List<dynamic> _decodeDelta(String raw) {
    final decoded = jsonDecode(raw);
    final delta = decoded is Map ? decoded['ops'] : decoded;
    if (delta is! List) {
      throw const FormatException('O conteúdo Quill da nota está inválido.');
    }
    Document.fromJson(delta);
    return delta;
  }

  static String _deltaToPlainText(List<dynamic> delta) {
    final text = StringBuffer();
    for (final operation in delta.whereType<Map>()) {
      final insert = operation['insert'];
      if (insert is String) {
        text.write(insert);
      } else if (insert is Map && insert.containsKey('image')) {
        text.write('[Imagem]');
      } else if (insert is Map && insert.containsKey('video')) {
        text.write('[Vídeo]');
      }
    }
    return text.toString().trimRight();
  }

  static String _deltaToMarkdown(List<dynamic> delta) {
    final output = StringBuffer();
    final line = StringBuffer();
    for (final operation in delta.whereType<Map>()) {
      final insert = operation['insert'];
      if (insert is! String) continue;
      final attributes = operation['attributes'] is Map
          ? Map<String, dynamic>.from(operation['attributes'] as Map)
          : const <String, dynamic>{};
      final segments = insert.split('\n');
      for (var index = 0; index < segments.length; index++) {
        line.write(_formatMarkdownInline(segments[index], attributes));
        if (index == segments.length - 1) continue;
        final block = _markdownBlockPrefix(attributes);
        final content = line.toString();
        if (content.isNotEmpty || block.isNotEmpty) {
          output
            ..write(block)
            ..writeln(content);
        } else {
          output.writeln();
        }
        line.clear();
      }
    }
    if (line.isNotEmpty) output.write(line);
    return output.toString().trimRight();
  }

  static String _formatMarkdownInline(
    String text,
    Map<String, dynamic> attributes,
  ) {
    var value = text;
    final link = attributes['link'];
    if (link is String && _isSafeLink(link)) value = '[$value]($link)';
    if (attributes['code'] == true) return '`$value`';
    if (attributes['bold'] == true) value = '**$value**';
    if (attributes['italic'] == true) value = '*$value*';
    if (attributes['strike'] == true) value = '~~$value~~';
    if (attributes['underline'] == true) value = '<u>$value</u>';
    return value;
  }

  static String _markdownBlockPrefix(Map<String, dynamic> attributes) {
    final header = attributes['header'];
    if (header is int && header > 0) return '${'#' * header} ';
    return switch (attributes['list']) {
      'bullet' => '- ',
      'ordered' => '1. ',
      _ => attributes['blockquote'] == true ? '> ' : '',
    };
  }

  static List<dynamic> _htmlToDelta(String source) {
    final fragment = html_parser.parseFragment(source);
    final delta = <Map<String, dynamic>>[];
    for (final child in fragment.nodes) {
      _appendHtmlNode(child, const {}, delta);
    }
    return _ensureTerminalNewline(delta);
  }

  static void _appendHtmlNode(
    dom.Node node,
    Map<String, dynamic> inherited,
    List<Map<String, dynamic>> delta,
  ) {
    if (node is dom.Text) {
      if (node.data.isNotEmpty) {
        delta.add({
          'insert': node.data,
          if (inherited.isNotEmpty) 'attributes': inherited,
        });
      }
      return;
    }
    if (node is! dom.Element) return;

    final attributes = Map<String, dynamic>.of(inherited);
    switch (node.localName) {
      case 'strong':
      case 'b':
        attributes['bold'] = true;
      case 'em':
      case 'i':
        attributes['italic'] = true;
      case 'u':
        attributes['underline'] = true;
      case 's':
      case 'del':
        attributes['strike'] = true;
      case 'code':
        attributes['code'] = true;
      case 'a':
        final href = node.attributes['href'];
        if (href != null && _isSafeLink(href)) attributes['link'] = href;
    }

    final tag = node.localName;
    if (tag == 'br') {
      delta.add({'insert': '\n'});
      return;
    }
    final blockAttributes = <String, dynamic>{};
    final header = switch (tag) {
      'h1' => 1,
      'h2' => 2,
      'h3' => 3,
      'h4' => 4,
      'h5' => 5,
      'h6' => 6,
      _ => null,
    };
    if (header != null) blockAttributes['header'] = header;
    if (tag == 'blockquote') blockAttributes['blockquote'] = true;
    if (tag == 'li') {
      blockAttributes['list'] =
          node.parent?.localName == 'ol' ? 'ordered' : 'bullet';
    }
    final isBlock = {
      'p',
      'div',
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'li',
      'blockquote',
      'pre',
    }.contains(tag);
    for (final child in node.nodes) {
      _appendHtmlNode(child, attributes, delta);
    }
    if (isBlock && (delta.isEmpty || delta.last['insert'] != '\n')) {
      delta.add({
        'insert': '\n',
        if (blockAttributes.isNotEmpty) 'attributes': blockAttributes,
      });
    } else if (isBlock && blockAttributes.isNotEmpty) {
      delta.last['attributes'] = blockAttributes;
    }
  }

  static List<dynamic> _plainTextToDelta(String text) {
    final normalized = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    return [
      {'insert': normalized.endsWith('\n') ? normalized : '$normalized\n'},
    ];
  }

  static List<dynamic> _ensureTerminalNewline(List<dynamic> delta) {
    final result = delta
        .map((operation) => Map<String, dynamic>.from(operation as Map))
        .toList();
    final lastInsert = result.isEmpty ? null : result.last['insert'];
    if (lastInsert is! String || !lastInsert.endsWith('\n')) {
      result.add({'insert': '\n'});
    }
    return result;
  }

  static String _titleFromMarkdown(String source, String fallback) {
    for (final line in source.split('\n')) {
      final match = RegExp(r'^#\s+(.+)$').firstMatch(line.trim());
      if (match != null) return match.group(1)!.trim();
    }
    return fallback;
  }

  static String _titleFromFileName(String fileName) {
    final name = fileName.split('/').last.split(r'\').last;
    final dot = name.lastIndexOf('.');
    final title = (dot > 0 ? name.substring(0, dot) : name)
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .trim();
    return _validateTitle(title.isEmpty ? 'Anotação importada' : title);
  }

  static String _validateTitle(String title) {
    final normalized = title.trim();
    if (normalized.isEmpty) return 'Anotação importada';
    return normalized.length > 160 ? normalized.substring(0, 160) : normalized;
  }

  static String _escapeHtml(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');

  static String _escapeXml(String value) => _escapeHtml(value);

  static bool _isSafeLink(String href) {
    final uri = Uri.tryParse(href);
    return uri != null &&
        const {'http', 'https', 'mailto'}.contains(uri.scheme.toLowerCase());
  }
}

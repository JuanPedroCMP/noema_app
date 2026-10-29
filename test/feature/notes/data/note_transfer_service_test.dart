import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:noema/feature/notes/data/note_transfer_service.dart';

void main() {
  const delta =
      '[{"insert":"Biologia","attributes":{"bold":true}},'
      '{"insert":" celular\\n"}]';

  test('round-trips the native Quill Delta JSON format', () async {
    final bytes = await NoteTransferService.exportNote(
      title: 'Biologia',
      contentQuillJson: delta,
      format: NoteExportFormat.quillJson,
    );

    final imported = NoteTransferService.importNote(
      fileName: 'biologia.json',
      bytes: bytes,
    );

    expect(imported.title, 'Biologia');
    expect(jsonDecode(imported.contentQuillJson), jsonDecode(delta));
  });

  test('imports Markdown and HTML formatting into Quill Delta', () {
    final markdown = NoteTransferService.importNote(
      fileName: 'anotacoes.md',
      bytes: utf8.encode('# Conceitos\n\n**Célula** é a unidade básica.'),
    );
    final html = NoteTransferService.importNote(
      fileName: 'anotacoes.html',
      bytes: utf8.encode('<h2>Conceitos</h2><p><strong>Célula</strong></p>'),
    );

    expect(markdown.title, 'Conceitos');
    expect(markdown.contentQuillJson, contains('"bold":true'));
    expect(html.contentQuillJson, contains('"header":2'));
    expect(html.contentQuillJson, contains('"bold":true'));
  });

  test('exports and re-imports Word documents without losing text', () async {
    final bytes = await NoteTransferService.exportNote(
      title: 'Biologia',
      contentQuillJson: delta,
      format: NoteExportFormat.word,
    );

    final imported = NoteTransferService.importNote(
      fileName: 'biologia.docx',
      bytes: bytes,
    );

    expect(imported.title, 'biologia');
    expect(imported.contentQuillJson, contains('Biologia'));
    expect(imported.contentQuillJson, contains('celular'));
  });

  test('exports and imports searchable PDF text', () async {
    final pdf = await NoteTransferService.exportNote(
      title: 'Biologia',
      contentQuillJson: delta,
      format: NoteExportFormat.pdf,
    );
    final imported = NoteTransferService.importNote(
      fileName: 'biologia.pdf',
      bytes: pdf,
    );

    expect(utf8.decode(pdf.take(4).toList()), '%PDF');
    expect(imported.contentQuillJson, contains('Biologia'));
    expect(imported.contentQuillJson, contains('celular'));
    expect(
      () =>
          NoteTransferService.importNote(fileName: 'biologia.odt', bytes: pdf),
      throwsFormatException,
    );
  });

  test('rejects oversized or malformed note files', () {
    expect(
      () => NoteTransferService.importNote(
        fileName: 'biologia.json',
        bytes: Uint8List(NoteTransferService.maximumImportBytes + 1),
      ),
      throwsFormatException,
    );
    expect(
      () => NoteTransferService.importNote(
        fileName: 'biologia.json',
        bytes: utf8.encode('not json'),
      ),
      throwsFormatException,
    );
  });
}

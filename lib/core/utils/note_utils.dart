import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Extracts plain text from a flutter_quill Delta JSON string.
/// Formats rich text lists (checklists, bullets, numbering) to clean unicode characters.
/// Returns the original string if it is not a valid Delta JSON (supporting legacy plain-text notes).
String getPlainTextFromDelta(String? desc) {
  if (desc == null || desc.isEmpty) return '';
  try {
    final decoded = jsonDecode(desc);
    if (decoded is List) {
      final doc = quill.Document.fromJson(decoded);
      final buffer = StringBuffer();
      
      void processNode(quill.Node node) {
        if (node is quill.Line) {
          final listType = node.style.attributes['list']?.value;
          if (listType == 'checked') {
            buffer.write('☑ ');
          } else if (listType == 'unchecked') {
            buffer.write('☐ ');
          } else if (listType == 'bullet') {
            buffer.write('• ');
          } else if (listType == 'ordered') {
            buffer.write('1. ');
          }
          buffer.write(node.toPlainText());
        } else if (node is quill.Block) {
          for (final child in node.children) {
            processNode(child);
          }
        } else {
          buffer.write(node.toPlainText());
        }
      }

      for (final child in doc.root.children) {
        processNode(child);
      }
      return buffer.toString().trim();
    }
  } catch (_) {
    // If decoding fails, it is legacy plain-text
  }
  return desc;
}

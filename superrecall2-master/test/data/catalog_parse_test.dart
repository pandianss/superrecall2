import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:superrecall/features/study/domain/learning_models.dart';

void main() {
  test('caiib.json catalog parses successfully', () {
    final file = File('assets/catalogs/caiib.json');
    expect(file.existsSync(), true, reason: 'caiib.json should exist in assets/catalogs/');
    
    final content = file.readAsStringSync();
    final decoded = json.decode(content);
    
    expect(() => ExamCatalog.fromJson(decoded), returnsNormally, 
        reason: 'ExamCatalog.fromJson should parse the json content without throwing exceptions');
        
    final catalog = ExamCatalog.fromJson(decoded);
    expect(catalog.id, 'caiib_2026');
    expect(catalog.name, 'CAIIB 2026');
    expect(catalog.subjects.isNotEmpty, true);
  });
}

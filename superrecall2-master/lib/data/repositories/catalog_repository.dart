import 'dart:convert';
import 'package:flutter/services.dart';

import '../../features/study/domain/learning_models.dart';
import '../../core/utils/logger.dart';

class CatalogRepository {
  final List<ExamCatalog> _cache = [];
  final Map<String, LessonUnit> _lessonMap = {};
  final Map<String, QuizSet> _quizMap = {};

  Future<List<ExamCatalog>> fetchCatalogs() async {
    if (_cache.isNotEmpty) return _cache;
    
    try {
      // Try the modern way first
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      List<String> catalogPaths = manifest
          .listAssets()
          .where((k) => k.toLowerCase().contains('assets/catalogs/'))
          .where((k) => k.endsWith('.json'))
          .toList();
      
      // Fallback for some environments where the above might fail to list
      if (catalogPaths.isEmpty) {
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);
        catalogPaths = manifestMap.keys
            .where((k) => k.toLowerCase().contains('assets/catalogs/'))
            .where((k) => k.endsWith('.json'))
            .toList();
      }

      AppLogger.info('Found ${catalogPaths.length} catalogs: $catalogPaths');
      
      final catalogs = <ExamCatalog>[];
      _lessonMap.clear();
      _quizMap.clear();

      for (final path in catalogPaths) {
        try {
          final raw = await rootBundle.loadString(path);
          final decoded = json.decode(raw);
          final catalog = ExamCatalog.fromJson(decoded);
          
          // Schema Version Check
          if (catalog.schemaVersion > 1) {
            AppLogger.warning('Catalog at $path uses schema version ${catalog.schemaVersion}, but app only supports up to 1. This file may not render correctly.');
          }

          // Index everything for O(1) lookups
          _indexCatalog(catalog);
          
          catalogs.add(catalog);
        } catch (e, st) {
          AppLogger.error('Failed to parse catalog at $path', e, st);
        }
      }
      
      _cache.clear();
      _cache.addAll(catalogs);
    } catch (e, st) {
      AppLogger.error('Failed to load AssetManifest.json', e, st);
    }
    
    return _cache;
  }

  void _indexCatalog(ExamCatalog catalog) {
    for (final subject in catalog.subjects) {
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          for (final lesson in topic.lessons) {
            if (_lessonMap.containsKey(lesson.id)) {
              AppLogger.warning('Duplicate lesson ID detected: ${lesson.id}');
            }
            _lessonMap[lesson.id] = lesson;
          }
          for (final quiz in topic.quizzes) {
            if (_quizMap.containsKey(quiz.id)) {
              AppLogger.warning('Duplicate quiz ID detected: ${quiz.id}');
            }
            _quizMap[quiz.id] = quiz;
          }
        }
      }
    }
  }

  ExamCatalog? getExam(String examId) {
    try {
      return _cache.firstWhere((e) => e.id == examId);
    } catch (_) {
      return null;
    }
  }

  LessonUnit? getLesson(String lessonId) => _lessonMap[lessonId];

  QuizSet? getQuiz(String quizId) => _quizMap[quizId];
}

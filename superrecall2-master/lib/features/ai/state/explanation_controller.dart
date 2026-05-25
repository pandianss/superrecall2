import 'package:flutter/widgets.dart';
import 'ai_service.dart';

enum ExplanationStatus { initial, loading, success, error }

class ExplanationState {
  final ExplanationStatus status;
  final String? content;
  final String? error;

  ExplanationState({
    required this.status,
    this.content,
    this.error,
  });

  factory ExplanationState.initial() => ExplanationState(status: ExplanationStatus.initial);
  factory ExplanationState.loading() => ExplanationState(status: ExplanationStatus.loading);
  factory ExplanationState.success(String content) =>
      ExplanationState(status: ExplanationStatus.success, content: content);
  factory ExplanationState.error(String error) =>
      ExplanationState(status: ExplanationStatus.error, error: error);
}

class ExplanationController extends ChangeNotifier {
  final AiService _aiService;
  
  ExplanationController(this._aiService);
  
  bool get isAiAvailable => _aiService.isAvailable;

  final Map<String, ExplanationState> _cache = {};

  ExplanationState getState(String itemId) =>
      _cache[itemId] ?? ExplanationState.initial();

  Future<void> requestExplanation({
    required String itemId,
    required String question,
    required List<String> options,
    required String correctAnswer,
    String? userSelection,
  }) async {
    if (_cache.containsKey(itemId) && _cache[itemId]!.status == ExplanationStatus.success) {
      return;
    }

    _cache[itemId] = ExplanationState.loading();
    notifyListeners();

    try {
      final content = await _aiService.getExplanation(
        question: question,
        options: options,
        correctAnswer: correctAnswer,
        userSelection: userSelection,
      );
      _cache[itemId] = ExplanationState.success(content);
    } catch (e) {
      _cache[itemId] = ExplanationState.error(e.toString());
    }

    notifyListeners();
  }

  void clearCache() {
    _cache.clear();
    notifyListeners();
  }
}

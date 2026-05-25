import 'package:flutter/widgets.dart';
import 'ai_service.dart';
import '../../study/domain/learning_models.dart';

enum AiQuizStatus { initial, generating, success, error }

class AiQuizController extends ChangeNotifier {
  final AiService _aiService;

  AiQuizController(this._aiService);

  AiQuizStatus _status = AiQuizStatus.initial;
  AiQuizStatus get status => _status;

  QuizSet? _generatedQuiz;
  QuizSet? get generatedQuiz => _generatedQuiz;

  String? _error;
  String? get error => _error;

  Future<void> generatePracticeQuiz({
    required String subject,
    required String examStyle,
  }) async {
    _status = AiQuizStatus.generating;
    _error = null;
    notifyListeners();

    try {
      final json = await _aiService.generateQuiz(
        subject: subject,
        examStyle: examStyle,
      );
      
      // Add missing fields for the model
      json['examFormat'] = 'mcq';
      json['mode'] = 'Practice';
      json['difficulty'] = 'Intermediate';

      _generatedQuiz = QuizSet.fromJson(json);
      _status = AiQuizStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = AiQuizStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _status = AiQuizStatus.initial;
    _generatedQuiz = null;
    _error = null;
    notifyListeners();
  }
}

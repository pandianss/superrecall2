import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  final String? apiKey;
  late final GenerativeModel? _model;

  AiService({this.apiKey}) {
    if (apiKey != null && apiKey!.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: apiKey!,
        generationConfig: GenerationConfig(
          temperature: 0.1,
          topK: 32,
          topP: 0.95,
          maxOutputTokens: 1024,
        ),
      );
    } else {
      _model = null;
    }
  }

  bool get isAvailable => _model != null;

  Future<String> getExplanation({
    required String question,
    required List<String> options,
    required String correctAnswer,
    String? userSelection,
  }) async {
    if (_model == null) {
      // Mock behavior if no API key
      await Future.delayed(const Duration(seconds: 2));
      return "*(Mock Explanation)*: This is a placeholder explanation because no Gemini API key is configured. In a production environment, Gemini would analyze why the correct answer is '$correctAnswer' and why your choice '${userSelection ?? 'N/A'}' might have been incorrect.";
    }

    final prompt = """
    You are an expert exam preparation tutor for SuperRecall.
    Analyze the following multiple-choice question and provide a high-impact, educational breakdown.
    
    Question: $question
    Options: ${options.join(', ')}
    Correct Answer: $correctAnswer
    User Selected: ${userSelection ?? "No selection"}
    
    Structure your response using these Markdown sections:
    1. **The Core Logic**: Explain the fundamental concept being tested.
    2. **Why '$correctAnswer' is Correct**: A precise technical justification.
    3. **Common Pitfalls**: Briefly explain why the other options (especially '${userSelection ?? "the user's choice"}') are tempting but wrong.
    4. **Study Tip**: One actionable sentence on how to master this specific sub-topic.
    
    Tone: Professional, encouraging, and concise. 
    Constraint: Under 180 words total.
    """;

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? "I'm sorry, I couldn't generate an explanation at this time.";
    } catch (e) {
      return "Error generating explanation: ${e.toString()}";
    }
  }

  Future<Map<String, dynamic>> generateQuiz({
    required String subject,
    required String examStyle,
    int questionCount = 5,
  }) async {
    if (_model == null) {
      await Future.delayed(const Duration(seconds: 3));
      return {
        "id": "mock_ai_quiz",
        "title": "Practice Quiz: $subject",
        "subjectArea": subject,
        "questions": List.generate(questionCount, (i) => {
          "id": "mock_q_$i",
          "promptBlocks": [{"type": "paragraph", "content": "This is a mock question about $subject (Question ${i + 1})."}],
          "options": [
            {"label": "A", "value": "Correct Answer", "status": "correct"},
            {"label": "B", "value": "Distractor 1", "status": "incorrect"},
            {"label": "C", "value": "Distractor 2", "status": "incorrect"},
            {"label": "D", "value": "Distractor 3", "status": "incorrect"},
          ],
          "explanation": "This is a mock explanation for the AI-generated quiz.",
        })
      };
    }

    final prompt = """
    Generate a $questionCount-question multiple choice quiz on the subject of '$subject'.
    The quiz should be in the style of a '$examStyle' exam.
    
    Output the result STRICTLY as a single JSON object with this structure:
    {
      "id": "ai_generated_[timestamp]",
      "title": "AI Practice: $subject",
      "subjectArea": "$subject",
      "questions": [
        {
          "id": "q1",
          "promptBlocks": [{"type": "paragraph", "content": "...question text..."}],
          "options": [
            {"label": "A", "value": "...", "status": "correct"},
            {"label": "B", "value": "...", "status": "incorrect"},
            ...up to D
          ],
          "explanation": "..."
        }
      ]
    }
    
    Ensure questions are technically accurate and challenging.
    Do not include any text before or after the JSON.
    """;

    try {
      final response = await _model.generateContent(
        [Content.text(prompt)],
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );
      final text = response.text ?? "";
      
      try {
        return jsonDecode(text) as Map<String, dynamic>;
      } catch (_) {
        // Fallback for older models or unexpected formats
        final jsonRegex = RegExp(r'\{[\s\S]*\}');
        final match = jsonRegex.firstMatch(text);
        if (match != null) {
          return jsonDecode(match.group(0)!) as Map<String, dynamic>;
        }
        rethrow;
      }
    } catch (e) {
      throw Exception("Failed to parse AI response as JSON: ${e.toString()}");
    }
  }
}

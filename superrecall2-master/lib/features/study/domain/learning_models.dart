enum LearningFormat { video, note, flashcard, practice }

enum ExamFormatType {
  mcq,
  descriptive,
  caseStudy,
  numerical,
  essay,
  shortAnswer,
}

enum LessonBlockType { paragraph, equation, callout, table }

enum QuestionOptionStatus { correct, distractor }

class ExamCatalog {
  const ExamCatalog({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.recommendedDailyMinutes,
    required this.weeklyAssessmentLabel,
    required this.focusAreas,
    required this.weeklyRhythm,
    required this.subjects,
    this.schemaVersion = 1,
  });

  final int schemaVersion;
  final String id;
  final String name;
  final String shortDescription;
  final int recommendedDailyMinutes;
  final String weeklyAssessmentLabel;
  final List<String> focusAreas;
  final List<String> weeklyRhythm;
  final List<SubjectCatalog> subjects;

  int get totalModules =>
      subjects.fold(0, (sum, subject) => sum + subject.modules.length);

  int get totalTopics =>
      subjects.fold(0, (sum, subject) => sum + subject.totalTopics);

  int get totalLessons =>
      subjects.fold(0, (sum, subject) => sum + subject.totalLessons);

  int get totalQuizzes =>
      subjects.fold(0, (sum, subject) => sum + subject.totalQuizzes);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'shortDescription': shortDescription,
        'recommendedDailyMinutes': recommendedDailyMinutes,
        'weeklyAssessmentLabel': weeklyAssessmentLabel,
        'focusAreas': focusAreas,
        'weeklyRhythm': weeklyRhythm,
        'subjects': subjects.map((e) => e.toJson()).toList(),
        'schemaVersion': schemaVersion,
      };

  factory ExamCatalog.fromJson(Map<String, dynamic> json) => ExamCatalog(
        id: json['id'] as String,
        name: json['name'] as String,
        shortDescription: json['shortDescription'] as String,
        recommendedDailyMinutes: json['recommendedDailyMinutes'] as int,
        weeklyAssessmentLabel: json['weeklyAssessmentLabel'] as String,
        focusAreas: (json['focusAreas'] as List<dynamic>).map((e) => e as String).toList(),
        weeklyRhythm: (json['weeklyRhythm'] as List<dynamic>).map((e) => e as String).toList(),
        subjects: (json['subjects'] as List<dynamic>)
            .map((e) => SubjectCatalog.fromJson(e as Map<String, dynamic>))
            .toList(),
        schemaVersion: json['schemaVersion'] as int? ?? 1,
      );
}

class SubjectCatalog {
  const SubjectCatalog({
    required this.id,
    required this.name,
    required this.description,
    required this.examFormats,
    required this.modules,
    this.isPremium = false,
    this.price = 0,
  });

  final String id;
  final String name;
  final String description;
  final List<ExamFormatType> examFormats;
  final List<ModuleCatalog> modules;
  final bool isPremium;
  final double price;

  int get totalTopics =>
      modules.fold(0, (sum, module) => sum + module.topics.length);

  int get totalLessons =>
      modules.fold(0, (sum, module) => sum + module.totalLessons);

  int get totalQuizzes =>
      modules.fold(0, (sum, module) => sum + module.totalQuizzes);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'examFormats': examFormats.map((e) => e.name).toList(),
        'modules': modules.map((e) => e.toJson()).toList(),
        'isPremium': isPremium,
        'price': price,
      };

  factory SubjectCatalog.fromJson(Map<String, dynamic> json) => SubjectCatalog(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        examFormats: (json['examFormats'] as List<dynamic>)
            .map((e) => ExamFormatType.values.byName(e as String))
            .toList(),
        modules: (json['modules'] as List<dynamic>)
            .map((e) => ModuleCatalog.fromJson(e as Map<String, dynamic>))
            .toList(),
        isPremium: json['isPremium'] as bool? ?? false,
        price: (json['price'] as num?)?.toDouble() ?? 0,
      );
}

class ModuleCatalog {
  const ModuleCatalog({
    required this.id,
    required this.name,
    required this.description,
    required this.topics,
  });

  final String id;
  final String name;
  final String description;
  final List<TopicCatalog> topics;

  int get totalLessons =>
      topics.fold(0, (sum, topic) => sum + topic.lessons.length);

  int get totalQuizzes =>
      topics.fold(0, (sum, topic) => sum + topic.quizzes.length);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'topics': topics.map((e) => e.toJson()).toList(),
      };

  factory ModuleCatalog.fromJson(Map<String, dynamic> json) => ModuleCatalog(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        topics: (json['topics'] as List<dynamic>)
            .map((e) => TopicCatalog.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class TopicCatalog {
  TopicCatalog({
    required this.id,
    required this.name,
    required this.summary,
    required this.examFormats,
    required this.notationSupport,
    required this.lessons,
    required this.quizzes,
    required this.progress,
  }) : assert(
         progress.completedLessons <= lessons.length,
         'Completed lessons cannot exceed the topic lesson count.',
       );

  final String id;
  final String name;
  final String summary;
  final List<ExamFormatType> examFormats;
  final bool notationSupport;
  final List<LessonUnit> lessons;
  final List<QuizSet> quizzes;
  final TopicProgress progress;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'summary': summary,
        'examFormats': examFormats.map((e) => e.name).toList(),
        'notationSupport': notationSupport,
        'lessons': lessons.map((e) => e.toJson()).toList(),
        'quizzes': quizzes.map((e) => e.toJson()).toList(),
        'progress': progress.toJson(),
      };

  factory TopicCatalog.fromJson(Map<String, dynamic> json) => TopicCatalog(
        id: json['id'] as String,
        name: json['name'] as String,
        summary: json['summary'] as String,
        examFormats: (json['examFormats'] as List<dynamic>)
            .map((e) => ExamFormatType.values.byName(e as String))
            .toList(),
        notationSupport: json['notationSupport'] as bool? ?? false,
        lessons: (json['lessons'] as List<dynamic>)
            .map((e) => LessonUnit.fromJson(e as Map<String, dynamic>))
            .toList(),
        quizzes: (json['quizzes'] as List<dynamic>)
            .map((e) => QuizSet.fromJson(e as Map<String, dynamic>))
            .toList(),
        progress: TopicProgress.fromJson(json['progress'] as Map<String, dynamic>),
      );
}

class LessonUnit {
  const LessonUnit({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.format,
    required this.blocks,
  });

  final String id;
  final String title;
  final int durationMinutes;
  final LearningFormat format;
  final List<LessonContentBlock> blocks;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'durationMinutes': durationMinutes,
        'format': format.name,
        'blocks': blocks.map((e) => e.toJson()).toList(),
      };

  factory LessonUnit.fromJson(Map<String, dynamic> json) => LessonUnit(
        id: json['id'] as String,
        title: json['title'] as String,
        durationMinutes: json['durationMinutes'] as int,
        format: LearningFormat.values.byName(json['format'] as String),
        blocks: (json['blocks'] as List<dynamic>)
            .map((e) => LessonContentBlock.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class LessonContentBlock {
  const LessonContentBlock.paragraph(this.content)
    : type = LessonBlockType.paragraph;

  const LessonContentBlock.equation(this.content)
    : type = LessonBlockType.equation;

  const LessonContentBlock.callout(this.content)
    : type = LessonBlockType.callout;

  const LessonContentBlock.table(this.content)
    : type = LessonBlockType.table;

  final LessonBlockType type;
  final String content;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'content': content,
      };

  factory LessonContentBlock.fromJson(Map<String, dynamic> json) {
    final type = LessonBlockType.values.byName(json['type'] as String);
    final content = json['content'] as String;
    switch (type) {
      case LessonBlockType.paragraph:
        return LessonContentBlock.paragraph(content);
      case LessonBlockType.equation:
        return LessonContentBlock.equation(content);
      case LessonBlockType.callout:
        return LessonContentBlock.callout(content);
      case LessonBlockType.table:
        return LessonContentBlock.table(content);
    }
  }
}

class QuizSet {
  const QuizSet({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.mode,
    required this.examFormat,
    required this.questions,
  });

  final String id;
  final String title;
  final int questionCount;
  final String mode;
  final ExamFormatType examFormat;
  final List<QuizQuestion> questions;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'questionCount': questionCount,
        'mode': mode,
        'examFormat': examFormat.name,
        'questions': questions.map((e) => e.toJson()).toList(),
      };

  factory QuizSet.fromJson(Map<String, dynamic> json) => QuizSet(
        id: json['id'] as String,
        title: json['title'] as String,
        questionCount: json['questionCount'] as int,
        mode: json['mode'] as String,
        examFormat: ExamFormatType.values.byName(json['examFormat'] as String),
        questions: (json['questions'] as List<dynamic>)
            .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.promptBlocks,
    required this.examFormat,
    required this.options,
    required this.explanation,
  });

  final String id;
  final List<LessonContentBlock> promptBlocks;
  final ExamFormatType examFormat;
  final List<QuestionOption> options;
  final String explanation;

  QuestionOption? get correctOption {
    for (final option in options) {
      if (option.status == QuestionOptionStatus.correct) {
        return option;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'promptBlocks': promptBlocks.map((e) => e.toJson()).toList(),
        'examFormat': examFormat.name,
        'options': options.map((e) => e.toJson()).toList(),
        'explanation': explanation,
      };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json['id'] as String,
        promptBlocks: (json['promptBlocks'] as List<dynamic>)
            .map((e) => LessonContentBlock.fromJson(e as Map<String, dynamic>))
            .toList(),
        examFormat: ExamFormatType.values.byName(json['examFormat'] as String),
        options: (json['options'] as List<dynamic>)
            .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
            .toList(),
        explanation: json['explanation'] as String,
      );
}

class QuestionOption {
  const QuestionOption({
    required this.label,
    required this.value,
    required this.status,
  });

  final String label;
  final String value;
  final QuestionOptionStatus status;

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
        'status': status.name,
      };

  factory QuestionOption.fromJson(Map<String, dynamic> json) => QuestionOption(
        label: json['label'] as String,
        value: json['value'] as String,
        status: QuestionOptionStatus.values.byName(json['status'] as String),
      );
}

class TopicProgress {
  const TopicProgress({
    required this.completedLessons,
    required this.masteryPercent,
  }) : assert(completedLessons >= 0),
       assert(masteryPercent >= 0 && masteryPercent <= 100);

  final int completedLessons;
  final int masteryPercent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicProgress &&
          runtimeType == other.runtimeType &&
          completedLessons == other.completedLessons &&
          masteryPercent == other.masteryPercent;

  @override
  int get hashCode => completedLessons.hashCode ^ masteryPercent.hashCode;

  Map<String, dynamic> toJson() => {
        'completedLessons': completedLessons,
        'masteryPercent': masteryPercent,
      };

  factory TopicProgress.fromJson(Map<String, dynamic> json) => TopicProgress(
        completedLessons: json['completedLessons'] as int,
        masteryPercent: json['masteryPercent'] as int,
      );
}

String describeLearningFormat(LearningFormat format) {
  switch (format) {
    case LearningFormat.video:
      return 'Video';
    case LearningFormat.note:
      return 'Notes';
    case LearningFormat.flashcard:
      return 'Flashcards';
    case LearningFormat.practice:
      return 'Practice';
  }
}

String describeExamFormat(ExamFormatType format) {
  switch (format) {
    case ExamFormatType.mcq:
      return 'MCQ';
    case ExamFormatType.descriptive:
      return 'Descriptive';
    case ExamFormatType.caseStudy:
      return 'Case study';
    case ExamFormatType.numerical:
      return 'Numerical';
    case ExamFormatType.essay:
      return 'Essay';
    case ExamFormatType.shortAnswer:
      return 'Short answer';
  }
}

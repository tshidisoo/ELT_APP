// Listening exercise model for level-based listening practice

class ListeningQuestion {
  final String id;
  final String question;
  final List<String> options; // empty list = open-ended
  final String? correctAnswer;
  final String type; // 'multiple_choice', 'open', 'true_false'

  const ListeningQuestion({
    required this.id,
    required this.question,
    this.options = const [],
    this.correctAnswer,
    this.type = 'multiple_choice',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'question': question,
        'options': options,
        'correctAnswer': correctAnswer,
        'type': type,
      };

  factory ListeningQuestion.fromMap(Map<String, dynamic> m) =>
      ListeningQuestion(
        id: m['id'] ?? '',
        question: m['question'] ?? '',
        options: List<String>.from(m['options'] ?? []),
        correctAnswer: m['correctAnswer'],
        type: m['type'] ?? 'multiple_choice',
      );
}

class ListeningExercise {
  final String id;
  final String level; // "Family and Friends 1"
  final String unit; // "Starter Unit", "Unit 1"
  final String title;
  final String instructions;
  final String? audioUrl; // Firebase Storage URL (teacher uploads audio)
  final String? trackLabel; // e.g. "Track 3 – Listen and point"
  final String? transcriptHint; // short description of what audio contains
  final List<ListeningQuestion> questions;
  final int xpReward;
  final int order;

  const ListeningExercise({
    required this.id,
    required this.level,
    required this.unit,
    required this.title,
    required this.instructions,
    this.audioUrl,
    this.trackLabel,
    this.transcriptHint,
    this.questions = const [],
    this.xpReward = 15,
    this.order = 0,
  });
}

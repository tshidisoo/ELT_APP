// Speaking topic model for level-based speaking practice

class SpeakingTopic {
  final String id;
  final String level;
  final String unit;
  final String title;
  final String instructions;
  final List<String> spinWheelQuestions; // shown on spin wheel
  final List<String> sentenceStarters; // optional prompts
  final String? vocabularyFocus; // vocabulary to use
  final int xpReward;
  final int order;

  const SpeakingTopic({
    required this.id,
    required this.level,
    required this.unit,
    required this.title,
    required this.instructions,
    this.spinWheelQuestions = const [],
    this.sentenceStarters = const [],
    this.vocabularyFocus,
    this.xpReward = 10,
    this.order = 0,
  });
}

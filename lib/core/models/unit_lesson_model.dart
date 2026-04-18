/// Shared model for static unit lesson content across all book levels.
class UnitLesson {
  final String id;
  final String level; // e.g. "Family and Friends 3"
  final String unit; // e.g. "Unit 1"
  final String title;
  final String bookType; // "classbook" or "workbook"
  final String flipbookUrl;
  final String objectives;
  final List<String> vocabulary;
  final List<String> keyStructures;
  final List<String> activities;
  final List<String> keyPoints;
  final int order;

  const UnitLesson({
    required this.id,
    required this.level,
    required this.unit,
    required this.title,
    required this.bookType,
    required this.flipbookUrl,
    required this.objectives,
    required this.vocabulary,
    required this.keyStructures,
    required this.activities,
    required this.keyPoints,
    required this.order,
  });
}

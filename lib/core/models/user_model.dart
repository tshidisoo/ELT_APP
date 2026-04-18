import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String role; // 'student' or 'teacher'
  final String? photoUrl;
  final int xp;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActiveDate;
  final List<String> badges;
  final DateTime createdAt;
  final String englishLevel; // book/curriculum level (students only)
  final String? cefrLevel;   // CEFR level A1–C1 (optional)

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.role,
    this.photoUrl,
    this.xp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActiveDate,
    this.badges = const [],
    required this.createdAt,
    this.englishLevel = '',
    this.cefrLevel,
  });

  bool get isTeacher => role == AppConstants.roleTeacher;
  bool get isStudent => role == AppConstants.roleStudent;

  String get levelName {
    if (xp >= 1500) return 'Fluent';
    if (xp >= 700) return 'Achiever';
    if (xp >= 300) return 'Communicator';
    if (xp >= 100) return 'Explorer';
    return 'Starter';
  }

  int get levelNumber {
    if (xp >= 1500) return 5;
    if (xp >= 700) return 4;
    if (xp >= 300) return 3;
    if (xp >= 100) return 2;
    return 1;
  }

  double get levelProgress {
    final thresholds = [0, 100, 300, 700, 1500, 9999];
    for (int i = 0; i < thresholds.length - 1; i++) {
      if (xp < thresholds[i + 1]) {
        final rangeStart = thresholds[i];
        final rangeEnd = thresholds[i + 1];
        return (xp - rangeStart) / (rangeEnd - rangeStart);
      }
    }
    return 1.0;
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? AppConstants.roleStudent,
      photoUrl: data['photoUrl'],
      xp: (data['xp'] ?? 0) as int,
      currentStreak: (data['currentStreak'] ?? 0) as int,
      longestStreak: (data['longestStreak'] ?? 0) as int,
      lastActiveDate: data['lastActiveDate'] != null
          ? (data['lastActiveDate'] as Timestamp).toDate()
          : null,
      badges: List<String>.from(data['badges'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      englishLevel: data['englishLevel'] ?? '',
      cefrLevel: data['cefrLevel'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'displayName': displayName,
        'email': email,
        'role': role,
        'photoUrl': photoUrl,
        'xp': xp,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastActiveDate':
            lastActiveDate != null ? Timestamp.fromDate(lastActiveDate!) : null,
        'badges': badges,
        'createdAt': Timestamp.fromDate(createdAt),
        'englishLevel': englishLevel,
        'cefrLevel': cefrLevel,
      };

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    int? xp,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActiveDate,
    List<String>? badges,
    String? englishLevel,
    String? cefrLevel,
  }) {
    return UserModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      role: role,
      photoUrl: photoUrl ?? this.photoUrl,
      xp: xp ?? this.xp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      badges: badges ?? this.badges,
      createdAt: createdAt,
      englishLevel: englishLevel ?? this.englishLevel,
      cefrLevel: cefrLevel ?? this.cefrLevel,
    );
  }
}

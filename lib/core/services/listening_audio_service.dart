import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Manages teacher-uploaded audio files for listening exercises.
/// Audio URLs are stored in Firestore separately from the static exercise data,
/// so the teacher can upload/replace audio without a code change.
class ListeningAudioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const _collection = 'listening_audio';

  // ── Read ────────────────────────────────────────────────────────────────────

  /// Stream of all uploaded audio URLs: exerciseId → downloadUrl
  Stream<Map<String, String>> watchAudioUrls() {
    return _db.collection(_collection).snapshots().map((snap) {
      return {
        for (final doc in snap.docs)
          doc.id: (doc.data()['audioUrl'] as String? ?? ''),
      }..removeWhere((_, v) => v.isEmpty);
    });
  }

  /// One-time fetch of a single exercise's audio URL (null if not uploaded yet).
  Future<String?> getAudioUrl(String exerciseId) async {
    final snap = await _db.collection(_collection).doc(exerciseId).get();
    if (!snap.exists) return null;
    final url = snap.data()?['audioUrl'] as String?;
    return (url != null && url.isNotEmpty) ? url : null;
  }

  // ── Write ───────────────────────────────────────────────────────────────────

  /// Upload an audio file for an exercise. Replaces any previously uploaded file.
  /// [filePath] is the local file path from file_picker.
  /// Returns the download URL on success.
  Future<String> uploadAudio({
    required String exerciseId,
    required String filePath,
    required String uploadedBy,
    void Function(double progress)? onProgress,
  }) async {
    final file = File(filePath);
    final ext = filePath.split('.').last.toLowerCase();
    final storageRef = _storage.ref('listening_audio/$exerciseId.$ext');

    final uploadTask = storageRef.putFile(
      file,
      SettableMetadata(contentType: 'audio/$ext'),
    );

    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((snap) {
        final progress = snap.bytesTransferred / snap.totalBytes;
        onProgress(progress);
      });
    }

    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    await _db.collection(_collection).doc(exerciseId).set({
      'audioUrl': downloadUrl,
      'uploadedBy': uploadedBy,
      'uploadedAt': FieldValue.serverTimestamp(),
      'fileName': filePath.split(Platform.pathSeparator).last,
    });

    return downloadUrl;
  }

  /// Remove the audio for an exercise (deletes from Storage and Firestore).
  Future<void> deleteAudio(String exerciseId) async {
    final snap = await _db.collection(_collection).doc(exerciseId).get();
    if (!snap.exists) return;

    // Delete from Storage if URL is present
    final url = snap.data()?['audioUrl'] as String?;
    if (url != null && url.isNotEmpty) {
      try {
        await _storage.refFromURL(url).delete();
      } catch (_) {
        // File may already be gone — continue with Firestore cleanup
      }
    }

    await _db.collection(_collection).doc(exerciseId).delete();
  }
}

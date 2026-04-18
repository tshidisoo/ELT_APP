import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary palette — Teal ─────────────────────────────────────────────────
  static const Color primary      = Color(0xFF0D9488); // teal-600
  static const Color primaryLight = Color(0xFF2DD4BF); // teal-400 / turquoise
  static const Color primaryDark  = Color(0xFF0F766E); // teal-700

  // ── Secondary / accent — Cyan ──────────────────────────────────────────────
  static const Color secondary      = Color(0xFF06B6D4); // cyan-500
  static const Color secondaryLight = Color(0xFF67E8F9); // cyan-300
  static const Color secondaryDark  = Color(0xFF0891B2); // cyan-600

  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF0FDFA); // teal-50
  static const Color backgroundDark  = Color(0xFF042F2E); // near-black teal
  static const Color surfaceLight    = Color(0xFFFFFFFF);
  static const Color surfaceDark     = Color(0xFF134E4A); // teal-900
  static const Color cardLight       = Color(0xFFFFFFFF);
  static const Color cardDark        = Color(0xFF115E59); // teal-800

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimaryLight   = Color(0xFF134E4A); // teal-900
  static const Color textPrimaryDark    = Color(0xFFCCFBF1); // teal-100
  static const Color textSecondaryLight = Color(0xFF6B7280); // neutral gray
  static const Color textSecondaryDark  = Color(0xFF99F6E4); // teal-200

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  // ── XP / Gamification ─────────────────────────────────────────────────────
  static const Color xpGold      = Color(0xFFFFD700);
  static const Color xpBar       = Color(0xFF0D9488); // teal
  static const Color streakOrange = Color(0xFFFF6B35);
  static const Color badgeGold   = Color(0xFFFFB800);
  static const Color badgeSilver = Color(0xFFC0C0C0);
  static const Color badgeBronze = Color(0xFFCD7F32);

  // ── Level colours ─────────────────────────────────────────────────────────
  static const Color levelNovice     = Color(0xFF94A3B8); // slate-400
  static const Color levelApprentice = Color(0xFF22C55E); // green
  static const Color levelStudent    = Color(0xFF06B6D4); // cyan
  static const Color levelMusician   = Color(0xFF0D9488); // teal
  static const Color levelMaestro    = Color(0xFFFFD700); // gold

  // ── Gradient presets ──────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero / splash / header gradient — deep teal → teal → bright turquoise
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF0D9488), Color(0xFF2DD4BF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Figmaデザインガイドラインに基づくカラーパレット
  static const Color primaryColor = Color(0xFFEA3800); // Primary: #EA3800
  static const Color primaryForeground = Color(0xFFFFFFFF); // Primary Foreground
  static const Color destructiveColor = Color(0xFFD4183D); // Destructive: #d4183d
  static const Color mutedColor = Color(0xFFECECF0); // Muted: #ececf0
  static const Color mutedForeground = Color(0xFF717182); // Muted Foreground: #717182
  static const Color inputBackground = Color(0xFFF3F3F5); // Input background: #f3f3f5
  
  // フォーカス時の色（Figmaガイドラインでは ring = グレー系）
  static const Color ringColor = Color(0xFF6B7280); // フォーカス時のボーダー色: グレー
  static const Color ringColorLight = Color(0x806B7280); // フォーカス時のリング色: 50%透明度
  
  // セマンティックカラー
  static const Color successColor = primaryColor; // 成功状態はプライマリカラーで代用
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansJpTextTheme(), // Noto Sans JP統一
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          onPrimary: primaryForeground,
          secondary: mutedColor,
          onSecondary: mutedForeground,
          error: destructiveColor,
          onError: primaryForeground,
          surface: Colors.white,
          onSurface: Colors.black87,
          surfaceContainerHighest: mutedColor,
          outline: mutedColor,
        ),
        // AppBar設定
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
        ),
        // Button設定
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryColor,
            foregroundColor: primaryForeground,
            disabledBackgroundColor: mutedColor,
            disabledForegroundColor: mutedForeground,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.black87,
            side: const BorderSide(color: mutedColor),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        // Input設定 (Figmaガイドライン準拠)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputBackground, // #f3f3f5
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none, // 透明ボーダー
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: ringColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: destructiveColor, width: 2),
          ),
          // Figmaガイドライン: px-3 py-1 = 左右12px、上下4px
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          hintStyle: const TextStyle(
            color: mutedForeground,
            fontSize: 14,
          ),
          // Input高さ: 36px (h-9)
          constraints: const BoxConstraints(minHeight: 36),
        ),
        // Card設定
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: mutedColor, width: 1),
          ),
          color: Colors.white,
        ),
        // Chip設定
        chipTheme: ChipThemeData(
          backgroundColor: mutedColor,
          labelStyle: const TextStyle(
            color: mutedForeground,
            fontSize: 12,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // BottomNavigationBar設定
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: mutedForeground,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansJpTextTheme(
          ThemeData.dark().textTheme, // ダークテーマ用のベースカラー
        ), // Noto Sans JP統一
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          onPrimary: primaryForeground,
          secondary: Color(0xFF2A2A2E),
          onSecondary: Color(0xFFE5E5E5),
          error: destructiveColor,
          onError: primaryForeground,
          surface: Color(0xFF1A1A1A),
          onSurface: Color(0xFFE5E5E5),
          surfaceContainerHighest: Color(0xFF2A2A2E),
          outline: Color(0xFF404040),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Color(0xFFE5E5E5),
          surfaceTintColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: primaryColor,
            foregroundColor: primaryForeground,
            disabledBackgroundColor: const Color(0xFF2A2A2E),
            disabledForegroundColor: const Color(0xFF666666),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            elevation: 0,
            foregroundColor: const Color(0xFFE5E5E5),
            side: const BorderSide(color: Color(0xFF404040)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none, // 透明ボーダー
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: ringColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: destructiveColor, width: 2),
          ),
          // Figmaガイドライン: px-3 py-1 = 左右12px、上下4px
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          hintStyle: const TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
          ),
          // Input高さ: 36px (h-9)
          constraints: const BoxConstraints(minHeight: 36),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF404040), width: 1),
          ),
          color: const Color(0xFF2A2A2E),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: primaryColor,
          unselectedItemColor: Color(0xFF666666),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      );

  // カスタムカラー（テーマで使用されない追加カラー）
  static const Map<String, Color> customColors = {
    'success': successColor,
    'warning': warningColor,
    'info': infoColor,
  };
}
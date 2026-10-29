class AppDateUtils {
  static const List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  /// Returns localized Indonesian day, date, month, year.
  /// Example: "Kamis, 29 Oktober 2026"
  static String getFormattedToday() {
    final now = DateTime.now();
    final dayName = _days[now.weekday - 1];
    final monthName = _months[now.month - 1];
    return '$dayName, ${now.day} $monthName ${now.year}';
  }

  /// Returns contextual Indonesian greeting based on current local hour.
  /// Example: "Selamat Pagi", "Selamat Siang", "Selamat Sore", "Selamat Malam"
  static String getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'Selamat Pagi';
    if (hour >= 11 && hour < 15) return 'Selamat Siang';
    if (hour >= 15 && hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}

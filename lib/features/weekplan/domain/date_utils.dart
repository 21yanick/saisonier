/// Shared date utilities for weekplan feature
class WeekplanDateUtils {
  WeekplanDateUtils._();

  static const weekdayNamesShort = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
  static const monthNamesShort = [
    'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',
    'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'
  ];

  /// Format date as "Mo, 9.12."
  static String formatDayShort(DateTime date) {
    return '${weekdayNamesShort[date.weekday - 1]}, ${date.day}.${date.month}.';
  }

  /// Format date relative to today ("Heute", "Morgen", or "Mo 9.12.")
  static String formatRelative(DateTime date) {
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    final dateNorm = DateTime(date.year, date.month, date.day);

    if (dateNorm == todayNorm) return 'Heute';
    if (dateNorm == todayNorm.add(const Duration(days: 1))) return 'Morgen';

    return '${weekdayNamesShort[date.weekday - 1]} ${date.day}.${date.month}.';
  }

  /// Format week range as "8. - 14. Dez" or "28. Nov - 4. Dez"
  static String formatWeekRange(DateTime weekStart) {
    final end = weekStart.add(const Duration(days: 6));

    if (weekStart.month == end.month) {
      return '${weekStart.day}. - ${end.day}. ${monthNamesShort[weekStart.month - 1]}';
    }
    return '${weekStart.day}. ${monthNamesShort[weekStart.month - 1]} - ${end.day}. ${monthNamesShort[end.month - 1]}';
  }
}

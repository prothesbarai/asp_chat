class DateTimeHelper {

  /// >>> Format DateTime → "18 Oct 2025, 05:20 PM"
  static String formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final month = months[date.month - 1];
    final year = date.year;
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? "PM" : "AM";
    return "$day $month $year, ${hour.toString().padLeft(2, '0')}:$minute $amPm";
  }


  /// >>> Only Date Without Time  → "18 Oct 2025"
  static String formatDateOnly(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final month = months[date.month - 1];
    final year = date.year;
    return "$day $month $year";
  }


  /// >>> Only Time Without Date → "05:20 PM"
  static String formatTimeOnly(DateTime date) {
    int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:$minute $amPm";
  }


  static String formatDuration(int totalSeconds) {
    if(totalSeconds < 0) totalSeconds = 0;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return "${hours.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2,'0')}";
  }



}
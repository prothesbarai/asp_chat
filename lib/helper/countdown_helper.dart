import 'dart:async';

/// A reusable helper for:
/// - Comparing a target DateTime with current time
/// - Running countdown if future
/// - Returning formatted countdown text
class CountdownHelper {
  Timer? _timer;
  Duration _remainingDuration = Duration.zero;
  bool _isFuture = false;

  /// Callback to notify UI (setState / notifier / stream)
  final void Function()? onTick;

  CountdownHelper({this.onTick});

  /// >>> Compare + Countdown handler
  void handle(DateTime targetDateTime) {
    _timer?.cancel();
    void update() {
      final now = DateTime.now();
      if (targetDateTime.isAfter(now)) {
        _isFuture = true;
        _remainingDuration = targetDateTime.difference(now);
      } else {
        _isFuture = false;
        _remainingDuration = Duration.zero;
        _timer?.cancel();
      }
      onTick?.call();
    }

    // >>> initial run
    update();
    // >>> start timer only if future
    if (targetDateTime.isAfter(DateTime.now())) {_timer = Timer.periodic(const Duration(seconds: 1), (_) => update(),);}
  }


  /// >>> Countdown formatted as string (2-line, for legacy use) [Note : Direct Use so then call UI  Type 1 :  Call UI  : Text(_countdownHelper.formattedCountdown) Directly]
   String get formattedCountdown {
    final parts = countdownParts;
    return parts.isFuture ? "${parts.years.toString().padLeft(2, '0')}Y ${parts.months.toString().padLeft(2, '0')}M ${parts.days.toString().padLeft(2, '0')}D\nHour ${parts.hours.toString().padLeft(2, '0')} : Min ${parts.minutes.toString().padLeft(2, '0')} : Sec ${parts.seconds.toString().padLeft(2, '0')}" : "00Y 00M 00D\nHour 00 : Min 00 : Sec 00";
  }

  /// >>> Countdown parts as structured data for UI  [ Note : For Specific Parts UI Call Purpose Type 2 :  Call UI  : final parts = _countdownHelper.countdownParts; Text(parts.years) Only Single Part]
  CountdownParts get countdownParts {
    if (!_isFuture) {return CountdownParts(years: 0, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0, isFuture: false,);}

    int totalSeconds = _remainingDuration.inSeconds;
    int days = totalSeconds ~/ (24 * 3600);

    int years = days ~/ 365;
    int months = (days % 365) ~/ 30;
    int remainingDays = (days % 365) % 30;

    int hours = (_remainingDuration.inHours) % 24;
    int minutes = (_remainingDuration.inMinutes) % 60;
    int seconds = (_remainingDuration.inSeconds) % 60;

    return CountdownParts(years: years, months: months, days: remainingDays, hours: hours, minutes: minutes, seconds: seconds, isFuture: true,);
  }

  /// >>> Extra: Countdown parts in TOTAL Days + HH:MM:SS (Year+Month converted to Days) [ Note : For Specific Parts UI Call Purpose Type 3 :  Call UI  : final parts = _countdownHelper.countdownInDays; Text(parts.days) Only Single Part]
  CountdownParts get countdownInDays {
    if (!_isFuture) {return CountdownParts(years: 0, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0, isFuture: false,);}
    int totalSeconds = _remainingDuration.inSeconds;
    int totalDays = totalSeconds ~/ (24 * 3600); // Total days including years + months
    int hours = (_remainingDuration.inHours) % 24;
    int minutes = (_remainingDuration.inMinutes) % 60;
    int seconds = (_remainingDuration.inSeconds) % 60;
    return CountdownParts(years: 0, months: 0, days: totalDays, hours: hours, minutes: minutes, seconds: seconds, isFuture: true,);
  }



  /// >>> Whether target datetime is in future
  bool get isFuture => _isFuture;

  /// >>> Cleanup
  void dispose() {
    _timer?.cancel();
  }
}



/// CountdownParts holds individual fields
class CountdownParts {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isFuture;

  CountdownParts({required this.years, required this.months, required this.days, required this.hours, required this.minutes, required this.seconds, required this.isFuture,});
}
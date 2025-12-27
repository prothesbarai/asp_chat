import 'package:flutter/material.dart';

Map<String, dynamic> sequentialAnniversaryHelper() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // >>> fixed anniversary days (sequential order)
  final List<Map<String, dynamic>> dates = [
    {"title": "Birthday 💖", "day": 15, "month": 1},
    {"title": "Anniversary 💖", "day": 23, "month": 1},
    {"title": "Kiss Day 💖", "day": 30, "month": 3},
    {"title": "Kiss Day 💖", "day": 31, "month": 3},
    {"title": "Anniversary ❤️", "day": 15, "month": 5},
    {"title": "Relationship ❤️", "day": 16, "month": 10},
    {"title": "Romance Day ❤️", "day": 23, "month": 10},
    {"title": "Anniversary 💕", "day": 20, "month": 11},
  ];
  const months = ["Jan","Feb","Mar","Apr","May","Jun", "Jul","Aug","Sep","Oct","Nov","Dec"];
  DateTime? nextDate;
  String title = "Upcoming Anniversary";
  IconData icon = Icons.calendar_month;
  bool isToday = false;
  for (var d in dates) {
    final candidate = DateTime(now.year, d["month"], d["day"]);
    // exact anniversary today
    if (candidate == today) {
      nextDate = candidate;
      title = d["title"];
      icon = Icons.favorite;
      isToday = true;
      break;
    }
    // next upcoming date
    if (candidate.isAfter(today)) {
      nextDate = candidate;
      break;
    }
  }
  // if all dates passed → next year first anniversary
  if (nextDate == null) {
    final d = dates.first;
    nextDate = DateTime(now.year + 1, d["month"], d["day"]);
  }
  String status = isToday ? "Happy $title" : "⏳ After ${nextDate.difference(today).inDays} days";
  return {
    "title": title,
    "icon": icon,
    "date": "${nextDate.day} ${months[nextDate.month - 1]}",
    "status": status,
    "isToday": isToday,
  };
}

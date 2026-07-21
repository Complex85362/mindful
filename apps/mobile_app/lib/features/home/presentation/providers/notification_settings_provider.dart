import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local-only notification preferences shown in Profile, persisted
/// on-device via SharedPreferences.
///
/// NOTE: this does not itself schedule any notifications -- wiring
/// flutter_local_notifications (or FCM) to actually fire a reminder at
/// [checkInTime] is a separate follow-up. These values are exactly what
/// such a scheduler would read.
class NotificationSettingsProvider extends ChangeNotifier {
  static const _checkInHourKey = 'notif_checkin_hour';
  static const _checkInMinuteKey = 'notif_checkin_minute';
  static const _moodAlertsKey = 'notif_mood_alerts_enabled';

  TimeOfDay _checkInTime = const TimeOfDay(hour: 20, minute: 0);
  bool _moodQuoteAlertsEnabled = true;
  bool _hasLoaded = false;

  TimeOfDay get checkInTime => _checkInTime;
  bool get moodQuoteAlertsEnabled => _moodQuoteAlertsEnabled;

  Future<void> load() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_checkInHourKey);
    final minute = prefs.getInt(_checkInMinuteKey);
    if (hour != null && minute != null) {
      _checkInTime = TimeOfDay(hour: hour, minute: minute);
    }
    _moodQuoteAlertsEnabled = prefs.getBool(_moodAlertsKey) ?? true;
    notifyListeners();
  }

  Future<void> setCheckInTime(TimeOfDay time) async {
    _checkInTime = time;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_checkInHourKey, time.hour);
    await prefs.setInt(_checkInMinuteKey, time.minute);
  }

  Future<void> setMoodQuoteAlertsEnabled(bool enabled) async {
    _moodQuoteAlertsEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_moodAlertsKey, enabled);
  }
}
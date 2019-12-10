import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// this class contains all the state used in the sample app
class CounterState with ChangeNotifier {
  //
  // default Constructor - ensures we load the latest saved-value from disk
  CounterState() {
    _load();
  }
  //
  // convenience, to avoid using this string-literal more than once
  static const _sharedPrefsKey = 'counterState';
  //
  // persistent state - i.e. what we will store and load across app runs
  int _value;
  //
  // read-only access to the state
  // - ensuring state is modified only via whatever methods
  //   we expose (in this case "increment" and "reset" only)
  int get value => _value;
  //
  // transient state - i.e. will not be stored when the app is not running
  //  internal-only readiness- & error-status
  bool _isWaiting = true;
  bool _hasError = false;
  //
  // read-only status indicators
  bool get isWaiting => _isWaiting;
  bool get hasError => _hasError;
  //
  // how we modify the state
  void increment() => _setValue(_value + 1);
  void reset() => _setValue(0);
  //
  void _setValue(int newValue) {
    _value = newValue;
    _save();
  }

  //
  void _load() => _store(load: true);
  void _save() => _store();
  //
  // helper to do the actual storage-related tasks
  //  handles both initial-load & save since they only differ by essentially 1 line
  //  - getInt vs setInt
  void _store({bool load = false}) async {
    _hasError = false;
    _isWaiting = true;
    notifyListeners();
    //
    // artificial delay so we can see the UI changes
    await Future.delayed(Duration(milliseconds: 500));
    //
    try {
      final prefs = await SharedPreferences.getInstance();
      if (load) {
        _value = prefs.getInt(_sharedPrefsKey) ?? 0;
      } else {
        // save
        // uncomment this to simulate an error during save
        if (_value > 3) throw Exception("Artificial Error");
        await prefs.setInt(_sharedPrefsKey, _value);
      }
      _hasError = false;
    } catch (error) {
      _hasError = true;
    }
    _isWaiting = false;
    notifyListeners();
  }
}

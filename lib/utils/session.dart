import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection_report/models/collector.dart';
import 'package:collection_report/utils/period.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Period _period;
late List<Collector> _collectors;
late SharedPreferences _preferences;

bool _isNext = false;

class Session {
  static Period get period {
    return _period;
  }

  static List<Collector> get collectors {
    return _collectors;
  }

  static SharedPreferences get preferences {
    return _preferences;
  }

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();

    final now = DateTime.now();
    var month = _preferences.getInt('month');
    var year = _preferences.getInt('year');

    if (month == null) {
      month = now.month;
      await _preferences.setInt('month', month);
    }

    if (year == null) {
      year = now.year;
      await _preferences.setInt('year', year);
    }

    _period = Period(month, year);

    _collectors = [];

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        FirebaseFirestore.instance.disableNetwork();
      } else {
        FirebaseFirestore.instance.enableNetwork();
      }
    });
  }

  static Future<void> load() async {
    final id = _period.asId();
    var data = await FirebaseFirestore.instance.collection(id).get();

    if (data.docs.isEmpty && _isNext) {
      // Import collectors from previous period

      _collectors = collectors
          .map((e) => Collector(e.id, e.clearCollections().toJson()))
          .toList();

      for (final collector in collectors) {
        FirebaseFirestore.instance
            .collection(id)
            .doc(collector.id)
            .set(collector.toJson());
      }
    } else {
      _collectors = data.docs.map((e) => Collector(e.id, e.data())).toList();
    }

    _isNext = false;
    _collectors.sort((a, b) => (a.position + 1) - (b.position + 1));
  }

  static void next() {
    _period.nextMonth();
    _isNext = true;
  }

  static void back() {
    _period.prevMonth();
  }
}

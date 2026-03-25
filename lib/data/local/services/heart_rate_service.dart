import 'package:elaros_mobile_app/data/local/model/heart_rate_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';
import 'package:sqflite/sqflite.dart';

class HeartRateService extends BaseHealthDataService<HeartRateModel> {
  static final String _tableName = 'HeartRate';
  static final String _timeColumn = 'timestamp';
  static final String _valueColumn = 'value';

  static final HeartRateService _instance = HeartRateService._internal();

  factory HeartRateService() => _instance;

  HeartRateService._internal({Database? database})
    : super(
        tableName: _tableName,
        timeColumn: _timeColumn,
        valueColumn: _valueColumn,
      );

  factory HeartRateService.forTest(Database db) {
    return HeartRateService._internal(database: db);
  }

  @override
  HeartRateModel fromRawMap(Map<String, dynamic> map) {
    return HeartRateModel.fromMap(map);
  }
}

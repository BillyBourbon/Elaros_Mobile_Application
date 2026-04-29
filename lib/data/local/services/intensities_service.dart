import 'package:elaros_mobile_app/data/local/model/intesities_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';
import 'package:sqflite/sqflite.dart';

class SleepService extends BaseHealthDataService<SleepModel> {
  static final String _tableName = 'Intensities';
  static final String _timeColumn = 'timestamp';
  static final String _valueColumn = 'intensity';

  static final SleepService _instance = SleepService._internal();

  factory SleepService() => _instance;

  SleepService._internal({Database? database})
    : super(
        tableName: _tableName,
        timeColumn: _timeColumn,
        valueColumn: _valueColumn,
      );

  factory SleepService.forTest(Database db) {
    return SleepService._internal(database: db);
  }

  @override
  SleepModel fromRawMap(Map<String, dynamic> map) {
    return SleepModel.fromMap(map);
  }
}

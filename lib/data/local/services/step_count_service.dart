import 'package:elaros_mobile_app/data/local/model/step_count_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';
import 'package:sqflite/sqflite.dart';

class StepCountService extends BaseHealthDataService<StepCountModel> {
  static final String _tableName = 'StepCount';
  static final String _timeColumn = 'timestamp';
  static final String _valueColumn = 'steps';

  static final StepCountService _instance = StepCountService._internal();

  factory StepCountService() => _instance;

  StepCountService._internal({Database? database})
    : super(
        tableName: _tableName,
        timeColumn: _timeColumn,
        valueColumn: _valueColumn,
      );

  factory StepCountService.forTest(Database db) {
    return StepCountService._internal(database: db);
  }

  @override
  StepCountModel fromRawMap(Map<String, dynamic> map) {
    return StepCountModel.fromMap(map);
  }
}

import 'package:elaros_mobile_app/data/local/model/calories_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';
import 'package:sqflite/sqflite.dart';

class CaloriesService extends BaseHealthDataService<CaloriesModel> {
  static final String _tableName = 'CaloriesConsumption';
  static final String _timeColumn = 'timestamp';
  static final String _valueColumn = 'calories';

  static final CaloriesService _instance = CaloriesService._internal();

  factory CaloriesService() => _instance;

  CaloriesService._internal({Database? database})
    : super(
        tableName: _tableName,
        timeColumn: _timeColumn,
        valueColumn: _valueColumn,
      );

  factory CaloriesService.forTest(Database db) {
    return CaloriesService._internal(database: db);
  }

  @override
  CaloriesModel fromRawMap(Map<String, dynamic> map) {
    return CaloriesModel.fromMap(map);
  }
}

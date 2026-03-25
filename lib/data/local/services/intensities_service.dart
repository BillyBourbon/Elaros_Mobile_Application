import 'package:elaros_mobile_app/data/local/model/intesities_model.dart';
import 'package:elaros_mobile_app/data/local/services/base_health_data_service.dart';
import 'package:sqflite/sqflite.dart';

class IntensitiesService extends BaseHealthDataService<IntensitiesModel> {
  static final String _tableName = 'Intensities';
  static final String _timeColumn = 'timestamp';
  static final String _valueColumn = 'intensities';

  static final IntensitiesService _instance = IntensitiesService._internal();

  factory IntensitiesService() => _instance;

  IntensitiesService._internal({Database? database})
    : super(
        tableName: _tableName,
        timeColumn: _timeColumn,
        valueColumn: _valueColumn,
      );

  factory IntensitiesService.forTest(Database db) {
    return IntensitiesService._internal(database: db);
  }

  @override
  IntensitiesModel fromRawMap(Map<String, dynamic> map) {
    return IntensitiesModel.fromMap(map);
  }
}

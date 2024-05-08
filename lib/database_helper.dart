// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'workout_details.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'workouts';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'workouts.db');
    return await openDatabase(databasePath, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, reps INTEGER, sets INTEGER, intensity INTEGER, date TEXT, weightInKg REAL, weightInLb REAL)',
      );
    });
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await database;
    return await db.insert(tableName, {
      'name': workout.name,
      'reps': workout.reps,
      'sets': workout.sets,
      'intensity': workout.intensity,
      'date': workout.date.toIso8601String(),
      'weightInKg': workout.weightInKg,
      'weightInLb': workout.weightInLb,
    });
  }

  Future<List<Workout>> getWorkouts(DateTime date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
    return List.generate(maps.length, (i) {
      return Workout(
        name: maps[i]['name'],
        reps: maps[i]['reps'],
        sets: maps[i]['sets'],
        intensity: maps[i]['intensity'],
        date: DateTime.parse(maps[i]['date']),
        weightInKg: maps[i]['weightInKg'],
        weightInLb: maps[i]['weightInLb'],
      );
    });
  }

  Future<void> updateWorkouts(DateTime date, List<Workout> workouts) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'date = ?',
      whereArgs: [date.toIso8601String()],
    );
    for (final workout in workouts) {
      await db.insert(tableName, {
        'name': workout.name,
        'reps': workout.reps,
        'sets': workout.sets,
        'intensity': workout.intensity,
        'date': date.toIso8601String(),
        'weightInKg': workout.weightInKg,
        'weightInLb': workout.weightInLb,
      });
    }
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Workout(
        name: maps[i]['name'],
        reps: maps[i]['reps'],
        sets: maps[i]['sets'],
        intensity: maps[i]['intensity'],
        date: DateTime.parse(maps[i]['date']),
        weightInKg: maps[i]['weightInKg'],
        weightInLb: maps[i]['weightInLb'],
      );
    });
  }
}

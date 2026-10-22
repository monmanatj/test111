// lib/providers/meal_provider.dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/meal.dart';

class MealProvider with ChangeNotifier {
  static const String _dbName = 'expenses.db';
  static const String _tableName = 'meal';
  Database? _database;
  List<Meal> _meals = [];

  MealProvider() {
    fetchAndSetMeals(); // โหลดข้อมูลเมื่อ Provider ถูกสร้าง
  }

  List<Meal> get meals => [..._meals];

  // กระบวนการที่ 2: การสร้างฐานข้อมูล
  Future<void> _initDatabase() async {
    if (_database != null) return;
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          print('Creating table $_tableName...');
          return db.execute(
          'CREATE TABLE $_tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'menu TEXT, '
            'mealType TEXT, '
            'calories INTEGER, '
            'eatenAt TEXT, '
            'isHomemade INTEGER)',
);
        },
      );
      print('Database initialized at $path');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // กระบวนการที่ 3: การ Insert
  Future<void> addMeal(
    String menu,
    MealType mealType,
    int calories,
    DateTime eatenAt,
    bool isHomemade,
  ) async {
    await _initDatabase(); // ตรวจสอบว่า DB พร้อมใช้งาน
    if (_database == null) return;

    final newMeal = Meal(
      menu: menu,
      mealType: mealType,
      calories: calories,
      eatenAt: eatenAt,
      isHomemade: isHomemade,
    );

    final id = await _database!.insert(_tableName, newMeal.toMap());
    print('Inserted transaction with id: $id');
    await fetchAndSetMeals();
  }

  // กระบวนการที่ 4: การ Read
  Future<void> fetchAndSetMeals() async {
    await _initDatabase();
    if (_database == null) return;

    final dataList = await _database!.query(_tableName, orderBy: 'eatenAt DESC');
    
    _meals = dataList.map((item) => Meal.fromMap(item)).toList();
    print('Fetched ${_meals.length} meals.');
    notifyListeners(); // แจ้ง UI ให้วาดใหม่
  }

  // กระบวนการที่ 5: การ Update
  Future<void> updateMeal(int id, Meal newMeal) async {
    await _initDatabase();
    if (_database == null) return;
    await _database!.update(
      _tableName,
      newMeal.toMap(), // toMap() ไม่ส่ง id ที่เป็น null จึงไม่ไปเปลี่ยนคีย์หลัก
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetMeals();
  }

  // กระบวนการที่ 6: การ Delete
  Future<void> deleteMeal(int id) async {
    await _initDatabase();
    if (_database == null) return;
    await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetMeals();
  }
}

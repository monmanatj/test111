// lib/models/meal.dart
enum MealType { main, breakfast, lunch, dinner }

class Meal {
  final int? id;
  final String menu;
  final MealType mealType;
  final int calories;
  final DateTime eatenAt;
  final bool isHomemade;

  Meal({
    this.id,
    required this.menu,
    required this.mealType,
    required this.calories,
    required this.eatenAt,
    required this.isHomemade,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ห้ามส่ง id ที่เป็น null เข้าไปใน UPDATE
      'menu': menu,
      'mealType': mealType.name,
      'calories': calories,
      'eatenAt': eatenAt.toIso8601String(),
      'isHomemade': isHomemade ? 1:0,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'] as int,
      menu: map['menu'] as String,
      mealType: MealType.values.byName(map['mealType'] as String),
      calories: map['calories'] as int,
      eatenAt: DateTime.parse(map['eatenAt'] as String),
      isHomemade: map['isHomemade'] as int == 1,
    );
  }
}

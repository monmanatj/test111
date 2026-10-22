//lib/screens/meal_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/meal_provider.dart';
import '../models/meal.dart';

class MealListScreen extends StatelessWidget {
  const MealListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการอาหาร')),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) =>
            mealProvider.meals.isEmpty
                ? const Center(child: Text('ไม่มีรายการ'))
                : ListView.builder(
                    itemCount: mealProvider.meals.length,
                    itemBuilder: (ctx, i) {
                      final meal = mealProvider.meals[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(meal.mealType == MealType.breakfast ? 'อาหารเช้า' :
                           meal.mealType == MealType.lunch ? 'อาหารกลางวัน' :
                            meal.mealType == MealType.dinner ? 'อาหารเย็น' :
                             'ของหวาน'),
                        ),
                        title: Text(meal.menu),
                        subtitle: Text(DateFormat.yMMMd().format(meal.eatenAt)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${meal.calories} แคลอรี่',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () {
                                // เรียกเมธอด delete
                                context.read<MealProvider>().deleteMeal(meal.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
      // ปุ่มเพิ่มรายการตัวอย่างชั่วคราว จนกว่าจะสร้างหน้าฟอร์มในการบ้าน
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<MealProvider>().addMeal(
              'ค่าอาหาร',
              MealType.breakfast,
              120,
              DateTime.now(),
              false,
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

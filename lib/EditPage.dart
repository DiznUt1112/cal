import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditPage({required this.data});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late String activity;
  late double weight;
  late double duration;
  late String name;
  double calculatedCalories = 0.0;

  late TextEditingController nameController;
  late TextEditingController weightController;
  late TextEditingController durationController;

  @override
  void initState() {
    super.initState();
    activity = widget.data['activity'];
    weight = (widget.data['weight'] as num).toDouble(); // แปลงเป็น double
    duration = (widget.data['duration'] as num).toDouble(); // แปลงเป็น double
    name = widget.data['name'];
    calculatedCalories = (widget.data['calories'] as num).toDouble(); // แปลงเป็น double

    // กำหนดค่าให้กับ controller แต่ละตัว
    nameController = TextEditingController(text: name);
    weightController = TextEditingController(text: weight.toString());
    durationController = TextEditingController(text: duration.toString());
  }

  @override
  void dispose() {
    // ทำการลบ controller เมื่อไม่ใช้งานแล้ว
    nameController.dispose();
    weightController.dispose();
    durationController.dispose();
    super.dispose();
  }

  double calculateCalories(String activity, double weight, double duration) {
    double calories = 0.0;
    switch (activity) {
      case 'วิ่ง':
        calories = (weight * duration * 0.0175 * 10);
        break;
      case 'ปั่นจักรยาน':
        calories = (weight * duration * 0.0175 * 8);
        break;
      case 'ยกน้ำหนัก':
        calories = (weight * duration * 0.0175 * 6);
        break;
      default:
        calories = 0;
    }
    return calories;
  }

  void updateCalories() {
    setState(() {
      calculatedCalories = calculateCalories(activity, weight, duration);
    });
  }

  Future<void> saveChanges() async {
    await DatabaseHelper().updateHistory(
      widget.data['key'],
      {
        'activity': activity,
        'weight': weight,
        'duration': duration,
        'calories': calculatedCalories,
        'name': name,
        'date': DateTime.now().toString(),
      },
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แก้ไขข้อมูล")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "ชื่อ"),
              onChanged: (value) {
                name = value;
              },
              controller: nameController,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: activity,
              items: ['วิ่ง', 'ปั่นจักรยาน', 'ยกน้ำหนัก'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  activity = value!;
                  updateCalories();
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "น้ำหนัก (kg)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                weight = double.tryParse(value) ?? 0.0;
                updateCalories();
              },
              controller: weightController,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "ระยะเวลา (นาที)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                duration = double.tryParse(value) ?? 0.0;
                updateCalories();
              },
              controller: durationController,
            ),
            SizedBox(height: 20),
            Text("แคลอรี่ที่เผาผลาญ: ${calculatedCalories.toStringAsFixed(2)} kcal"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text("บันทึกการเปลี่ยนแปลง"),
            ),
          ],
        ),
      ),
    );
  }
}

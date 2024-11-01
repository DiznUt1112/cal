import 'package:fitness_tracker1/history_page.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'GraphPage.dart'; // นำเข้า GraphPage
import 'package:fitness_tracker1/ProfilePage.dart';

class CalorieCalculator extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode; // เพิ่มตัวแปร isDarkMode

  CalorieCalculator({required this.onThemeToggle, required this.isDarkMode});

  @override
  _CalorieCalculatorState createState() => _CalorieCalculatorState();
}

class _CalorieCalculatorState extends State<CalorieCalculator> {
  String? selectedActivity;
  double weight = 0.0;
  double duration = 0.0;
  double resultCalories = 0.0;
  String name = "";
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    fetchHistoryData();
  }

  Future<void> fetchHistoryData() async {
    historyData = await DatabaseHelper().getHistory();
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('คำนวณแคลอรี่'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.grey[850], // ตั้งค่าพื้นหลังของการ์ด
          elevation: 5, // เพิ่มเงาให้การ์ด
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // มุมของการ์ด
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "ชื่อ",
                    labelStyle: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความ label เป็นสีขาว
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)), // เปลี่ยนสี border
                  ),
                  style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
                  onChanged: (value) {
                    name = value;
                  },
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  hint: Text("เลือกกิจกรรม", style: TextStyle(color: Colors.white)), // เปลี่ยนสีข้อความเป็นสีขาว
                  dropdownColor: Colors.grey[850], // เปลี่ยนสีพื้นหลังของ dropdown
                  value: selectedActivity,
                  items: ['วิ่ง', 'ปั่นจักรยาน', 'ยกน้ำหนัก'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)), // เปลี่ยนสีข้อความเป็นสีขาว
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedActivity = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "น้ำหนัก (kg)",
                    labelStyle: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความ label เป็นสีขาว
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)), // เปลี่ยนสี border
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
                  onChanged: (value) {
                    weight = double.tryParse(value) ?? 0.0;
                  },
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "ระยะเวลา (นาที)",
                    labelStyle: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความ label เป็นสีขาว
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)), // เปลี่ยนสี border
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความเป็นสีขาว
                  onChanged: (value) {
                    duration = double.tryParse(value) ?? 0.0;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      resultCalories = calculateCalories(selectedActivity ?? "", weight, duration);
                    });
                    await DatabaseHelper().insertHistory(
                      selectedActivity ?? "",
                      resultCalories,
                      name,
                      weight,
                      duration,
                    );
                    fetchHistoryData(); // อัพเดทข้อมูลประวัติหลังการบันทึก
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("บันทึกข้อมูลสำเร็จ")));
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 18), // เพิ่มขนาดตัวอักษรของปุ่ม
                  ),
                  child: Text("คำนวณแคลอรี่"),
                ),
                Text("แคลอรี่ที่เผาผลาญ: ${resultCalories.toStringAsFixed(2)} kcal", style: TextStyle(color: Colors.white)), // เปลี่ยนสีข้อความเป็นสีขาว
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GraphPage(historyData: historyData), // ส่งข้อมูล historyData ไปยัง GraphPage
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 18), // เพิ่มขนาดตัวอักษรของปุ่ม
                        ),
                        child: Text("แสดงกราฟ"),
                      ),
                    ),
                    SizedBox(width: 10), // เพิ่มระยะห่างเล็กน้อยระหว่างปุ่ม
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HistoryPage()), // นำทางไปยัง HistoryPage
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontSize: 18), // เพิ่มขนาดตัวอักษรของปุ่ม
                        ),
                        child: Text("ดูประวัติการออกกำลังกาย"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

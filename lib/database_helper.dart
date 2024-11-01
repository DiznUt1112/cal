import 'package:firebase_database/firebase_database.dart';

class DatabaseHelper {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child("history");

  Future<void> insertHistory(String activity, double calories, String name, double weight, double duration) async {
    await _databaseReference.push().set({
      'activity': activity,
      'calories': calories,
      'name': name,
      'weight': weight,
      'duration': duration,
      'date': DateTime.now().toString(),
    });
    print("บันทึกข้อมูลในประวัติสำเร็จ: $activity, $calories, $name, $weight, $duration");
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    DatabaseEvent event = await _databaseReference.once();
    List<Map<String, dynamic>> historyList = [];
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        var data = Map<String, dynamic>.from(value);
        data['key'] = key; // เพิ่ม key เพื่อใช้ในการอัปเดตและลบข้อมูล
        historyList.add(data);
      });
      print("ข้อมูลที่ดึงมา: $historyList");
    } else {
      print("ไม่มีข้อมูลในฐานข้อมูล");
    }
    return historyList;
  }

  Future<void> deleteHistory(String key) async {
    await _databaseReference.child(key).remove();
    print("ลบข้อมูลสำเร็จ: $key");
  }

  Future<void> updateHistory(String key, Map<String, dynamic> newData) async {
    await _databaseReference.child(key).update(newData);
    print("อัปเดตข้อมูลสำเร็จ: $key");
  }
}

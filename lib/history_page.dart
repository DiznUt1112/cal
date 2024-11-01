import 'package:fitness_tracker1/EditPage.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart'; // นำเข้า intl

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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

  Future<void> deleteData(String key) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณต้องการลบข้อมูลนี้หรือไม่?"),
          actions: [
            TextButton(
              child: Text("ยกเลิก"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm) {
      await DatabaseHelper().deleteHistory(key);
      fetchHistoryData();
    }
  }

  Future<void> editData(Map<String, dynamic> data) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการแก้ไข"),
          content: Text("คุณต้องการแก้ไขข้อมูลนี้หรือไม่?"),
          actions: [
            TextButton(
              child: Text("ยกเลิก"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm) {
      bool? result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditPage(data: data)),
      );
      if (result == true) {
        fetchHistoryData(); // รีเฟรชข้อมูลหลังการแก้ไข
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ประวัติการออกกำลังกาย",
          style: TextStyle(color: Colors.white), // เปลี่ยนสีข้อความใน AppBar เป็นสีขาว
        ),
        backgroundColor: Colors.black, // สีของ AppBar
      ),
      body: Column( // ใช้ Column เพื่อวางข้อความและ ListView
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "เลื่อนขวาเพื่อลบ, เลื่อนซ้ายเพื่อแก้ไข",
              style: TextStyle(fontSize: 16, color: Colors.black), // เปลี่ยนสีข้อความเป็นสีดำ
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                final data = historyData[index];
                return Dismissible(
                  key: Key(data['date'].toString()), // ใช้ `date` เป็น key (ตรวจสอบว่า 'date' มีอยู่จริง)
                  background: Container(
                    color: Colors.grey[700], // สีของ Background สำหรับการแก้ไข
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await editData(data);
                      return false;
                    } else {
                      await deleteData(data['key']); // ตรวจสอบว่า `key` มีอยู่จริง
                      return true;
                    }
                  },
                  child: Card(
                    elevation: 5, // เพิ่มเงาให้การ์ด
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // มุมของการ์ด
                    ),
                    color: Colors.white, // เปลี่ยนสีพื้นหลังของการ์ดเป็นสีขาว
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ชื่อ: ${data['name'] ?? 'ไม่ระบุ'}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // สีของข้อความ
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "กิจกรรม: ${data['activity']}",
                            style: TextStyle(fontSize: 16, color: Colors.black), // สีของข้อความ
                          ),
                          SizedBox(height: 4),
                          Text(
                            "แคลอรี่ที่เผาผลาญ: ${data['calories'].toStringAsFixed(0)} kcal",
                            style: TextStyle(fontSize: 16, color: Colors.black), // สีของข้อความ
                          ),
                          SizedBox(height: 4),
                          Text(
                            "ระยะเวลา: ${data['duration']} นาที",
                            style: TextStyle(fontSize: 16, color: Colors.black), // สีของข้อความ
                          ),
                          SizedBox(height: 4),
                          Text(
                            "น้ำหนัก: ${data['weight']} kg",
                            style: TextStyle(fontSize: 16, color: Colors.black), // สีของข้อความ
                          ),
                          SizedBox(height: 4),
                          Text(
                            "วันที่: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(data['date']))}",
                            style: TextStyle(fontSize: 16, color: Colors.black), // สีของข้อความ
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

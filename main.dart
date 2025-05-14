import 'package:flutter/material.dart';
import 'delivery_method.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFFFEDE3), // สีพื้นหลังหลัก
        primaryColor: const Color(0xFFFC4D20),           // สีปุ่มและ Highlight
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF48261D),           // สี AppBar
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF48261D), fontSize: 16), // เปลี่ยน bodyText1 เป็น bodyLarge
          bodySmall: TextStyle(color: Color(0xFF48261D), fontSize: 14),
        ),
      ),
      home: const DeliveryMethodScreen(), // ตรวจสอบว่า DeliveryMethodScreen ถูกสร้างไว้อย่างถูกต้อง
    );
  }
}

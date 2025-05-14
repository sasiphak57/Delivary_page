import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'screens/delivery_address.dart';

class DeliveryMethodScreen extends StatefulWidget {
  const DeliveryMethodScreen({super.key});

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  int _selectedMethod = 0; // 0: Pickup, 1: Delivery
  String _pickupOption = 'schedule';

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedAddress;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _goToDeliveryAddressScreen() async {
    final selectedAddress = await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DeliveryAddressScreen(),
      ),
    );

    if (!mounted) return;

    if (selectedAddress != null && selectedAddress is String) {
      setState(() {
        _selectedAddress = selectedAddress;
      });
    } else {
      setState(() {
        _selectedMethod = 0; // Revert to Pick up
      });
    }
  }

  void _handleNext() {
    if (_selectedMethod == 0) {
      if (_pickupOption == 'schedule') {
        if (_selectedDate == null || _selectedTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select date and time.')),
          );
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pickup $_pickupOption confirmed.')),
      );
    } else {
      if (_selectedAddress != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delivery to $_selectedAddress confirmed.')),
        );
      } else {
        _goToDeliveryAddressScreen();
      }
    }
  }

  Widget buildHeader() {
    return SizedBox(
        child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 🔶 พื้นหลัง
          Positioned(
            top: 0, // ล้นออกมาได้เหมือน absolute
            child: Container(
              height: 250,
              width: 1000,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(224, 184, 149, 1),
              ),
            ),
          ),
          Container(
            height: 137,
            decoration: const BoxDecoration(
              color: Color(0xFF5D2B1A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),

          // 🔙 Back + Title (จัด Row ปกติ)
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: const [
                Icon(Icons.arrow_back, color: Colors.orangeAccent, size: 24),
                SizedBox(width: 12),
                Text(
                  "Delivery Method",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 237, 227, 1),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -28,
            right: -40,
            child: Image.asset(
              'assets/smoke.png',
              height: 200,
            ),
          ),
          Positioned(
            top: 100,
            left: 40,
            right: 40,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFCCE6F0), // พื้นหลังฟ้าอ่อน
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  // 🔶 Pick up
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMethod = 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedMethod == 0 ? const Color(0xFFFC4D20) : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Pick up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: _selectedMethod == 0
                                ? Colors.white
                                : const Color(0xFFFC4D20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🔶 Delivery
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        setState(() => _selectedMethod = 1);
                        await Future.delayed(const Duration(milliseconds: 0));
                        _goToDeliveryAddressScreen();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedMethod == 1 ? const Color(0xFFFC4D20) : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: _selectedMethod == 1
                                ? Colors.white
                                : const Color(0xFFFC4D20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF48261D),
      body: Column(
        children: [
          buildHeader(),
          const SizedBox(height: 60),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFF5EF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedMethod == 0) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Radio<String>(
                        value: 'schedule',
                        groupValue: _pickupOption,
                        activeColor: Color(0xFFFC4D20),
                        onChanged: (value) => setState(() => _pickupOption = value!),
                      ),
                      title: const Text(
                        'Schedule pick up',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF48261D)),
                      ),
                    ),
                    if (_pickupOption == 'schedule') ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'DD/MM/YY',
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF48261D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDate = date;
                              _dateController.text = DateFormat('dd/MM/yy').format(date);
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: '00:00 A.M.',
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(Icons.access_time, color: Color(0xFF48261D)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime ?? TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _selectedTime = time;
                              final now = DateTime.now();
                              final fullTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                              _timeController.text = DateFormat('hh:mm a').format(fullTime);
                            });
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Radio<String>(
                        value: 'now',
                        groupValue: _pickupOption,
                        activeColor: Color(0xFFFC4D20),
                        onChanged: (value) => setState(() => _pickupOption = value!),
                      ),
                      title: const Text(
                        'Pickup now',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF48261D), fontSize: 30),
                      ),
                      subtitle: const Text(
                        'Your order will be ready in 5-7 minute.',
                        style: TextStyle(color: Color(0xFF48261D), fontSize: 15),
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFC4D20),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shadowColor: Colors.black45,
                        elevation: 5,
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

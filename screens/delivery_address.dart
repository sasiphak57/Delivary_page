import 'package:flutter/material.dart';
import 'edit_address.dart';
import 'new_address.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  int _selectedMethod = 1;
  int _selectedIndex = 0;

  List<String> addresses = [
    'miss\nxxxxxxxxxxxxxxxxxxxxxxxxxx\nxxxxxxxxxxxxxxxxxxxxxxxxxx',
    'miss\nxxxxxxxxxxxxxxxxxxxxxxxxxx\nxxxxxxxxxxxxxxxxxxxxxxxxxx',
    'miss\nxxxxxxxxxxxxxxxxxxxxxxxxxx\nxxxxxxxxxxxxxxxxxxxxxxxxxx',
  ];

  void _navigateToNewAddress() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewAddressScreen()),
    );
    if (newAddress != null && newAddress is String) {
      setState(() {
        addresses.add(newAddress);
        _selectedIndex = addresses.length - 1;
      });
    }
  }

  void _navigateToEditAddress(int index) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddressScreen(initialAddress: addresses[index]),
      ),
    );
    if (edited != null && edited is String) {
      setState(() {
        addresses[index] = edited;
      });
    }
  }

  void _deleteAddress(int index) {
    setState(() {
      addresses.removeAt(index);
      if (_selectedIndex >= addresses.length) {
        _selectedIndex = addresses.isNotEmpty ? addresses.length - 1 : 0;
      }
    });
  }

  void _handleNext() {
    if (addresses.isNotEmpty) {
      Navigator.pop(context, addresses[_selectedIndex]);
    }
  }

  Widget buildHeader() {
    return Stack(
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
                    onTap: () {
                      setState(() => _selectedMethod = 0);
                      Navigator.pop(context, null);
                    },
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
                    onTap: () => setState(() => _selectedMethod = 1),
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
    );
  }

  Widget _buildAddressTile(int index) {
    final isSelected = index == _selectedIndex;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFC4D20) : const Color(0xFFFDF3EB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFC4D20), width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<int>(
              value: index,
              groupValue: _selectedIndex,
              activeColor: isSelected ? Colors.white : const Color(0xFFFC4D20),
              onChanged: (value) => setState(() => _selectedIndex = value!),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                addresses[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF48261D),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: isSelected ? Colors.white : const Color(0xFF48261D)),
              onPressed: () => _navigateToEditAddress(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: isSelected ? Colors.white : const Color(0xFF48261D)),
              onPressed: () => _deleteAddress(index),
            ),
          ],
        ),
      ),
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
                color: Color(0xFFFDF3EB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose your Delivery Address',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF48261D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _navigateToNewAddress,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF48261D), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Color(0xFF48261D)),
                            SizedBox(width: 8),
                            Text(
                              'New Address',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF48261D),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (addresses.isEmpty)
                    const Center(
                      child: Text(
                        'No saved addresses yet.',
                        style: TextStyle(color: Color(0xFF48261D)),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: addresses.length,
                        itemBuilder: (context, index) => _buildAddressTile(index),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addresses.isNotEmpty ? _handleNext : null,
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
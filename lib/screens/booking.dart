import 'package:booking_application/providers/theme_providers.dart';
import 'package:booking_application/widget/title.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/widget/text_field_widget.dart';
import 'package:booking_application/widget/button_widget.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController bandController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final String harga = "150.000";

  String? selectedDate;
  String? selectedTime;
  String? selectedPayment;
  String? selectedEquipment;

  List<String> equipments = ['Stick Drum', 'Pick', 'Microphone'];
  List<String> times = ["09.00 - 10.00", "10.00 - 11.00"];
  List<String> payments = ["E-Wallet", "Bayar di tempat"];

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.getIsDarkTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TitlesTextWidget(
            label: "Booking", color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFieldWidget(
              //   controller: bandController,
              //   hintText: "Masukkan Nama Band",
              //   icon: Icons.music_note,
              // ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    border: Border.all(color: isDarkMode ? Colors.white24 : Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate ?? "Pilih Tanggal",
                        style: TextStyle(
                          color: selectedDate == null
                              ? (isDarkMode ? Colors.white54 : Colors.grey)
                              : (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      Icon(Icons.calendar_today, color: isDarkMode ? Colors.white : Colors.black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedTime,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Pilih Waktu",
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                items: times.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedTime = value),
                dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              ),
              const SizedBox(height: 16),
              const Text("Perlengkapan Tambahan:"),
              Column(
                children: equipments.map((String equipment) {
                  return RadioListTile<String>(
                    title: Text(
                      equipment,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    value: equipment,
                    groupValue: selectedEquipment,
                    onChanged: (value) => setState(() => selectedEquipment = value),
                    activeColor: Colors.purple,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                controller: whatsappController,
                hintText: "WhatsApp",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPayment,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Pilih Pembayaran",
                  labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                items: payments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedPayment = value),
                dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitlesTextWidget(label: harga,
              ),
            SizedBox(
              width: 100,
              child: CustomButton(
                onPressed: () {},
                text: "Bayar",
                backgroundColor: primaryColor ,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

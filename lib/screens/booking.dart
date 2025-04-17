import 'package:booking_application/root_screens.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/auth/booking_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController bandController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  int harga = 0;
  int perJam = 0;
  int get totalHarga => harga * selectedTimes.length;

  String? pilihTanggal;
  List<String> selectedTimes = [];
  String? pilihPembayaran;

  List<String> pilihWaktu = [];
  List<String> pembayaran = ['E-Wallet', 'Bayar ditempat'];

  List<String> pilihanWaktu = [];

  String formatTime(DateTime time) {
    return time.hour.toString().padLeft(2, '0') + ":" +
        time.minute.toString().padLeft(2, '0');
  }

  void generateAvailableTimes(DateTime start, DateTime end) {
    List<String> times = [];

    DateTime current = start;
    while (current.isBefore(end)) {
      final next = current.add(Duration(hours: 1));
      final timeRange = "${formatTime(current)} - ${formatTime(next)}";
      times.add(timeRange);
      current = next;
    }

    setState(() {
      pilihWaktu = times;
    });
  }


  @override
  void initState() {
    super.initState();
    fetchBookingHarga();
    fetchJamBukaTutup();
  }

  Future<void> fetchBookingHarga() async {
    final data = await getBookingsData();
    setState(() {
      harga = data['harga'];
    });
  }

  Future<void> fetchJamBukaTutup() async {
    final response = await supabase
        .from('settings')
        .select('jamBuka, jamTutup')
        .single();

    final now = DateTime.now();
    final dateString = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final jamBuka = DateTime.parse('$dateString ${response['jamBuka']}');
    final jamTutup = DateTime.parse('$dateString ${response['jamTutup']}');

    generateAvailableTimes(jamBuka, jamTutup);
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        pilihTanggal = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> RootScreen()), (route)=> false);
            },
          ),
          title: SubtitleTextWidget(label: "Booking", color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubtitleTextWidget(
                          label: pilihTanggal ?? "Pilih Tanggal",
                          color: pilihTanggal == null
                              ? (Colors.grey)
                              : (Colors.black),
                        ),
                        Icon(Icons.calendar_today, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SubtitleTextWidget(label: "Pilih Waktu:"),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  children: pilihWaktu.map((time) {
                    final isSelected = selectedTimes.contains(time);
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ChoiceChip(
                        label: Text(time),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            if (isSelected) {
                              selectedTimes.remove(time);
                            } else {
                              selectedTimes.add(time);
                            }
                          });
                        },
                        selectedColor: primaryColor,
                        backgroundColor: Colors.grey[200],
                        padding: EdgeInsets.symmetric(horizontal: 0.4, vertical: 0.4),
                        labelStyle: TextStyle(
                          fontSize: 12.5,
                          color: isSelected
                              ? Colors.white
                              : ( Colors.black),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SubtitleTextWidget(label: 'Masukan Nomor:'),
                SizedBox(height: 5),
                TextField(
                  controller: whatsappController,
                  decoration: const InputDecoration(
                    label: SubtitleTextWidget(label: "WhatsApp"),
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                SubtitleTextWidget(label: 'Metode Pembayaran :'),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: pilihPembayaran,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Pilih Pembayaran",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  items: pembayaran.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle( color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => pilihPembayaran = value),
                  dropdownColor: Colors.grey[800],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SubtitleTextWidget(label: "Rp. ${totalHarga.toString()}"),
            SizedBox(
              width: 110,
              height: 43,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Bayar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


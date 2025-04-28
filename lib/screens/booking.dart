import 'package:booking_application/auth/settings_services.dart';
import 'package:booking_application/root_screens.dart';
import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:booking_application/auth/booking_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController whatsappController = TextEditingController();
  int harga = 0;
  int get totalHarga => harga * selectedTimes.length;
  String? urlWA;

  String? pilihTanggal;
  List<String> selectedTimes = [];
  String? pilihPembayaran;

  List<String> pilihWaktu = [];
  List<String> pembayaran = ['E-Wallet', ' Cash'];

  List<String> pilihanWaktu = [];
  Set<String> waktuYangSudahDibooking = {};


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
    final now = DateTime.now();
    pilihTanggal = DateFormat('yyyy-MM-dd').format(now);
    fetchBookingHarga();
    fetchJamBukaTutup();
    nomorUser();
    getUrl();

    fetchWaktuSudahDibooking(pilihTanggal!);
  }
  Future<void> fetchWaktuSudahDibooking(String tanggal) async {
    final response = await supabase
        .from('bookings')
        .select('waktu')
        .eq('tanggal_booking', tanggal)
        .inFilter('status', ['pending', 'confirmed']);

    final List<dynamic> hasil = response;
    final Set<String> waktuTerpakai = {};
    for (var item in hasil) {
      final waktu = item['waktu'] as String;
      waktuTerpakai.addAll(waktu.split(',').map((w) => w.trim()));
    }

    if (!mounted) return;
    setState(() {
      waktuYangSudahDibooking = waktuTerpakai;
    });
  }


  Future<void> nomorUser() async {
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        final response = await supabase
            .from('users')
            .select('telepon')
            .eq('id', user.id)
            .single();
        if (!mounted) return;
        whatsappController.text = response['telepon'];
      } catch (e) {
        print("Error saat mengambil nomor telepon: $e");
      }
    }
  }
  Future<void> fetchBookingHarga() async {
    final data = await getBookingsData();
    if (!mounted) return;
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

    if (!mounted) return;
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
      final tanggal = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        pilihTanggal = tanggal;
      });
      await fetchWaktuSudahDibooking(tanggal);
    }
  }


  Future<void> submitBooking() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kamu belum login.")),
      );
      return;
    }
    if (pilihTanggal == null ||
        selectedTimes.isEmpty ||
        pilihPembayaran == null ||
        whatsappController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap lengkapi semua data booking.")),
      );
      return;
    }

    try {
      await supabase.from('bookings').insert({
        'user_id': user.id,
        'tanggal_booking': pilihTanggal,
        'waktu': selectedTimes.join(', '),
        'total_harga': totalHarga,
        'no_wa': whatsappController.text,
        'metode': pilihPembayaran,
        'status': 'pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: SubtitleTextWidget(label: "Booking Berhasil!")),
      );

      setState(() {
        pilihTanggal = null;
        selectedTimes.clear();
        whatsappController.clear();
        pilihPembayaran = null;
      });

    } catch (e) {
      print("Error saat simpan booking: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan booking.")),
      );
    }
  }

  Future<void> showConfirmationDialog() async {
    if (pilihTanggal == null || selectedTimes.isEmpty || pilihPembayaran == null || whatsappController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap lengkapi semua data booking.")),
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: SubtitleTextWidget(label: "Konfirmasi Booking"),
        content: SubtitleTextWidget(label: "Setelah melakukan booking, anda tidak dapat membatalkannya. Jika ingin membatalkan, hubungi admin. Lanjutkan booking?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: SubtitleTextWidget(label: "Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: SubtitleTextWidget(label: "Oke"),
          ),
        ],
      ),
    );

    if (result == true) {
      await submitBooking();
      await _launchWhatsApp();
    }
  }

  Future<void> _launchWhatsApp() async {
    if (urlWA == null) {
      throw Exception("WhatsApp URL tidak ditemukan");
    }

    final Uri url = Uri.parse(urlWA!);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Gagal membuka WhatsApp");
    }
  }


  Future<void> getUrl() async {
    final wa = await getSettingValue('whatsApp');
    if (!mounted) return;
    setState(() {
      urlWA = wa;
    });
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
                pilihTanggal == null
                    ? Center(
                  child: SubtitleTextWidget(
                    label: pilihTanggal ?? "",
                    color: pilihTanggal == null ? Colors.grey : Colors.black,
                  ),
                )
                    : GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  children: pilihWaktu.map((time) {
                    final isSelected = selectedTimes.contains(time);
                    final isBooked = waktuYangSudahDibooking.contains(time);
                    final parts = time.split(" - ");
                    final timeStart = parts[0];
                    final timeStartParts = timeStart.split(":");
                    final hour = int.parse(timeStartParts[0]);
                    final minute = int.parse(timeStartParts[1]);

                    final selectedDate = DateFormat('yyyy-MM-dd').parse(pilihTanggal!);
                    final timeDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      hour,
                      minute,
                    );
                    final isPast = timeDateTime.isBefore(DateTime.now());
                    final isDisabled = isBooked || isPast;
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ChoiceChip(
                        label: Text(time),
                        selected: isSelected,
                        onSelected: isDisabled
                            ? null
                            : (_) {
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
                          color: isDisabled
                              ? Colors.grey
                              : (isSelected ? Colors.white : Colors.black),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SubtitleTextWidget(label: 'Masukan Nomor WhatsApp:'),
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
                  dropdownColor: Colors.white,
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
                onPressed: showConfirmationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: SubtitleTextWidget(label: "Bayar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


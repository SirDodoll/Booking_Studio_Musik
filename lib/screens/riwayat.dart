import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widget/subtitle_text.dart';

class RiwayatBookingScreen extends StatefulWidget {
  const RiwayatBookingScreen({super.key});

  @override
  State<RiwayatBookingScreen> createState() => _RiwayatBookingScreenState();
}

class _RiwayatBookingScreenState extends State<RiwayatBookingScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allRiwayat = [];
  List<Map<String, dynamic>> currentRiwayat = [];

  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  int page = 0;
  final int limit = 5;

  String selectedStatus = 'all';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  void updateCurrentPage() {
    if (!mounted) return;

    final start = page * limit;
    final end = start + limit;
    setState(() {
      currentRiwayat = allRiwayat.sublist(
        start,
        end > allRiwayat.length ? allRiwayat.length : end,
      );
    });
  }

  Future<void> fetchRiwayat() async {
    final user = supabase.auth.currentUser;
    if (!mounted) return;
    if (user == null) return;

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var query = supabase
          .from('bookings')
          .select('*, users(*)')
          .eq('user_id', user.id)
          .gte('tanggal_booking', startDate.toIso8601String())
          .lte('tanggal_booking', endDate.toIso8601String());

      if (selectedStatus != 'all') {
        query = query.eq('status', selectedStatus);
      }

      final response = await query.order('tanggal_booking', ascending: false);

      if (!mounted) return;

      if (response != null) {
        final data = List<Map<String, dynamic>>.from(response as List);
        if (mounted) {
          setState(() {
            allRiwayat = data;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            allRiwayat = [];
          });
        }
      }

      if (mounted) {
        setState(() {
          page = 0;
        });
        updateCurrentPage();
      }
    } catch (error) {
      print('Error fetching booking history: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildFilterDropdown() {
    final filters = {
      'all': 'Semua',
      'confirmed': 'Selesai',
      'canceled': 'Dibatalkan',
      'pending': 'Proses',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStatus,
          items: filters.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null && mounted) {
              setState(() {
                selectedStatus = value;
              });
              fetchRiwayat();
            }
          },
          icon: const Icon(Icons.arrow_drop_down),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, double fontSize, double titleFontSize) {
    final user = booking['users'] ?? {};
    final nama = user['name'] ?? 'Nama tidak diketahui';

    String statusText = 'Proses';
    final status = booking['status'];

    if (status == 'confirmed') {
      statusText = 'Selesai';
    } else if (status == 'canceled') {
      statusText = 'Dibatalkan';
    }

    Icon statusIcon;
    if (status == 'confirmed') {
      statusIcon = Icon(Icons.check_circle, color: Colors.green, size: titleFontSize + 4);
    } else if (status == 'canceled') {
      statusIcon = Icon(Icons.cancel, color: Colors.red, size: titleFontSize + 4);
    } else {
      statusIcon = Icon(Icons.access_time, color: Colors.orange, size: titleFontSize + 4);
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SubtitleTextWidget(
                    label: nama,
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                ),
                statusIcon,
              ],
            ),
            const SizedBox(height: 8),
            SubtitleTextWidget(
              label: "Tanggal: ${booking['tanggal_booking']}",
              fontSize: fontSize,
            ),
            const SizedBox(height: 3),
            SubtitleTextWidget(
              label: "Waktu: ${booking['waktu']}",
              fontSize: fontSize,
            ),
            const SizedBox(height: 3),
            SubtitleTextWidget(
              label: "Metode Pembayaran: ${booking['metode']}",
              fontSize: fontSize,
            ),
            const SizedBox(height: 8),
            SubtitleTextWidget(
              label: "Status: $statusText",
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: status == 'confirmed'
                  ? Colors.green
                  : status == 'canceled'
                  ? Colors.red
                  : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: primaryColor,
          title: const SubtitleTextWidget(
            label: "Riwayat Booking",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 600;
            final padding = isSmallScreen ? 12.0 : 24.0;
            final fontSize = isSmallScreen ? 16.0 : 20.0;
            final titleFontSize = isSmallScreen ? 22.0 : 28.0;

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2022),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            initialDateRange: DateTimeRange(start: startDate, end: endDate),
                          );

                          if (picked != null && mounted) {
                            setState(() {
                              startDate = picked.start;
                              endDate = picked.end;
                            });
                            fetchRiwayat();
                          }
                        },
                        icon: const Icon(Icons.date_range, color: Colors.black,),
                        label: SubtitleTextWidget(label: "Filter", color: Colors.black,),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor.withOpacity(0.8),
                        ),
                      ),
                      buildFilterDropdown(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : currentRiwayat.isEmpty
                        ? Center(
                      child: SubtitleTextWidget(
                        label: 'Belum ada riwayat booking',
                        fontSize: fontSize,
                      ),
                    )
                        : ListView.builder(
                      itemCount: currentRiwayat.length,
                      itemBuilder: (context, index) =>
                          _buildBookingCard(currentRiwayat[index], fontSize, titleFontSize),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: page > 0
                            ? () {
                          if (mounted) {
                            setState(() => page--);
                            updateCurrentPage();
                          }
                        }
                            : null,
                        child: SubtitleTextWidget(label: 'Sebelumnya'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: ((page + 1) * limit < allRiwayat.length)
                            ? () {
                          if (mounted) {
                            setState(() => page++);
                            updateCurrentPage();
                          }
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: SubtitleTextWidget(label: "Selanjutnya"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
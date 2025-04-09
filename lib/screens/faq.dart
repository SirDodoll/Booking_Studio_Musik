import 'package:booking_application/widget/subtitle_text.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final List<Map<String, dynamic>> faqList = [
      {
        'tanya': 'Apa itu ID MUSIC?',
        'jawab':
        'ID MUSIC merupakan aplikasi yang digunakan untuk melakukan pemesanan studio musik secara online di ID MUSIC STUDIO. Aplikasi ini dapat memudahkan pengguna dalam melihat ketersediaan jadwal serta dapat melakukan pemesanan dengan lebih cepat dan efisien.',
      },
      {
        'tanya': 'Bagaimana cara menemukan lokasi ID MUSIC STUDIO?',
        'jawab':
        'Anda dapat menemukan lokasi ID MUSIC STUDIO dengan mudah melalui tombol "Lokasi" yang terletak di pojok kanan atas halaman beranda, atau dengan mengklik kartu lokasi yang tersedia di halaman tersebut.',
      },
      {
        'tanya': 'Bagaimana cara melakukan booking studio?',
        'jawab': [
          'Masuk ke halaman Booking',
          'Pilih tanggal dan waktu',
          'Pilih perlengkapan tambahan (opsional)',
          'Masukan nomor WhatsApp',
          'Klik tombol "Bayar", kemudian akan diarahkan ke aplikasi WhatsApp',
        ],
      },
      {
        'tanya': 'Apakah bisa membatalkan booking?',
        'jawab':
        'Pembatalan dapat dilakukan dengan cara menghubungi admin melalui WhatsApp yang tersedia di halaman beranda.',
      },
      {
        'tanya': 'Apa saja alat musik yang tersedia?',
        'jawab': 'ID MUSIC menyediakan drum, gitar, bass, keyboard, mikrofon.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const SubtitleTextWidget(
          label: "FAQ",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: faqList.length,
            itemBuilder: (context, index) {
              final item = faqList[index];
              final jawaban = item['jawab'];

              return Card(
                margin: const EdgeInsets.only(bottom: 23),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: SubtitleTextWidget(
                    label: item['tanya'] ?? '',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0
                      ),
                      child: jawaban is List
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: jawaban
                            .asMap()
                            .entries
                            .map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SubtitleTextWidget(
                            label: '${entry.key + 1}. ${entry.value}',
                                fontSize: 16,
                          ),
                        ))
                            .toList(),
                      )
                          : SubtitleTextWidget(
                        label: jawaban ?? '',
                        fontSize: 16,
                        textAlign: TextAlign.justify,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

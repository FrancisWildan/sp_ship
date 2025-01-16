// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PreviewPage extends StatefulWidget {
  final String tanggalSurat;
  final String nomorSurat;
  final String bulanSurat;
  final String tahunSurat;

  final String nomorKapal;
  final String grossTonnage;
  final String tanggalTiba;
  final String rencanaBongkar;
  final String jetty;

  const PreviewPage({
    required this.tanggalSurat,
    required this.nomorSurat,
    required this.bulanSurat,
    required this.tahunSurat,
    required this.nomorKapal,
    required this.grossTonnage,
    required this.tanggalTiba,
    required this.rencanaBongkar,
    required this.jetty,
    super.key,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  String pdfPath = '';
  bool isLoading = true;
  String b3PdfPath = '';
  String stsPdfPath = '';
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    requestPermissions().then((_) {
      generatePdfs().then((paths) {
        setState(() {
          b3PdfPath = paths[0];
          if (paths.length > 1) {
            stsPdfPath = paths[1];
          }
          isLoading = false;
        });
        // Show a snackbar with the file paths
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDFs saved at:\n${paths.join('\n')}'),
          ),
        );
      });
    });
  }

  Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // The permission is granted, proceed with your file operations
    } else {
      // The permission is denied, handle accordingly
    }
  }

  Future<pw.Document> generateB3PDF() async {
    final pdf = pw.Document();
    final calibriFont =
        pw.Font.ttf(await rootBundle.load('assets/CALIBRI.TTF'));
    final calibriBoldItalicFont =
        pw.Font.ttf(await rootBundle.load('assets/CALIBRIZ.TTF'));
    final calibriBoldFont =
        pw.Font.ttf(await rootBundle.load('assets/CALIBRIB.TTF'));

    final tahomaFont = pw.Font.ttf(await rootBundle.load('assets/TAHOMA.TTF'));
    // Load images
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    );
    final ttdImage = pw.MemoryImage(
      (await rootBundle.load('assets/ttd.png')).buffer.asUint8List(),
    );
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.only(
          left: 72, // 2.54 cm
          right: 72, // 2.54 cm
          top: 20, // 15 points
          bottom: 20, // 15 points
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Kop Surat
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(width: 15),

                pw.Image(logoImage,
                    width: 70, height: 70), // Tempatkan logo di sini

                pw.SizedBox(width: 3),
                // Teks di tengah
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'PT MITRA BAHARI SEJATI',
                        style: pw.TextStyle(
                          font: calibriBoldFont,
                          fontSize: 25,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                      pw.Text(
                        'Shipping Agency',
                        style: pw.TextStyle(
                            font: calibriBoldItalicFont,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#0A1F44'),
                            fontStyle: pw.FontStyle.italic),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Komp. BDS II Blok U No. 10 E RT.34 Kelurahan Sungainangka Kecamatan Balikpapan Selatan',
                        style: pw.TextStyle(font: calibriFont, fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Kalimantan Timur 75127',
                        style: pw.TextStyle(font: calibriFont, fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 2),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'Telepon. (0542) 8211308 ',
                            style: pw.TextStyle(
                              font: calibriFont,
                              fontSize: 9,
                              // color: PdfColors.blue,
                            ),
                          ),
                          pw.SizedBox(width: 2),
                          pw.Text(
                            'email: ',
                            style: pw.TextStyle(
                              font: calibriFont,
                              fontSize: 9,
                            ),
                          ),
                          pw.UrlLink(
                            destination: 'mailto:mbs.bppn05@gmail.com',
                            child: pw.Text(
                              'mbs.bppn05@gmail.com',
                              style: pw.TextStyle(
                                font: calibriFont,
                                fontSize: 9,
                                color: PdfColors.blue,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 2),
                          pw.Text(
                            'Website: ',
                            style: pw.TextStyle(
                              font: calibriFont,
                              fontSize: 9,
                            ),
                          ),
                          pw.UrlLink(
                            destination: 'http://www.mitrabaharisejati.com',
                            child: pw.Text(
                              'www.mitrabaharisejati.com',
                              style: pw.TextStyle(
                                font: calibriFont,
                                fontSize: 9,
                                color: PdfColors.blue,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
              ],
            ),

            // Garis tebal dan tipis
            pw.SizedBox(height: 5),

            pw.Container(
              height: 3,
              color: PdfColors.black,
            ),
            pw.Container(
              height: 1,
              color: PdfColors.black,
              margin: const pw.EdgeInsets.only(top: 1),
            ),
            // Isi Surat
            pw.SizedBox(height: 10),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 20), // Add height above "Nomor Surat"
                      pw.Table(
                        columnWidths: {
                          0: const pw.FixedColumnWidth(55),
                          1: const pw.FlexColumnWidth(),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text('Nomor',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text(
                                  ': ${widget.nomorSurat} / MBS - BPN / ${widget.bulanSurat} / ${widget.tahunSurat}',
                                  style: pw.TextStyle(
                                      fontSize: 11, font: calibriFont),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text('Lamp',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text(': -',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text('Perihal',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text(
                                  ': Permohonan Ijin Pengawasan Bongkar',
                                  style: pw.TextStyle(
                                      fontSize: 11, font: calibriBoldFont),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text('',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text(
                                  '  Barang Berbahaya',
                                  style: pw.TextStyle(
                                      fontSize: 11, font: calibriBoldFont),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Balikpapan, ${widget.tanggalSurat}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 35),
                      pw.Text(
                        'Kepada Yth.',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Ka. KSOP Balikpapan',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Di -',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Balikpapan',
                        style: pw.TextStyle(
                          fontSize: 11,
                          font: calibriFont,
                          decoration: pw.TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            pw.Text(
              'Dengan hormat,',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),
            pw.SizedBox(height: 18),

            pw.Text(
              'Sehubungan dengan Kedatangan Kapal Keagenan perusahaan kami, dengan ini kami mohon agar',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),
            pw.SizedBox(height: 3),

            pw.Text(
              'dapat diberikan ijin sandar / BONGKAR dengan data kapal sebagai berikut:',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(150),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Nama Kapal / Voyage',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': BIG. INDO SUKSES ${widget.nomorKapal}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Tanda Panggilan',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': -',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Bendera',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': INDONESIA',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Gross Tonnage',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': GT ${widget.grossTonnage}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Tiba Dari',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': SAMARINDA, ${widget.tanggalTiba}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('Rencana Bongkar / ',
                            style:
                                pw.TextStyle(fontSize: 11, font: calibriFont)),
                        pw.Text('Muat',
                            style: pw.TextStyle(
                              fontSize: 11,
                              font: calibriFont,
                              decoration: pw.TextDecoration.lineThrough,
                            )),
                      ],
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text(': BATUBARA, ${widget.rencanaBongkar}',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Jetty',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': ${widget.jetty}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('Pelabuhan Tujuan',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.Text(': SAMARINDA',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Demikianlah permohonan ini disampaikan, atas persetujuannya diucapkan terima kasih.',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),

            // Footer
            pw.SizedBox(height: 40),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Pemohon,',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'P.T. MITRA BAHARI SEJATI',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Cabang Balikpapan',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    width: 160, // Adjust width to accommodate both images
                    child: pw.Stack(
                      alignment: pw.Alignment.center,
                      children: [
                        pw.Image(logoImage, width: 60, height: 60),
                        pw.Positioned(
                          left: 70, // Adjust position to avoid cutting off
                          child: pw.Image(ttdImage, width: 100, height: 100),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'NUR WAHYUNI',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            pw.Spacer(),
            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.only(top: 20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Cabang Surabaya :\nJL. Kaliwaron No. 58 Gubeng, Surabaya\nJawa Timur Telepon/Fax (031) 5937802',
                        style: pw.TextStyle(
                          fontSize: 6.5,
                          font: tahomaFont,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 1,
                        height: 25, // Adjust the height as needed
                        color: PdfColor.fromHex(
                            '#0A1F44'), // Warna biru gelap (dark blue)
                      ),
                      pw.SizedBox(width: 3),
                      pw.Text(
                        'Cabang Gresik :\nJL. Amethiz III/12 Perum GBA\nJawa Timur Telepon/Fax : (031) 5937802',
                        style: pw.TextStyle(
                          fontSize: 6.5,
                          font: tahomaFont,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 1,
                        height: 25, // Adjust the height as needed
                        color: PdfColor.fromHex(
                            '#0A1F44'), // Warna biru gelap (dark blue)
                      ),
                      pw.SizedBox(width: 3),
                      pw.Text(
                        'Cabang Kuala Samboja :\nJL. Ir. Soekarno, Muara Jawa - Kutai Kartanegara\nKalimantan Timur Telepon/Fax : (0541) 692611',
                        style: pw.TextStyle(
                          fontSize: 6.5,
                          font: tahomaFont,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  Future<pw.Document> generateStsPdf({
    required String nomorSurat,
    required String bulanSurat,
    required String tahunSurat,
    required String nomorKapal,
    required String grossTonnage,
    required String tanggalTiba,
    required String rencanaBongkar,
    required String jetty,
    required String tanggalSurat,
  }) async {
    final pdf = pw.Document();
    final calibriFont =
        pw.Font.ttf(await rootBundle.load('assets/CALIBRI.TTF'));
    final calibriBoldFont =
        pw.Font.ttf(await rootBundle.load('assets/CALIBRIB.TTF'));

    final calibriBoldItalicFont =
        pw.Font.ttf(await rootBundle.load('assets/CALIBRIZ.TTF'));
    final tahomaFont = pw.Font.ttf(await rootBundle.load('assets/TAHOMA.TTF'));

    // Load images
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.only(
          left: 72, // 2.54 cm
          right: 72, // 2.54 cm
          top: 20, // 15 points
          bottom: 20, // 15 points
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Kop Surat
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(width: 15),

                pw.Image(logoImage,
                    width: 70, height: 70), // Tempatkan logo di sini

                pw.SizedBox(width: 3),
                // Teks di tengah
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'PT MITRA BAHARI SEJATI',
                        style: pw.TextStyle(
                          font: calibriBoldFont,
                          fontSize: 25,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                      pw.Text(
                        'Shipping Agency',
                        style: pw.TextStyle(
                            font: calibriBoldItalicFont,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#0A1F44'),
                            fontStyle: pw.FontStyle.italic),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Komp. BDS II Blok U No. 10 E RT.34 Kelurahan Sungainangka Kecamatan Balikpapan Selatan',
                        style: pw.TextStyle(font: calibriFont, fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Kalimantan Timur 75127',
                        style: pw.TextStyle(font: calibriFont, fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 2),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'Telepon. (0542) 8211308 ',
                            style: pw.TextStyle(
                              font: calibriFont,
                              fontSize: 9,
                              // color: PdfColors.blue,
                            ),
                          ),
                          pw.SizedBox(width: 2),
                          pw.Text(
                            'email: ',
                            style: pw.TextStyle(
                              font: calibriFont,
                              fontSize: 9,
                            ),
                          ),
                          pw.UrlLink(
                            destination: 'mailto:mbs.bppn05@gmail.com',
                            child: pw.Text(
                              'mbs.bppn05@gmail.com',
                              style: pw.TextStyle(
                                font: calibriFont,
                                fontSize: 9,
                                color: PdfColors.blue,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 2),
                          pw.Text(
                            'Website: ',
                            style: pw.TextStyle(
                              font: calibriFont,
                              fontSize: 9,
                            ),
                          ),
                          pw.UrlLink(
                            destination: 'http://www.mitrabaharisejati.com',
                            child: pw.Text(
                              'www.mitrabaharisejati.com',
                              style: pw.TextStyle(
                                font: calibriFont,
                                fontSize: 9,
                                color: PdfColors.blue,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
              ],
            ),

            // Garis tebal dan tipis
            pw.SizedBox(height: 5),

            pw.Container(
              height: 3,
              color: PdfColors.black,
            ),
            pw.Container(
              height: 1,
              color: PdfColors.black,
              margin: const pw.EdgeInsets.only(top: 1),
            ),
            // Isi Surat
            pw.SizedBox(height: 10),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 20), // Add height above "Nomor Surat"
                      pw.Table(
                        columnWidths: {
                          0: const pw.FixedColumnWidth(55),
                          1: const pw.FlexColumnWidth(),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text('Nomor',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text(
                                  ': ${widget.nomorSurat} / MBS - BPN / ${widget.bulanSurat} / ${widget.tahunSurat}',
                                  style: pw.TextStyle(
                                      fontSize: 11, font: calibriFont),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text('Lamp',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 2), // Add padding here
                                child: pw.Text(': -',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text('Perihal',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text(
                                  ': Permohonan alih muat Ship To Ship',
                                  style: pw.TextStyle(
                                      fontSize: 11, font: calibriFont),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text('',
                                    style: pw.TextStyle(
                                        fontSize: 11, font: calibriFont)),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                    bottom: 4), // Add padding here
                                child: pw.Text(
                                  '   (Transshipment)',
                                  style: pw.TextStyle(
                                      fontSize: 11, font: calibriFont),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Balikpapan, ${widget.tanggalSurat}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 35),
                      pw.Text(
                        'Kepada Yth.',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Ka. KSOP Balikpapan',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Di -',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Balikpapan',
                        style: pw.TextStyle(
                          fontSize: 11,
                          font: calibriFont,
                          decoration: pw.TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            pw.Text(
              'Dengan hormat,',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),
            pw.SizedBox(height: 18),

            pw.Text(
              'Sehubungan dengan Kedatangan Kapal Keagenan perusahaan kami, dengan ini kami mohon agar',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),
            pw.SizedBox(height: 3),

            pw.Text(
              'dapat di berikan ijin sandar / Ship To Ship ( Transshipment ) dengan data kapal sebagai berikut :',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(150),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Nama Kapal / Voyage',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': BIG. INDO SUKSES ${widget.nomorKapal}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Tanda Panggilan',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': -',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Bendera',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': INDONESIA',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Gross Tonnage',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': GT ${widget.grossTonnage}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Tiba Dari',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': SAMARINDA, ${widget.tanggalTiba}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('Rencana Bongkar / ',
                            style:
                                pw.TextStyle(fontSize: 11, font: calibriFont)),
                        pw.Text('Muat',
                            style: pw.TextStyle(
                              fontSize: 11,
                              font: calibriFont,
                              decoration: pw.TextDecoration.lineThrough,
                            )),
                      ],
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text(': BATUBARA, ${widget.rencanaBongkar}',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 3),
                      child: pw.Text('Jetty',
                          style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    ),
                    pw.Text(': ${widget.jetty}',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text('Pelabuhan Tujuan',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.Text(': SAMARINDA',
                        style: pw.TextStyle(fontSize: 11, font: calibriFont)),
                    pw.SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Demikianlah permohonan ini disampaikan, atas persetujuannya diucapkan terima kasih.',
              style: pw.TextStyle(fontSize: 11, font: calibriFont),
            ),

            // Footer
            pw.SizedBox(height: 40),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Pemohon,',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'P.T. MITRA BAHARI SEJATI',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Cabang Balikpapan',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    width: 160, // Adjust width to accommodate both images
                    child: pw.Stack(
                      alignment: pw.Alignment.center,
                      children: [
                        pw.Image(logoImage, width: 60, height: 60),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'NUR WAHYUNI',
                    style: pw.TextStyle(
                      font: calibriFont,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            pw.Spacer(),
            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.only(top: 20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Cabang Surabaya :\nJL. Kaliwaron No. 58 Gubeng, Surabaya\nJawa Timur Telepon/Fax (031) 5937802',
                        style: pw.TextStyle(
                          fontSize: 6.5,
                          font: tahomaFont,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 1,
                        height: 25, // Adjust the height as needed
                        color: PdfColor.fromHex(
                            '#0A1F44'), // Warna biru gelap (dark blue)
                      ),
                      pw.SizedBox(width: 3),
                      pw.Text(
                        'Cabang Gresik :\nJL. Amethiz III/12 Perum GBA\nJawa Timur Telepon/Fax : (031) 5937802',
                        style: pw.TextStyle(
                          fontSize: 6.5,
                          font: tahomaFont,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 1,
                        height: 25, // Adjust the height as needed
                        color: PdfColor.fromHex(
                            '#0A1F44'), // Warna biru gelap (dark blue)
                      ),
                      pw.SizedBox(width: 3),
                      pw.Text(
                        'Cabang Kuala Samboja :\nJL. Ir. Soekarno, Muara Jawa - Kutai Kartanegara\nKalimantan Timur Telepon/Fax : (0541) 692611',
                        style: pw.TextStyle(
                          fontSize: 6.5,
                          font: tahomaFont,
                          color: PdfColor.fromHex(
                              '#0A1F44'), // Warna biru gelap (dark blue)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return pdf;
    // // Buat nama file dengan format waktu
    // final now = DateTime.now();
    // final formattedDate =
    //     '${now.day}-${now.month}-${now.year}_${now.hour}-${now.minute}';
    // final fileName = 'Surat_B3_$formattedDate.pdf';

    // // Simpan ke folder Downloads
    // final downloadsDir = Directory('/storage/emulated/0/Download');
    // if (!downloadsDir.existsSync()) {
    //   downloadsDir.createSync(recursive: true);
    // }

    // final file = File("${downloadsDir.path}/$fileName");
    // await file.writeAsBytes(await pdf.save());

    // setState(() {
    //   pdfPath = file.path;
    //   isLoading = false;
    // });
  }

  Future<List<String>> generatePdfs() async {
    final b3Pdf = await generateB3PDF();
    // Get the directory to save the files
    // Simpan ke folder Downloads
    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }
    final dateTime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final b3Path = '${downloadsDir.path}/Surat_B3_$dateTime.pdf';

    // Save the B3 PDF
    final b3File = File(b3Path);
    await b3File.writeAsBytes(await b3Pdf.save());

    if (widget.jetty == 'JETTY DERMAGA PERKASA PRATAMA') {
      return [b3Path];
    }

    final stsPdf = await generateStsPdf(
      nomorSurat: widget.nomorSurat,
      bulanSurat: widget.bulanSurat,
      tahunSurat: widget.tahunSurat,
      nomorKapal: widget.nomorKapal,
      grossTonnage: widget.grossTonnage,
      tanggalTiba: widget.tanggalTiba,
      rencanaBongkar: widget.rencanaBongkar,
      jetty: widget.jetty,
      tanggalSurat: widget.tanggalSurat,
    );

    final stsPath = '${downloadsDir.path}/Surat_STS_$dateTime.pdf';

    // Save the STS PDF
    final stsFile = File(stsPath);
    await stsFile.writeAsBytes(await stsPdf.save());
    // Show a snackbar with the file paths
    // final snackBar = SnackBar(
    //   content: Text('PDFs saved at:\n$b3Path\n&\n$stsPath'),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return [b3Path, stsPath];
  }

  // Future<void> downloadPdfs() async {
  //   final b3Pdf = await generateB3PDF();

  //   final downloadsDir = Directory('/storage/emulated/0/Download');
  //   if (!downloadsDir.existsSync()) {
  //     downloadsDir.createSync(recursive: true);
  //   }
  //   final dateTime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
  //   final b3Path = '${downloadsDir.path}/Surat_B3_$dateTime.pdf';

  //   // Save the B3 PDF
  //   final b3File = File(b3Path);
  //   await b3File.writeAsBytes(await b3Pdf.save());

  //   if (widget.jetty == 'JETTY DERMAGA PERKASA PRATAMA') {
  //     final snackBar = SnackBar(
  //       content: Text('PDF saved at:\n$b3Path'),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     return;
  //   }
  //   final stsPdf = await generateStsPdf(
  //     nomorSurat: widget.nomorSurat,
  //     bulanSurat: widget.bulanSurat,
  //     tahunSurat: widget.tahunSurat,
  //     nomorKapal: widget.nomorKapal,
  //     grossTonnage: widget.grossTonnage,
  //     tanggalTiba: widget.tanggalTiba,
  //     rencanaBongkar: widget.rencanaBongkar,
  //     jetty: widget.jetty,
  //     tanggalSurat: widget.tanggalSurat,
  //   );

  //   final stsPath = '${downloadsDir.path}/Surat_STS_$dateTime.pdf';

  //   // Save the STS PDF
  //   final stsFile = File(stsPath);
  //   await stsFile.writeAsBytes(await stsPdf.save());

  //   // Show a snackbar with the file paths
  //   final snackBar = SnackBar(
  //     content: Text('PDFs saved at:\n$b3Path\n&\n$stsPath'),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Surat')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.jetty == 'JETTY DERMAGA PERKASA PRATAMA'
              ? PDFView(filePath: b3PdfPath)
              : PageView(
                  controller: _pageController,
                  children: [
                    PDFView(filePath: b3PdfPath),
                    PDFView(filePath: stsPdfPath),
                  ],
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
            if (widget.jetty != 'JETTY DERMAGA PERKASA PRATAMA')
              ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Next'),
              ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await downloadPdfs();
            //   },
            //   child: const Text('Download PDF'),
            // ),
          ],
        ),
      ),
    );
  }
}

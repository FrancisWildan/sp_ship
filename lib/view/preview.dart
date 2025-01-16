import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PreviewPage extends StatefulWidget {
  final String templateContent;
  final String fileName;
  final String email;

  const PreviewPage({
    required this.templateContent,
    required this.fileName,
    required this.email,
    super.key,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  String pdfPath = '';

  @override
  void initState() {
    super.initState();
    generatePDF();
  }

  Future<void> generatePDF() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            widget.templateContent,
            style: const pw.TextStyle(fontSize: 14),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Untuk informasi lebih lanjut, silakan hubungi:',
            style: const pw.TextStyle(fontSize: 12),
          ),
          pw.UrlLink(
            destination: 'mailto:${widget.email}',
            child: pw.Text(
              widget.email,
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.blue,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  // Mendapatkan folder Downloads
  final downloadsDir = Directory('/storage/emulated/0/Download'); // Path folder Downloads di Android
  if (!downloadsDir.existsSync()) {
    downloadsDir.createSync(recursive: true);
  }

  // Simpan PDF di folder Downloads
  final file = File("${downloadsDir.path}/${widget.fileName}.pdf");
  await file.writeAsBytes(await pdf.save());

  setState(() {
    pdfPath = file.path;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Surat')),
      body: pdfPath.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: pdfPath,
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
            ElevatedButton(
              onPressed: () async {
                final snackBar = SnackBar(
                  content: Text('PDF disimpan di: $pdfPath'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Download PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

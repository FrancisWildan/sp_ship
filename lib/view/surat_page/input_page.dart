// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'preview.dart';
import 'package:intl/intl.dart';

// import 'package:intl/locale.dart';
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController tanggalSuratController = TextEditingController();
  final TextEditingController nomorSuratController = TextEditingController();
  final TextEditingController bulanSuratController = TextEditingController();
  final TextEditingController tahunSuratController = TextEditingController();

  final TextEditingController nomorKapalController = TextEditingController();
  final TextEditingController grossTonnageController = TextEditingController();
  final TextEditingController tanggalTibaController = TextEditingController();
  final TextEditingController rencanaBongkarController =
      TextEditingController();
  final TextEditingController jettyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      setState(() {
        Intl.defaultLocale = 'id_ID';
        tanggalSuratController.text =
            DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());
        tanggalTibaController.text =
            DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());
      });
    });
    tanggalSuratController.text =
        DateFormat('dd MMMM yyyy').format(DateTime.now());
    tanggalTibaController.text =
        DateFormat('dd MMMM yyyy').format(DateTime.now());
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      // locale: Locale('id', 'ID'),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = DateFormat('dd MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  bool _areFieldsEmpty() {
    return tanggalSuratController.text.isEmpty ||
        nomorSuratController.text.isEmpty ||
        bulanSuratController.text.isEmpty ||
        tahunSuratController.text.isEmpty ||
        nomorKapalController.text.isEmpty ||
        grossTonnageController.text.isEmpty ||
        tanggalTibaController.text.isEmpty ||
        rencanaBongkarController.text.isEmpty ||
        jettyController.text.isEmpty;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning!",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber)),
          content: const Text("Semua field harus diisi!",
              style: TextStyle(
                  fontSize: 18,
                )),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Data Surat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: tanggalSuratController,
                decoration: const InputDecoration(labelText: 'Tanggal Surat'),
                readOnly: true,
                onTap: () => _selectDate(context, tanggalSuratController),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nomorSuratController,
                      decoration:
                          const InputDecoration(labelText: 'Nomor Surat'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Bulan Surat'),
                      items: [
                        'I',
                        'II',
                        'III',
                        'IV',
                        'V',
                        'VI',
                        'VII',
                        'VIII',
                        'IX',
                        'X',
                        'XI',
                        'XI'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          bulanSuratController.text = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: tahunSuratController,
                      decoration:
                          const InputDecoration(labelText: 'Tahun Surat'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  
                    ),
                  ),
                ],
              ),
              TextField(
                controller: nomorKapalController,
                decoration: const InputDecoration(labelText: 'Nomor Kapal'),
              ),
              TextField(
                controller: grossTonnageController,
                decoration: const InputDecoration(labelText: 'Gross Tonnage'),
              ),
              TextField(
                controller: tanggalTibaController,
                decoration: const InputDecoration(labelText: 'Tanggal Tiba'),
                readOnly: true,
                onTap: () => _selectDate(context, tanggalTibaController),
              ),
              TextField(
                controller: rencanaBongkarController,
                decoration:
                    const InputDecoration(labelText: 'Rencana Bongkar / Muat'),
                // keyboardType: TextInputType.number,
                inputFormatters: [
                  ThousandsSeparatorInputFormatter(),
                ],
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Jetty'),
                items: [
                  'JETTY DERMAGA PERKASA PRATAMA',
                  'STS TO KFT 1',
                  'STS TO KFT 2',
                  'STS TO KFT 3',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    jettyController.text = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_areFieldsEmpty()) {
                    _showErrorDialog();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreviewPage(
                          tanggalSurat: tanggalSuratController.text,
                          nomorSurat: nomorSuratController.text,
                          bulanSurat: bulanSuratController.text,
                          tahunSurat: tahunSuratController.text,
                          nomorKapal: nomorKapalController.text,
                          grossTonnage: grossTonnageController.text,
                          tanggalTiba: tanggalTibaController.text,
                          rencanaBongkar: rencanaBongkarController.text,
                          jetty: jettyController.text,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Unduh & Lihat Surat',style: TextStyle(fontSize: 15),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('id');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final String formattedText =
        _formatter.format(int.parse(newValue.text.replaceAll('.', '')));
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

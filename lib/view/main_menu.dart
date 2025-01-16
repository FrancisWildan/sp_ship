import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'surat_page/input_page.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  Future<void>? _launched;

  //NOTE: Fungsi untuk membuka link di browser
  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch =
        Uri(scheme: 'https', host: 'www.ilovepdf.com', path: '/');
    return Scaffold(
      // appBar: AppBar(title: const Text('Pilih Jenis Surat')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
            ),
            const SizedBox(height: 5),
            const Text(
              "SP-SHIP APP",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1F44)),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InputPage()),
                );
              },
              child: const Text("Buat Surat", style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {
                _launched = _launchInBrowserView(toLaunch);
              }),
              child:
                  const Text('Buka ILovePDF', style: TextStyle(fontSize: 20)),
            ),
            const Padding(padding: EdgeInsets.all(16.0)),
            FutureBuilder<void>(future: _launched, builder: _launchStatus),
          ],
        ),
      ),
    );
  }
}


// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'surat_page/input_page.dart';

// class MainMenu extends StatelessWidget {
//   const MainMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text('Pilih Jenis Surat')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/logo.png',
//               width: 100, // Adjust the width as needed
//               height: 100, // Adjust the height as needed
//             ),
//             const SizedBox(height: 5),
//             const Text(
//               "SP-SHIP APP",
//               style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0A1F44)),
//             ),
//             const SizedBox(height: 25),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const InputPage()),
//                 );
//               },
//               child: const Text("Buat Surat", style: TextStyle(fontSize: 20)),
//             ),
//             const SizedBox(height: 16),
//              ElevatedButton(
//                 onPressed: () => setState(() {
//                   _launched = _launchInBrowserView(toLaunch);
//                 }),
//                 child: const Text('Launch in app'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

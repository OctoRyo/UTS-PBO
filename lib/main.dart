import 'package:flutter/material.dart';

void main() {
  runApp(const GadgetApp());
}

// ================= ABSTRACT CLASS =================

abstract class Gadget {
  String nama;
  int harga;
  String deskripsi;
  String urlGambar;

  Gadget(this.nama, this.harga, this.deskripsi, this.urlGambar);

  String spesifikasi();

  String aksi();

  String informasi() {
    return "Nama : $nama\nHarga : Rp $harga";
  }
}

// ================= CLASS TURUNAN =================

class Smartphone extends Gadget {
  double ukuranLayar;

  Smartphone(String nama, int harga, String deskripsi, String urlGambar, this.ukuranLayar)
      : super(nama, harga, deskripsi, urlGambar);

  @override
  String spesifikasi() {
    return "Ukuran Layar: $ukuranLayar inci";
  }

  @override
  String aksi() {
    return "$nama siap digunakan untuk mengambil foto dan berkomunikasi.";
  }
}

class Laptop extends Gadget {
  String prosesor;

  Laptop(String nama, int harga, String deskripsi, String urlGambar, this.prosesor)
      : super(nama, harga, deskripsi, urlGambar);

  @override
  String spesifikasi() {
    return "Prosesor: $prosesor";
  }

  @override
  String aksi() {
    return "$nama siap digunakan untuk pekerja berat dan rendering.";
  }
}

class Smartwatch extends Gadget {
  int dayaTahanBaterai;

  Smartwatch(String nama, int harga, String deskripsi, String urlGambar, this.dayaTahanBaterai)
      : super(nama, harga, deskripsi, urlGambar);

  @override
  String spesifikasi() {
    return "Baterai: Tahan hingga $dayaTahanBaterai hari";
  }

  @override
  String aksi() {
    return "$nama aktif memantau aktivitas olahraga dan kesehatanmu.";
  }
}

// ================= FLUTTER UI =================

class GadgetApp extends StatelessWidget {
  const GadgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Gadget Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.indigo,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const DaftarGadgetScreen(),
    );
  }
}

// ================= HALAMAN UTAMA =================

class DaftarGadgetScreen extends StatefulWidget {
  const DaftarGadgetScreen({super.key});

  @override
  State<DaftarGadgetScreen> createState() => _DaftarGadgetScreenState();
}

class _DaftarGadgetScreenState extends State<DaftarGadgetScreen> {
  final List<Gadget> _daftarGadget = [];

  void _tambahGadget(Gadget gadgetBaru) {
    setState(() {
      _daftarGadget.add(gadgetBaru);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gadget Catalog"),
      ),
      body: _daftarGadget.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.devices, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada data gadget.",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _daftarGadget.length,
              itemBuilder: (context, index) {
                Gadget gadget = _daftarGadget[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bagian Gambar
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: gadget.urlGambar.isNotEmpty
                            ? Image.network(
                                gadget.urlGambar,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                                ),
                              )
                            : Container(
                                height: 180,
                                color: Colors.indigo[100],
                                child: const Icon(Icons.devices,
                                    size: 50, color: Colors.indigo),
                              ),
                      ),
                      // Bagian Informasi
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gadget.nama,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(gadget.informasi(),
                                style: TextStyle(color: Colors.grey[700])),
                            const Divider(height: 24),
                            _buildInfoRow(
                                Icons.memory, "Fitur Khusus", gadget.spesifikasi()),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                                Icons.bolt, "Penggunaan", gadget.aksi()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Gadget? gadgetBaru = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormTambahGadget()),
          );

          if (gadgetBaru != null) {
            _tambahGadget(gadgetBaru);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah Data"),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.indigo),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= HALAMAN FORM =================

class FormTambahGadget extends StatefulWidget {
  const FormTambahGadget({super.key});

  @override
  State<FormTambahGadget> createState() => _FormTambahGadgetState();
}

class _FormTambahGadgetState extends State<FormTambahGadget> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _gambarController = TextEditingController();
  final _atributKhususController = TextEditingController();

  String _jenisGadget = 'Smartphone';

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    _gambarController.dispose();
    _atributKhususController.dispose();
    super.dispose();
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      Gadget gadgetBaru;
      String nama = _namaController.text;
      int harga = int.parse(_hargaController.text);
      String deskripsi = _deskripsiController.text;
      String gambar = _gambarController.text;
      String atributKhusus = _atributKhususController.text;

      if (_jenisGadget == 'Smartphone') {
        double layar = double.tryParse(atributKhusus) ?? 0.0;
        gadgetBaru = Smartphone(nama, harga, deskripsi, gambar, layar);
      } else if (_jenisGadget == 'Laptop') {
        gadgetBaru = Laptop(nama, harga, deskripsi, gambar, atributKhusus);
      } else {
        int baterai = int.tryParse(atributKhusus) ?? 0;
        gadgetBaru = Smartwatch(nama, harga, deskripsi, gambar, baterai);
      }

      Navigator.pop(context, gadgetBaru);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Gadget"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _jenisGadget,
                decoration: _inputStyle("Jenis Gadget", Icons.category),
                items: ['Smartphone', 'Laptop', 'Smartwatch']
                    .map((jenis) => DropdownMenuItem(
                          value: jenis,
                          child: Text(jenis),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisGadget = value!;
                    _atributKhususController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: _inputStyle("Nama Gadget", Icons.badge),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: _inputStyle("Harga (Rupiah)", Icons.attach_money),
                validator: (value) {
                  if (value!.isEmpty) return 'Harga tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: _inputStyle("Deskripsi Singkat", Icons.description),
                validator: (value) =>
                    value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gambarController,
                decoration: _inputStyle("URL Gambar", Icons.image),
                validator: (value) =>
                    value!.isEmpty ? 'URL tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _atributKhususController,
                keyboardType: _jenisGadget == 'Laptop'
                    ? TextInputType.text
                    : const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputStyle(
                  _jenisGadget == 'Smartphone'
                      ? "Ukuran Layar (Inci)"
                      : _jenisGadget == 'Laptop'
                          ? "Prosesor (Contoh: Intel i7)"
                          : "Daya Tahan Baterai (Hari)",
                  Icons.star,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Atribut ini wajib diisi' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _simpanData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.indigo,
                ),
                child: const Text(
                  "SIMPAN DATA",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigo),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigo, width: 2),
      ),
    );
  }
}
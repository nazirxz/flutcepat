import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../model/DetailPengantaran.dart';
import '../service/ApiService.dart';

// Halaman untuk mengunggah bukti pengantaran
class BuktiPengantaranPage extends StatefulWidget {
  final DetailPengantaran detailPengantaran;

  BuktiPengantaranPage({required this.detailPengantaran});

  @override
  _BuktiPengantaranPageState createState() => _BuktiPengantaranPageState();
}

class _BuktiPengantaranPageState extends State<BuktiPengantaranPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk form validasi
  final _keteranganController = TextEditingController(); // Kontroler untuk input teks keterangan
  File? _image; // Variabel untuk menyimpan file gambar yang dipilih
  String _waktu = ''; // Variabel untuk menyimpan waktu saat ini
  final ImagePicker _picker = ImagePicker(); // Objek untuk memilih gambar dari kamera atau galeri
  final ApiService _apiService = ApiService(); // Instance dari ApiService untuk operasi API

  // Fungsi untuk memilih gambar dari kamera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path); // Simpan gambar yang dipilih ke variabel _image
      } else {
        print('No image selected.');
      }
    });
  }

  // Fungsi untuk mengunggah bukti pengantaran
  Future<void> _uploadBukti() async {
    if (_formKey.currentState!.validate() && _image != null) { // Validasi form dan cek apakah gambar sudah dipilih
      try {
        final tanggalTerima = DateTime.now().toString().split(' ')[0]; // Dapatkan tanggal saat ini
        await _apiService.uploadBuktiPengantaran(
          tanggalTerima: tanggalTerima,
          waktu: _waktu,
          keterangan: _keteranganController.text,
          gambar: _image!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bukti pengantaran berhasil diupload')),
        );

        await _updatePengantaranStatus('delivered'); // Perbarui status pengantaran menjadi 'delivered'

        // Navigate to home page
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } catch (e) {
        print('Error uploading bukti pengantaran: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupload bukti pengantaran')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih gambar dan isi semua field')),
      );
    }
  }

  // Fungsi untuk memperbarui status pengantaran
  Future<void> _updatePengantaranStatus(String status) async {
    try {
      if (widget.detailPengantaran.id.isEmpty) {
        throw Exception('ID pengantaran tidak valid');
      }

      int id = int.parse(widget.detailPengantaran.id); // Konversi ID pengantaran ke integer
      bool updateSuccess = await _apiService.updateDetailPengantaranStatus(id, status); // Panggil API untuk memperbarui status

      if (updateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status pengantaran berhasil diperbarui')),
        );
      } else {
        throw Exception('Gagal memperbarui status pengantaran');
      }
    } catch (e) {
      print('Error updating pengantaran status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status pengantaran: ${e.toString()}')),
      );
    }
  }

  // Fungsi untuk mendapatkan waktu saat ini
  void _getCurrentTime() {
    final now = DateTime.now();
    setState(() {
      _waktu = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}"; // Format waktu dalam format HH:MM:SS
    });
  }

  // Inisialisasi state
  @override
  void initState() {
    super.initState();
    _getCurrentTime(); // Panggil fungsi untuk mendapatkan waktu saat ini
  }

  // Membangun UI halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bukti Pengantaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Kunci form untuk validasi
          child: ListView(
            children: [
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!), // Menampilkan gambar yang dipilih
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage, // Panggil fungsi untuk memilih gambar
                child: Text('Ambil Gambar'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadBukti, // Panggil fungsi untuk mengunggah bukti pengantaran
                child: Text('Upload Bukti Pengantaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

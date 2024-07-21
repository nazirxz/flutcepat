import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File
import '../service/ApiService.dart'; // Update with the correct path to your ApiService

class BuktiPengantaranPage extends StatefulWidget {
  @override
  _BuktiPengantaranPageState createState() => _BuktiPengantaranPageState();
}

class _BuktiPengantaranPageState extends State<BuktiPengantaranPage> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  File? _image;
  String _waktu = '';

  @override
  void initState() {
    super.initState();
    _setCurrentTime();
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  void _setCurrentTime() {
    final now = DateTime.now();
    setState(() {
      _waktu = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final apiService = ApiService();

      try {
        await apiService.uploadBuktiPengantaran(
          tanggalTerima: DateTime.now().toIso8601String().split('T')[0], // Current date in YYYY-MM-DD format
          waktu: _waktu,
          keterangan: _keteranganController.text,
          gambar: _image!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bukti pengantaran berhasil dikirim')),
        );

        // Alihkan ke halaman home
        Navigator.pushReplacementNamed(context, '/home');

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim bukti pengantaran: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap lengkapi semua field dan upload gambar')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bukti Pengantaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _image == null
                  ? Text('Tidak ada gambar yang dipilih.')
                  : Image.file(
                _image!,
                width: 350, // Adjust the width as needed
                height: 350, // Adjust the height as needed
                fit: BoxFit.cover, // To make sure the image fits within the box
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tanggal Terima',
                ),
                initialValue: DateTime.now().toLocal().toString().split(' ')[0],
                readOnly: true,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Waktu',
                ),
                initialValue: _waktu,
                readOnly: true,
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Ambil Foto'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Pilih dari Galeri'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Kirim Bukti'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

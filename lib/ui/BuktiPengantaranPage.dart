import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../model/DetailPengantaran.dart';
import '../service/ApiService.dart';

class BuktiPengantaranPage extends StatefulWidget {
  final DetailPengantaran detailPengantaran;

  BuktiPengantaranPage({required this.detailPengantaran});

  @override
  _BuktiPengantaranPageState createState() => _BuktiPengantaranPageState();
}

class _BuktiPengantaranPageState extends State<BuktiPengantaranPage> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  File? _image;
  String _waktu = '';
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadBukti() async {
    if (_formKey.currentState!.validate() && _image != null) {
      try {
        final tanggalTerima = DateTime.now().toString().split(' ')[0];
        await _apiService.uploadBuktiPengantaran(
          tanggalTerima: tanggalTerima,
          waktu: _waktu,
          keterangan: _keteranganController.text,
          gambar: _image!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bukti pengantaran berhasil diupload')),
        );

        await _updatePengantaranStatus('delivered');

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

  Future<void> _updatePengantaranStatus(String status) async {
    try {
      if (widget.detailPengantaran.id.isEmpty) {
        throw Exception('ID pengantaran tidak valid');
      }

      int id = int.parse(widget.detailPengantaran.id);
      bool updateSuccess = await _apiService.updateDetailPengantaranStatus(id, status);

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

  void _getCurrentTime() {
    final now = DateTime.now();
    setState(() {
      _waktu = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentTime();
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
                  : Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadBukti,
                child: Text('Upload Bukti Pengantaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
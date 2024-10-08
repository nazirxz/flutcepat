
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../model/DetailPengantaran.dart';
import '../service/ApiService.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

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
  Position? _currentPosition;
  String? _latitude;
  String? _longitude;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      await _addLocationAndTimestamp(file);
      setState(() {
        _image = file;
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _addLocationAndTimestamp(File imageFile) async {
    try {
      _currentPosition = await _determinePosition();
      if (_currentPosition != null) {
        _latitude = _currentPosition!.latitude.toStringAsFixed(6);
        _longitude = _currentPosition!.longitude.toStringAsFixed(6);
        _waktu = DateTime.now().toIso8601String();

        final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
        if (image != null) {
          final font = img.arial_24;
          final timestampText = 'Lat: $_latitude, Long: $_longitude\nTimestamp: $_waktu ';

          img.drawString(image, font, 10, 10, timestampText, color: img.getColor(255, 255, 255));

          final directory = await getApplicationDocumentsDirectory();
          final newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
          File(newPath)..writeAsBytesSync(img.encodePng(image));

          setState(() {
            _image = File(newPath);
          });
        }
      }
    } catch (e) {
      print('Error retrieving location and timestamp: $e');
    }
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Fungsi untuk mengunggah bukti pengantaran
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
                  : Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.file(_image!),
                  if (_latitude != null && _longitude != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Lat: $_latitude, Long: $_longitude\nTimestamp: $_waktu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Ambil Gambar'),
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

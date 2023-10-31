import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:front_flutter_distribuidos/models/user.dart';
import 'package:http/http.dart' as http;

class UploadFileView extends StatefulWidget {
  final User? usuario;

  const UploadFileView({super.key, this.usuario});
  @override
  _UploadFileViewState createState() => _UploadFileViewState();
}

class _UploadFileViewState extends State<UploadFileView> {
  PlatformFile? selectedFile;
  File? selectedFile_File;

  void selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var archivo = result!.files.first;
    if (result != null) {
      setState(() {
        selectedFile = PlatformFile(path: archivo.path,name: archivo.name, size: archivo.size);
      });
    }
  }
/*
  Future<void> pickAndUploadFile() async {
    File? selectedFile;

    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        final platformFile = result.files.first;
        final uint8List = platformFile.bytes;

        // Convierte PlatformFile a File
        selectedFile = File(platformFile.path!);
        await selectedFile.writeAsBytes(uint8List!);
      }
    } catch (e) {
      print("Error al seleccionar y convertir el archivo: $e");
    }

  }*/

  Future<void> uploadFile() async {
    if (selectedFile == null) {
      print("DEBES SELECCIONAR UN ARCHIVO");
      return;
    }
    setState(() {
      selectedFile_File=selectedFile as File;
    });

    String url = 'http://10.0.2.2:1234/file/uploadFile'; // Reemplaza con la URL correcta

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      http.MultipartFile.fromBytes(
        'file', // Nombre del campo en la solicitud
        await selectedFile_File!.readAsBytes(),
        filename: selectedFile_File!.path.split('/').last,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        // El archivo se subió exitosamente, puedes manejar la respuesta del servidor aquí
        print('Archivo subido exitosamente.');
      } else {
        // Manejar errores, por ejemplo, mostrar un mensaje de error
        print('Error al subir el archivo: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores, por ejemplo, mostrar un mensaje de error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Archivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (selectedFile != null)
              Text('Archivo seleccionado: ${selectedFile!.path}'),
            ElevatedButton(
              onPressed: (){
                //pickAndUploadFile();
                selectFile;
              },
              child: Text('Seleccionar Archivo'),
            ),
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Subir Archivo'),
            ),
          ],
        ),
      ),
    );
  }
}

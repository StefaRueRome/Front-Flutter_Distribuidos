import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UploadFileView extends StatefulWidget {
  @override
  _UploadFileViewState createState() => _UploadFileViewState();
}

class _UploadFileViewState extends State<UploadFileView> {
  List<PlatformFile> selectedFiles = [];
  String errorMessage = '';

  Future<void> uploadFiles() async {
    if (selectedFiles.isEmpty) {
      setState(() {
        errorMessage = 'No se han seleccionado archivos.';
      });
      return;
    }

    // Convierte los archivos seleccionados en listas de bytes
    List<List<int>> fileDataList = [];
    for (var file in selectedFiles) {
      fileDataList.add(file.bytes!);
    }

    // Crea una lista de base64 codificada de las listas de bytes
    List<String> base64DataList = fileDataList.map((bytes) {
      return base64Encode(bytes);
    }).toList();

    // Construye el cuerpo de la solicitud
    final url = 'https://tu-servidor-java/file/uploadFile'; // Reemplaza con la URL correcta
    final body = jsonEncode({
      "name": "nombre_archivo", // Reemplaza con el nombre de archivo deseado
      "path": "ruta_archivo", // Reemplaza con la ruta de archivo deseada
      "fileData": base64DataList,
      "size": 0.0, // Ajusta el tamaño del archivo si es necesario
      "userId": 1, // Reemplaza con el ID del usuario
      "folderId": 1, // Reemplaza con el ID de la carpeta
      "nodeId": 1, // Reemplaza con el ID del nodo
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      setState(() {
        errorMessage = 'Archivos subidos exitosamente.';
      });
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String errorDetails = responseData['msg']['details'];
      setState(() {
        errorMessage = errorDetails;
      });
    }
  }

  Future<void> selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        selectedFiles = result.files;
        errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subir Archivos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: selectFiles,
              child: Text('Seleccionar Archivos'),
            ),
            if (selectedFiles.isNotEmpty)
              Text('Archivos Seleccionados: ${selectedFiles.length}'),
            ElevatedButton(
              onPressed: uploadFiles,
              child: Text('Subir Archivos'),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

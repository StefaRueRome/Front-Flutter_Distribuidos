// Importa las bibliotecas necesarias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_flutter_distribuidos/models/File.dart';

import 'package:front_flutter_distribuidos/models/user.dart';
import 'package:front_flutter_distribuidos/views/uploadFile_view.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  final String userId;
  final User? usuario;
  final String? email;

  HomeView({required this.userId, this.usuario, this.email,});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<FileModel> FileModels = []; // Lista de archivos

  Future<void> fetchFileModels() async {
    final url = 'http://10.0.2.2:1234/File/getFiles/${widget.userId}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> FileModelsData = responseData['json'];

      final List<FileModel> fetchedFileModels = FileModelsData
          .map((data) => FileModel.fromJson(data))
          .toList();

      setState(() {
        FileModels = fetchedFileModels;
      });
    } else {
      print("Error al mostrar los archivos");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFileModels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archivos de Usuario'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.usuario?.name ?? 'Cuenta'),
              accountEmail: Text(widget.email ?? 'usuario@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.upload),
              title: Text('Subir Documento'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadFileView(usuario: widget.usuario,), // Pasa el ID del usuario a HomeView
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FileModels.isEmpty
          ? Center(child: Text('El usuario no tiene archivos'))
          : ListView.builder(
              itemCount: FileModels.length,
              itemBuilder: (context, index) {
                final FileModel = FileModels[index];
                return ListTile(
                  title: Text(FileModel.name),
                  subtitle: Text('Tamaño: ${FileModel.size} bytes'),
                );
              },
            ),
    );
  }
}

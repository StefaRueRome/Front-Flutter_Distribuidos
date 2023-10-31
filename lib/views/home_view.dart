// Importa las bibliotecas necesarias
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_flutter_distribuidos/models/File.dart';
import 'package:front_flutter_distribuidos/models/user.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  final String userId;
  final User? usuario;

  HomeView({required this.userId, this.usuario});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<File> files = []; // Lista de archivos

  Future<void> fetchFiles() async {
    final url = 'http://10.0.2.2:1234/file/getFiles/${widget.userId}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> filesData = responseData['json'];

      final List<File> fetchedFiles = filesData
          .map((data) => File.fromJson(data))
          .toList();

      setState(() {
        files = fetchedFiles;
      });
    } else {
      print("Error al mostrar los archivos");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archivos de Usuario'),
      ),
      body: files.isEmpty
          ? Center(child: Text('El usuario no tiene archivos'))
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file.name),
                  subtitle: Text('Tamaño: ${file.size} bytes'),
                );
              },
            ),
    );
  }
}

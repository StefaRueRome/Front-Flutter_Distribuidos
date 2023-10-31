import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_flutter_distribuidos/models/user.dart';
import 'package:front_flutter_distribuidos/views/home_view.dart';
import 'package:front_flutter_distribuidos/views/login_view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationView extends StatefulWidget {
  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = "";
  

  Future<void> registerUser() async {
    final user = User(
      name: nameController.text,
      surname: surnameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1234/auth/register'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final userId = json.decode(response.body)['msg']['json'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(userId: userId,usuario: user,), // Pasa el ID del usuario a HomeView
        ),
      );
    } else if (response.statusCode == 400) {
      setState(() {
        message="Usuario ya resgistrado";
      });
      // Puedes mostrar el mensaje de error o realizar acciones adicionales aquí
    } else {
      final errorMessage = json.decode(response.body)['message'];
      setState(() {
        message=errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: surnameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Registrarse'),
            ),
            SizedBox(height: 12.0),
            Text(
              message,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginView(), // Pasa el ID del usuario a HomeView
                  ),
                );
              },
              child: Text('Loguearme'),
            ),
          ],
        ),
      ),
    );
  }
}

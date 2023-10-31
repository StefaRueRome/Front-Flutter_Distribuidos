import 'package:flutter/material.dart';
import 'package:front_flutter_distribuidos/views/home_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<String> getUserId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwt_token')??'';
  }

  String errorMessage = '';

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final url = 'http://10.0.2.2:1234/auth/login';

    final body = jsonEncode({"email": email, "password": password});

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
  
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = json.decode(responseData['msg']['json'])['token'];

      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      print('Token JWT: $token');
      
      //Recuperar el id
      final user_id = await getUserId();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(userId: user_id,), // Pasa el ID del usuario a HomeView
        ),
      );

      setState(() {
        errorMessage = '';
      });
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String errorDetails = responseData['msg']['details'];
      setState(() {
        errorMessage = errorDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: login,
              child: Text('Iniciar Sesión'),
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

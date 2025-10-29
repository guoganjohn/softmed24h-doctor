import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:softmed24h_admin/src/services/storage_service.dart';
import 'package:softmed24h_admin/src/utils/api_service.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final StorageService _storageService = StorageService();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final String? token = await _storageService.read('access_token');
    if (token != null && token.isNotEmpty) {
      context.go('/dashboard');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final AuthResponse authResponse = await _apiService.login(email, password);
      await _storageService.write('access_token', authResponse.accessToken);
      context.go('/dashboard');
    } on Exception catch (e) {
      String errorMessage = 'Falha no login. Verifique suas credenciais.';
      if (e.toString().contains('401')) {
        errorMessage = 'Credenciais inválidas. Verifique seu e-mail e senha.';
      } else if (e.toString().contains('500')) {
        errorMessage = 'Erro interno do servidor. Tente novamente mais tarde.';
      } else {
        errorMessage = 'Erro de conexão. Tente novamente mais tarde.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      print('Error during login: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 8.0, // Add some shadow to the card
            margin: const EdgeInsets.all(16.0), // Margin around the card
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Make the column take minimum vertical space
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          child: const Text('Entrar'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

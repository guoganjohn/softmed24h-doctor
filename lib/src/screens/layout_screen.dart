import 'package:flutter/material.dart';
import 'package:softmed24h_doctor/src/widgets/breadcrumb.dart';
import 'package:softmed24h_doctor/src/widgets/header.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // For JSON decoding
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class LayoutScreen extends StatefulWidget {
  final Widget body;

  const LayoutScreen({super.key, required this.body});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  // State variable to track the currently expanded tile's route path
  String? _currentExpandedTile;
  String? _username; // State variable to store the fetched username
  bool _isLoading = true; // State variable to manage loading state

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch username when the widget initializes
    // Initialize _currentExpandedTile based on the active route when the widget is first built
    _currentExpandedTile = _getActiveParentRoute();
  }

  // Helper to determine the active main parent route for initial expansion
  String? _getActiveParentRoute() {
    final currentPath = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();

    if (currentPath.startsWith('/dashboard/meumed-academy')) {
      return '/dashboard/meumed-academy';
    } else if (currentPath.startsWith('/dashboard/minha-conta')) {
      return '/dashboard/minha-conta';
    } else if (currentPath.startsWith('/dashboard/financeiro')) {
      return '/dashboard/financeiro';
    } else if (currentPath.startsWith('/dashboard/telemedicina')) {
      return '/dashboard/telemedicina';
    }
    return null;
  }

  // Method to fetch the username from the backend
  Future<void> _fetchUserName() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        // If no token, navigate to login or handle as unauthenticated
        if (mounted) {
          context.go('/');
        }
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:8000/users/me'), // Replace with your backend URL
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _username = userData['name'] ?? 'Usuário'; // Default to 'Usuário' if name is null
        });
      } else if (response.statusCode == 401) {
        // Token expired or invalid, navigate to login
        if (mounted) {
          _logout();
        }
      } else {
        // Handle other errors
        print('Failed to load user data: ${response.statusCode}');
        setState(() {
          _username = 'Erro';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _username = 'Erro';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to handle user logout
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // Clear the token
    if (mounted) {
      context.go('/'); // Navigate to login screen
    }
  }

  // Checks if the current route exactly matches the given path (for sub-menus or the main dashboard link)
  bool _isExactRouteActive(String routePath) {
    final currentPath = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    return currentPath == routePath;
  }

  // Checks if the current route is the parent path or any of its children (for ExpansionTile styling)
  bool _isParentRouteActive(String routePath) {
    final currentPath = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.toString();
    return currentPath == routePath || currentPath.startsWith('$routePath/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel'),
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: Row(
        children: <Widget>[
          // Sidebar content
          SizedBox(
            width: 250, // Fixed width for the sidebar
            child: Container(
              color: Colors.grey[200], // Set background color to light grey
              child: Column(
                children: <Widget>[
                  // Top spacing (Color Box)
                  const ColoredBox(
                    color: Colors.blue,
                    child: SizedBox(width: double.infinity, height: 16.0),
                  ),

                  // Header/Profile Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 60,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Center the row content
                            children: <Widget>[
                              _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white) // Show loading indicator
                                  : Text(
                                      _username ?? 'Usuário', // Display fetched username or default
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                              const SizedBox(width: 8), // Spacing
                              IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white),
                                onPressed: _logout, // Call the _logout method
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom spacing (Color Box)
                  const ColoredBox(
                    color: Colors.blue,
                    child: SizedBox(width: double.infinity, height: 8.0),
                  ),

                  // --- Menu Items wrapped in a SingleChildScrollView to prevent overflow ---
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          // Painel de Controle (Dashboard)
                          ListTile(
                            leading: const Icon(Icons.dashboard),
                            title: const Text('Painel de Controle'),
                            selected: _isExactRouteActive('/dashboard'),
                            selectedTileColor: Colors.blue.withOpacity(0.2),
                            selectedColor: Colors.blue,
                            onTap: () {
                              context.go('/dashboard');
                            },
                          ),

                          // MeuMed Academy
                          ExpansionTile(
                            leading: const Icon(Icons.school),
                            title: const Text('MeuMed Academy'),
                            // Control expansion based on state
                            initiallyExpanded:
                                _currentExpandedTile ==
                                '/dashboard/meumed-academy',
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                // Close all others when this one expands
                                _currentExpandedTile = expanded
                                    ? '/dashboard/meumed-academy'
                                    : null;
                              });
                            },
                            collapsedIconColor: Colors.black,
                            // Highlight icon if parent route is active (blue)
                            iconColor:
                                _isParentRouteActive(
                                  '/dashboard/meumed-academy',
                                )
                                ? Colors.blue
                                : Colors.black,
                            collapsedTextColor: Colors.black,
                            // Highlight text if parent route is active (blue)
                            textColor:
                                _isParentRouteActive(
                                  '/dashboard/meumed-academy',
                                )
                                ? Colors.blue
                                : Colors.black,
                            children: <Widget>[
                              ListTile(
                                title: const Text('Videos Tutoriais'),
                                selected: _isExactRouteActive(
                                  '/dashboard/meumed-academy/videos-tutoriais',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/meumed-academy/videos-tutoriais',
                                  );
                                },
                              ),
                              ListTile(
                                title: const Text('Treinamentos'),
                                selected: _isExactRouteActive(
                                  '/dashboard/meumed-academy/treinamentos',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/meumed-academy/treinamentos',
                                  );
                                },
                              ),
                              ListTile(
                                title: const Text('Material de Apoio'),
                                selected: _isExactRouteActive(
                                  '/dashboard/meumed-academy/material-apoio',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/meumed-academy/material-apoio',
                                  );
                                },
                              ),
                            ],
                          ),

                          // Minha Conta
                          ExpansionTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Minha Conta'),
                            // Control expansion based on state
                            initiallyExpanded:
                                _currentExpandedTile ==
                                '/dashboard/minha-conta',
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _currentExpandedTile = expanded
                                    ? '/dashboard/minha-conta'
                                    : null;
                              });
                            },
                            collapsedIconColor: Colors.black,
                            iconColor:
                                _isParentRouteActive('/dashboard/minha-conta')
                                ? Colors.blue
                                : Colors.black,
                            collapsedTextColor: Colors.black,
                            textColor:
                                _isParentRouteActive('/dashboard/minha-conta')
                                ? Colors.blue
                                : Colors.black,
                            children: <Widget>[
                              ListTile(
                                title: const Text('Minhas Informações'),
                                selected: _isExactRouteActive(
                                  '/dashboard/minha-conta/minhas-informacoes',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/minha-conta/minhas-informacoes',
                                  );
                                },
                              ),
                              ListTile(
                                title: const Text('Meus Documentos'),
                                selected: _isExactRouteActive(
                                  '/dashboard/minha-conta/meus-documentos',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/minha-conta/meus-documentos',
                                  );
                                },
                              ),
                              ListTile(
                                title: const Text('Minha Senha'),
                                selected: _isExactRouteActive(
                                  '/dashboard/minha-conta/minha-senha',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/minha-conta/minha-senha',
                                  );
                                },
                              ),
                              ListTile(
                                title: const Text('Meus Comunicados'),
                                selected: _isExactRouteActive(
                                  '/dashboard/minha-conta/meus-comunicados',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/minha-conta/meus-comunicados',
                                  );
                                },
                              ),
                            ],
                          ),

                          // Financeiro
                          ExpansionTile(
                            leading: const Icon(Icons.account_balance_wallet),
                            title: const Text('Financeiro'),
                            // Control expansion based on state
                            initiallyExpanded:
                                _currentExpandedTile == '/dashboard/financeiro',
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _currentExpandedTile = expanded
                                    ? '/dashboard/financeiro'
                                    : null;
                              });
                            },
                            collapsedIconColor: Colors.black,
                            iconColor:
                                _isParentRouteActive('/dashboard/financeiro')
                                ? Colors.blue
                                : Colors.black,
                            collapsedTextColor: Colors.black,
                            textColor:
                                _isParentRouteActive('/dashboard/financeiro')
                                ? Colors.blue
                                : Colors.black,
                            children: <Widget>[
                              ListTile(
                                title: const Text('Extrato Financeiro'),
                                selected: _isExactRouteActive(
                                  '/dashboard/financeiro/extrato-financeiro',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/financeiro/extrato-financeiro',
                                  );
                                },
                              ),
                              ListTile(
                                title: const Text('Meus Saques'),
                                selected: _isExactRouteActive(
                                  '/dashboard/financeiro/meus-saques',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/financeiro/meus-saques',
                                  );
                                },
                              ),
                              ListTile(
                                title: const Text('Meus Cartões'),
                                selected: _isExactRouteActive(
                                  '/dashboard/financeiro/meus-cartoes',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/financeiro/meus-cartoes',
                                  );
                                },
                              ),
                            ],
                          ),

                          // Telemedicina
                          ExpansionTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Telemedicina'),
                            // Control expansion based on state
                            initiallyExpanded:
                                _currentExpandedTile ==
                                '/dashboard/telemedicina',
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _currentExpandedTile = expanded
                                    ? '/dashboard/telemedicina'
                                    : null;
                              });
                            },
                            collapsedIconColor: Colors.black,
                            iconColor:
                                _isParentRouteActive('/dashboard/telemedicina')
                                ? Colors.blue
                                : Colors.black,
                            collapsedTextColor: Colors.black,
                            textColor:
                                _isParentRouteActive('/dashboard/telemedicina')
                                ? Colors.blue
                                : Colors.black,
                            children: <Widget>[
                              ListTile(
                                title: const Text('Gerenciamento de Fila'),
                                selected: _isExactRouteActive(
                                  '/dashboard/telemedicina/gerenciamento-fila',
                                ),
                                selectedTileColor: Colors.blue.withOpacity(0.2),
                                selectedColor: Colors.blue,
                                onTap: () {
                                  context.go(
                                    '/dashboard/telemedicina/gerenciamento-fila',
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ), // End of SingleChildScrollView
                ],
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(title: _getTitleForRoute()),
                const Breadcrumb(),
                Expanded(
                  child: widget.body, // Use the provided body widget
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleForRoute() {
    final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    const routeTitles = {
      '/dashboard': 'Painel de Controle',
      '/dashboard/meumed-academy/videos-tutoriais': 'Videos Tutoriais',
      '/dashboard/meumed-academy/treinamentos': 'Treinamentos',
      '/dashboard/meumed-academy/material-apoio': 'Material de Apoio',
      '/dashboard/minha-conta/minhas-informacoes': 'Minhas Informações',
      '/dashboard/minha-conta/meus-documentos': 'Meus Documentos',
      '/dashboard/minha-conta/minha-senha': 'Minha Senha',
      '/dashboard/minha-conta/meus-comunicados': 'Meus Comunicados',
      '/dashboard/financeiro/extrato-financeiro': 'Extrato Financeiro',
      '/dashboard/financeiro/meus-saques': 'Meus Saques',
      '/dashboard/financeiro/meus-cartoes': 'Meus Cartões',
      '/dashboard/telemedicina/gerenciamento-fila': 'Gerenciamento de Fila',
    };

    return routeTitles[currentPath] ?? 'Painel';
  }
}

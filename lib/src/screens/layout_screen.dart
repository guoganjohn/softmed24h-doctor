import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h_admin/src/screens/meumed_academy/videos_tutoriais_screen.dart';
import 'package:softmed24h_admin/src/screens/meumed_academy/treinamentos_screen.dart';
import 'package:softmed24h_admin/src/screens/meumed_academy/material_apoio_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/minhas_informacoes_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/meus_documentos_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/minha_senha_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/meus_comunicados_screen.dart';
import 'package:softmed24h_admin/src/screens/financeiro/extrato_financeiro_screen.dart'; // Assuming these will be created
import 'package:softmed24h_admin/src/screens/financeiro/meus_saques_screen.dart'; // Assuming these will be created
import 'package:softmed24h_admin/src/screens/financeiro/meus_cartoes_screen.dart'; // Assuming these will be created
import 'package:softmed24h_admin/src/screens/telemedicina/gerenciamento_fila_screen.dart';

class LayoutScreen extends StatefulWidget {
  final Widget body;

  const LayoutScreen({super.key, required this.body});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  bool _isRouteActive(String routePath) {
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
                  const ColoredBox(
                    color: Colors.blue,
                    child: SizedBox(width: double.infinity, height: 16.0),
                  ), // Top spacing
                  Container(
                    // This is the header Container
                    width: double.infinity, // Ensure full width
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 8.0,
                      ), // Add padding
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center vertically
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align content to center horizontally
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
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () {
                              context.go('/'); // Navigate to login screen
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const ColoredBox(
                    color: Colors.blue,
                    child: SizedBox(width: double.infinity, height: 8.0),
                  ), // Bottom spacing
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Painel de Controle'),
                    selected: _isRouteActive('/dashboard'),
                    selectedTileColor: Colors.blue.withOpacity(0.2),
                    selectedColor: Colors.blue,
                    onTap: () {
                      context.go('/dashboard');
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.school),
                    title: const Text('MeuMed Academy'),
                    initiallyExpanded: _isRouteActive(
                      '/dashboard/meumed-academy',
                    ), // Expand if any sub-route is active
                    collapsedIconColor:
                        Colors.black, // Default icon color when not expanded
                    iconColor: Colors.blue, // Icon color when expanded
                    collapsedTextColor:
                        Colors.black, // Default text color when not expanded
                    textColor: Colors.blue, // Text color when expanded
                    children: <Widget>[
                      ListTile(
                        title: const Text('Videos Tutoriais'),
                        selected: _isRouteActive(
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
                        selected: _isRouteActive(
                          '/dashboard/meumed-academy/treinamentos',
                        ),
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        selectedColor: Colors.blue,
                        onTap: () {
                          context.go('/dashboard/meumed-academy/treinamentos');
                        },
                      ),
                      ListTile(
                        title: const Text('Material de Apoio'),
                        selected: _isRouteActive(
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
                  ExpansionTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Minha Conta'),
                    initiallyExpanded: _isRouteActive(
                      '/dashboard/minha-conta',
                    ), // Expand if any sub-route is active
                    collapsedIconColor:
                        Colors.black, // Default icon color when not expanded
                    iconColor: Colors.blue, // Icon color when expanded
                    collapsedTextColor:
                        Colors.black, // Default text color when not expanded
                    textColor: Colors.blue, // Text color when expanded
                    children: <Widget>[
                      ListTile(
                        title: const Text('Minhas Informações'),
                        selected: _isRouteActive(
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
                        selected: _isRouteActive(
                          '/dashboard/minha-conta/meus-documentos',
                        ),
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        selectedColor: Colors.blue,
                        onTap: () {
                          context.go('/dashboard/minha-conta/meus-documentos');
                        },
                      ),
                      ListTile(
                        title: const Text('Minha Senha'),
                        selected: _isRouteActive(
                          '/dashboard/minha-conta/minha-senha',
                        ),
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        selectedColor: Colors.blue,
                        onTap: () {
                          context.go('/dashboard/minha-conta/minha-senha');
                        },
                      ),
                      ListTile(
                        title: const Text('Meus Comunicados'),
                        selected: _isRouteActive(
                          '/dashboard/minha-conta/meus-comunicados',
                        ),
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        selectedColor: Colors.blue,
                        onTap: () {
                          context.go('/dashboard/minha-conta/meus-comunicados');
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text('Financeiro'),
                    initiallyExpanded: _isRouteActive(
                      '/dashboard/financeiro',
                    ), // Expand if any sub-route is active
                    collapsedIconColor:
                        Colors.black, // Default icon color when not expanded
                    iconColor: Colors.blue, // Icon color when expanded
                    collapsedTextColor:
                        Colors.black, // Default text color when not expanded
                    textColor: Colors.blue, // Text color when expanded
                    children: <Widget>[
                      ListTile(
                        title: const Text('Extrato Financeiro'),
                        selected: _isRouteActive(
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
                        selected: _isRouteActive(
                          '/dashboard/financeiro/meus-saques',
                        ),
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        selectedColor: Colors.blue,
                        onTap: () {
                          context.go('/dashboard/financeiro/meus-saques');
                        },
                      ),
                      ListTile(
                        title: const Text('Meus Cartões'),
                        selected: _isRouteActive(
                          '/dashboard/financeiro/meus-cartoes',
                        ),
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        selectedColor: Colors.blue,
                        onTap: () {
                          context.go('/dashboard/financeiro/meus-cartoes');
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.medical_services),
                    title: const Text('Telemedicina'),
                    initiallyExpanded: _isRouteActive(
                      '/dashboard/telemedicina',
                    ), // Expand if any sub-route is active
                    collapsedIconColor:
                        Colors.black, // Default icon color when not expanded
                    iconColor: Colors.blue, // Icon color when expanded
                    collapsedTextColor:
                        Colors.black, // Default text color when not expanded
                    textColor: Colors.blue, // Text color when expanded
                    children: <Widget>[
                      ListTile(
                        title: const Text('Gerenciamento de Fila'),
                        selected: _isRouteActive(
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
                  const Expanded(child: SizedBox()), // Fill remaining space
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: widget.body, // Use the provided body widget
          ),
        ],
      ),
    );
  }
}

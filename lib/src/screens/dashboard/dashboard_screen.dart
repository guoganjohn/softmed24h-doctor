import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // Sidebar content
          SizedBox(
            width: 250, // Fixed width for the sidebar
            child: Container(
              // Wrap in Container to set background color
              color: Colors.grey[200], // Set background color to light grey
              child: Column(
                children: <Widget>[
                  ColoredBox(
                    color: Colors.blue,
                    child: SizedBox(width: double.infinity, height: 32),
                  ), // Add spacing
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
                          const SizedBox(height: 8),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            onPressed: () {
                              // No need to pop drawer as it's always visible
                              context.go('/'); // Navigate to login screen
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  ColoredBox(
                    color: Colors.blue,
                    child: SizedBox(width: double.infinity, height: 8),
                  ), // Add spacing
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Início'),
                    onTap: () {
                      // Handle navigation to home
                      // No need to pop drawer as it's always visible
                    },
                  ),
                  const Expanded(child: SizedBox()), // Fill remaining space
                ],
              ),
            ),
          ),
          // Main content
          const Expanded(
            child: Center(child: Text('Conteúdo da Tela do Painel')),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:softmed24h_doctor/src/utils/api_service.dart'; // Import ApiService
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'dart:convert'; // For JSON decoding

// --- Widget to represent the colored statistic cards ---
class QueueStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const QueueStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // The Expanded widget ensures equal width across all cards in the Row
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        // The AspectRatio widget ensures a consistent shape (width/height ratio)
        // You can adjust the ratio (e.g., 1.5, 1.2) to make the card taller/shorter.
        child: AspectRatio(
          aspectRatio: 1.2, // This sets the card height relative to its width
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Use spaceBetween to push the title to the bottom
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Icon and Value (aligned to the end)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: Colors.white, size: 36),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Bottom Text: Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- Main Screen Widget (Stateful) ---
// ----------------------------------------------------------------------
class GerenciamentoFilaScreen extends StatefulWidget {
  const GerenciamentoFilaScreen({super.key});

  @override
  State<GerenciamentoFilaScreen> createState() =>
      _GerenciamentoFilaScreenState();
}

class _GerenciamentoFilaScreenState extends State<GerenciamentoFilaScreen> {
  // State variable to manage the queue status
  bool _isQueueOpen = false;
  int _customersInAttendanceCount = 0;
  int _customersWaitingCount = 0;
  int _completedServicesCount = 0;
  int _noWaitServicesCount = 0;
  bool _isLoading = true;
  final ApiService _apiService = ApiService(); // Instantiate ApiService

  @override
  void initState() {
    super.initState();
    _fetchQueueStats();
  }

  void _toggleQueueStatus() {
    setState(() {
      _isQueueOpen = !_isQueueOpen;
    });
  }

  Future<void> _fetchQueueStats() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        if (mounted) {
          // context.go('/');
        }
        return;
      }

      final stats = await _apiService.fetchQueueStats(token);
      setState(() {
        _customersInAttendanceCount = stats.inAttendanceCount;
        _customersWaitingCount = stats.waitingCount;
        _completedServicesCount = stats.completedCount;
        _noWaitServicesCount = stats.noWaitCount;
      });
    } catch (e) {
      print('Error fetching queue stats: $e');
      if (e.toString().contains('Unauthorized')) {
        _logout();
      }
      setState(() {
        _customersInAttendanceCount = 0;
        _customersWaitingCount = 0;
        _completedServicesCount = 0;
        _noWaitServicesCount = 0;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Placeholder for a logout function, if not already defined in a parent widget or service
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // Clear the token
    if (mounted) {
      // Navigate to login screen, assuming '/' is the login route
      // This might need to be adjusted based on your GoRouter setup
      Navigator.of(context).popUntil((route) => route.isFirst); // Clear navigation stack
      // context.go('/'); // Or use GoRouter if available and appropriate
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine button text and color based on state
    final buttonText = _isQueueOpen
        ? 'Encerrar Atendimento'
        : 'Iniciar Atendimento';
    final buttonColor = _isQueueOpen ? Colors.red.shade600 : Colors.lightGreen;
    final statusMessage = _isQueueOpen
        ? 'A fila de atendimento está aberta e você está pronto para atender.'
        : 'A fila de atendimento está fechada para você e novos pacientes não estão sendo convocados.';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Notification/Alert Banner
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.orange),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'A fila está liberada para receber novos pacientes. Para bloquear o entrada de pacientes na fila, desabilite o parâmetro Direciona Atendimentos de Saúde para Plataforma Própria através do botão de configuração de fluxo de atendimentos.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- 4 Statistic Cards (Row) ---
          Row(
            children: [
              QueueStatCard(
                title: 'EM ATENDIMENTO',
                value: _isLoading
                    ? '...'
                    : _customersInAttendanceCount.toString(),
                color: Colors.deepPurple,
                icon: Icons.person,
              ),
              SizedBox(width: 15),
              QueueStatCard(
                title: 'AGUARDANDO ATENDIMENTO',
                value: _isLoading
                    ? '...'
                    : _customersWaitingCount.toString(),
                color: Colors.blue,
                icon: Icons.access_time_filled,
              ),
              SizedBox(width: 15),
              QueueStatCard(
                title: 'ATENDIMENTOS REALIZADOS',
                value: _isLoading
                    ? '...'
                    : _completedServicesCount.toString(),
                color: Colors.green,
                icon: Icons.thumb_up,
              ),
              SizedBox(width: 15),
              QueueStatCard(
                title: 'ABANDONOS DE FILA',
                value: _isLoading
                    ? '...'
                    : _noWaitServicesCount.toString(),
                color: Colors.grey, // Adjusted shade for visibility
                icon: Icons.arrow_downward,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- Status and Start Queue Button ---
          Center(
            child: Column(
              children: [
                Text(
                  'Última atualização: 29/10/2025, às 13:36:29',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 10),
                Text(statusMessage, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _toggleQueueStatus,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // --- "Fila de Atendimento" (Service Queue) Table/List ---
          const Text(
            'Fila de Atendimento',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Example of the first DataTable in the screenshot
          const Text(
            'Atendimentos em Andamento (Em Atendimento)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: double.infinity,
            child: PaginatedDataTable(
              header: const Text(''), // Hide header if not needed
              rowsPerPage: 5,
              columns: const [
                DataColumn(label: Text('Início do Atendimento')),
                DataColumn(label: Text('Situação')),
                DataColumn(label: Text('Paciente')),
                DataColumn(label: Text('Profissional de Saúde')),
              ],
              source: _ServiceQueueDataSource(),
            ),
          ),

          const SizedBox(height: 30),

          // Example of the second DataTable in the screenshot
          const Text(
            'Pacientes na Fila (Aguardando Atendimento)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: double.infinity,
            child: PaginatedDataTable(
              header: const Text(''), // Hide header if not needed
              rowsPerPage: 5,
              columns: const [
                DataColumn(label: Text('Posição')),
                DataColumn(label: Text('Entrada na Fila')),
                DataColumn(label: Text('Situação')),
                DataColumn(label: Text('Paciente')),
              ],
              source: _WaitingQueueDataSource(),
            ),
          ),
        ],
      ),
    );
  }
}

// --- DataTableSource for the "Atendimentos em Andamento" (First Table) ---
class _ServiceQueueDataSource extends DataTableSource {
  final List<Map<String, String>> _data = [
    {
      'start': '29/10/2025 13:32',
      'status': 'Em Atendimento',
      'patient': 'Ana Maria da Rocha Santos Araújo',
      'doctor': 'Francisco José de Oliveira Santos Neto',
    },
    {
      'start': '29/10/2025 13:33',
      'status': 'Em Atendimento',
      'patient': 'Alessandra Alves dos Santos',
      'doctor': 'LEONARDO PEREIRA SANTOS',
    },
    {
      'start': '29/10/2025 13:33',
      'status': 'Em Atendimento',
      'patient': 'Francisca Carraro',
      'doctor': 'CAROLINA DA SILVA PINTO MARTINS',
    },
    {
      'start': '29/10/2025 13:33',
      'status': 'Em Atendimento',
      'patient': 'Fernanda Felix de lima',
      'doctor': 'Epitácio Martins de Sá Neto',
    },
    {
      'start': '29/10/2025 13:34',
      'status': 'Em Atendimento',
      'patient': 'Ednaldo Antonio da Silva neto',
      'doctor': 'Pedro Ernesto Nascimento Vargas Fernandes',
    },
    {
      'start': '29/10/2025 13:35',
      'status': 'Em Atendimento',
      'patient': 'Lucia Helena Rosa de Oliveira',
      'doctor': 'AILSON CARVALHO FEITOSA FILHO',
    },
  ];

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final item = _data[index];

    // Helper widget for the status cell
    Widget statusChip(String text) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.shade100, // Light blue background
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue.shade800,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return DataRow(
      cells: [
        DataCell(Text(item['start']!)),
        DataCell(statusChip(item['status']!)),
        DataCell(Text(item['patient']!)),
        DataCell(Text(item['doctor']!)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
}

// --- DataTableSource for the "Pacientes na Fila" (Second Table) ---
class _WaitingQueueDataSource extends DataTableSource {
  final List<Map<String, String>> _data = [
    {
      'position': '1º',
      'time': '29/10/2025 13:35',
      'status': 'Aguardando Atendimento\nOn-line',
      'patient': 'SIMONI TEIXEIRA MIRANDA',
    },
    {
      'position': '2º',
      'time': '29/10/2025 13:35',
      'status': 'Aguardando Atendimento\nOn-line',
      'patient': 'Edmilson barroso Araújo junior',
    },
    {
      'position': '3º',
      'time': '29/10/2025 13:35',
      'status': 'Aguardando Atendimento\nOn-line',
      'patient': 'FLAVIA ROBERTA DE ANDRADE',
    },
    {
      'position': '4º',
      'time': '29/10/2025 13:36',
      'status': 'Aguardando Atendimento\nOn-line',
      'patient': 'Ana atalia marques da silva',
    },
  ];

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final item = _data[index];

    // Helper widget for the status cell
    Widget statusChip(String text) {
      final parts = text.split('\n');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              parts[0],
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade100, // Light green for 'On-line'
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              parts.length > 1 ? parts[1] : '',
              style: TextStyle(
                color: Colors.green.shade800,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
              const SizedBox(width: 5),
              Text(item['position']!),
            ],
          ),
        ),
        DataCell(Text(item['time']!)),
        DataCell(statusChip(item['status']!)),
        DataCell(Text(item['patient']!)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
}

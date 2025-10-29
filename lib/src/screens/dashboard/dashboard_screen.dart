import 'package:flutter/material.dart';

// --- 1. Data Model for Indicator Cards ---
class DashboardCardData {
  final IconData icon;
  final String title;
  final String? value;
  final String actionText;
  final Color color;

  DashboardCardData({
    required this.icon,
    required this.title,
    this.value,
    required this.actionText,
    required this.color,
  });
}

// --- 2. Custom Indicator Card Widget ---
class IndicatorCard extends StatelessWidget {
  final DashboardCardData data;
  final double cardWidth;

  const IndicatorCard({super.key, required this.data, required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.all(8.0),
      // Card appearance: rounded corners and a distinct background color
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: data.color.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // Optional: Add a subtle ripple effect on tap
          onTap: () {
            // Implement navigation or action logic here
            debugPrint('Action tapped for: ${data.title}');
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section: Icon, Title, and Value
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and title block
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(data.icon, color: Colors.white, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            data.title,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Value (if available) - positioned higher for balance
                if (data.value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      data.value!,
                      style: TextStyle(
                        color: data.color == Colors.amber[600]
                            ? Colors.black
                            : Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const SizedBox(height: 40), // Placeholder space for alignment
                // Bottom section: Action link
                Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        data.actionText,
                        style: TextStyle(
                          color: data.color == Colors.amber[600]
                              ? Colors.black87
                              : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: data.color == Colors.amber[600]
                            ? Colors.black87
                            : Colors.white,
                        size: 12,
                      ),
                    ],
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

// --- 3. Main Dashboard Screen (Now StatefulWidget) ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Data for all the indicator cards
  static final List<DashboardCardData> _cardData = [
    DashboardCardData(
      icon: Icons.local_hospital,
      title: 'PRONTO ATENDIMENTO',
      actionText: 'Entrar na Fila',
      color: Colors.red.shade700,
    ),
    DashboardCardData(
      icon: Icons.check_circle,
      title: 'MINHA AGENDA',
      actionText: 'Entrar',
      color: Colors.blue.shade700,
    ),
    DashboardCardData(
      icon: Icons.group,
      title: 'MÉDICOS',
      value: '0',
      actionText: 'Ver Indicados',
      color: Colors.deepPurple.shade700,
    ),
    DashboardCardData(
      icon: Icons.favorite,
      title: 'PACIENTES',
      value: '0',
      actionText: 'Ver Indicados',
      color: Colors.orange.shade700,
    ),
    DashboardCardData(
      icon: Icons.attach_money,
      title: 'SALDO DISPONÍVEL',
      value: 'R\$ 2.145,00',
      actionText: 'Ver Extrato',
      color: Colors.green.shade700,
    ),
    DashboardCardData(
      icon: Icons.notifications,
      title: 'ALERTAS',
      value: '0',
      actionText: '', // No action text visible in screenshot for this one
      color: Colors.amber.shade600,
    ),

    // Second Row
    DashboardCardData(
      icon: Icons.access_alarm,
      title: 'PRONTUÁRIOS',
      actionText: 'Acessar',
      color: Colors.blue.shade900, // Darker blue/teal
    ),
    DashboardCardData(
      icon: Icons.groups,
      title: 'ATENDIMENTOS DIÁRIOS',
      value: '21',
      actionText: 'Ver Atendimentos',
      color: Colors.green.shade600, // Light Green/Teal
    ),
    DashboardCardData(
      icon: Icons.groups,
      title: 'ATENDIMENTOS MENSAIS',
      value: '180',
      actionText: 'Ver Atendimentos',
      color: Colors.cyan.shade600, // Cyan
    ),
    DashboardCardData(
      icon: Icons.star,
      title: 'MINHA AVALIAÇÃO',
      value: '10,00',
      actionText: 'Ver Avaliações',
      color: Colors.purple.shade700,
    ),
    DashboardCardData(
      icon: Icons.access_time,
      title: 'TEMPO EM CONSULTA',
      value: '5,0 min',
      actionText: 'Ver Atendimentos',
      color: Colors.lightBlue.shade500,
    ),
    DashboardCardData(
      icon: Icons.calendar_today,
      title: 'ATIVAÇÃO',
      value: 'Indeterminado',
      actionText: 'Minha Conta',
      color: Colors.blueGrey.shade700, // Dark Grey/Blue
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the width for a single card.
    // We aim for 6 cards across on large screens (e.g., > 1200px)
    // and let it wrap naturally on smaller screens.
    final screenWidth = MediaQuery.of(context).size.width;
    // Base card width for desktop-like view (6 columns)
    final double baseCardWidth = screenWidth > 1200 ? screenWidth / 6.5 : 200;

    // We removed the Scaffold and AppBar, returning the content directly
    return Container(
      // The background color is now set on this top-level Container
      color: const Color(0xFFF0F2F5),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- A. Main Indicator Cards Grid (Wrap for Responsiveness) ---
              Wrap(
                spacing: 8.0, // horizontal gap
                runSpacing: 8.0, // vertical gap
                alignment: WrapAlignment.start,
                children: _cardData.map((data) {
                  return IndicatorCard(data: data, cardWidth: baseCardWidth);
                }).toList(),
              ),
              const SizedBox(height: 32),

              // --- B. 'CLUBE' Section ---
              _buildClubCard(),
              const SizedBox(height: 48),

              // --- C. Referral Links Section ---
              const Center(
                child: Text(
                  'Meus Links de Indicação',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: _buildReferralLinkCard(context)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for the 'CLUBE' Card
  Widget _buildClubCard() {
    return Container(
      width: 300, // Fixed width for this single element
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 8),
              const Text(
                'CLUBE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade500,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Situação: Ativo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios, size: 12),
            label: const Text('Acessar Clube'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for the Referral Links Card
  Widget _buildReferralLinkCard(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'LINKS DE INDICAÇÃO PARA NOVOS MÉDICOS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          // Link display box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey.shade200),
            ),
            child: const Text(
              'https://cliente.doutorbeneficios.com/cadastro-medico/cmf6fe9s',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 16),
          // Buttons Row
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // In a real app, you would use Clipboard.setData
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Link Copiado!')),
                  );
                },
                icon: const Icon(Icons.copy, size: 20),
                label: const Text('Copiar Link'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gerar QR Code... (Ação)')),
                  );
                },
                icon: const Icon(Icons.qr_code, size: 20),
                label: const Text('Gerar QR Code'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.blueGrey.shade200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

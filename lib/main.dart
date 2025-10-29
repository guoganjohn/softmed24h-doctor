import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h_admin/src/screens/dashboard/dashboard_screen.dart';
import 'package:softmed24h_admin/src/screens/layout_screen.dart'; // Import LayoutScreen
import 'package:softmed24h_admin/src/screens/login/login_screen.dart';
import 'package:softmed24h_admin/src/screens/meumed_academy/material_apoio_screen.dart';
import 'package:softmed24h_admin/src/screens/meumed_academy/treinamentos_screen.dart';
import 'package:softmed24h_admin/src/screens/meumed_academy/videos_tutoriais_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/minhas_informacoes_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/meus_documentos_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/minha_senha_screen.dart';
import 'package:softmed24h_admin/src/screens/minha_conta/meus_comunicados_screen.dart';
import 'package:softmed24h_admin/src/screens/financeiro/extrato_financeiro_screen.dart';
import 'package:softmed24h_admin/src/screens/financeiro/meus_saques_screen.dart';
import 'package:softmed24h_admin/src/screens/financeiro/meus_cartoes_screen.dart';
import 'package:softmed24h_admin/src/screens/telemedicina/gerenciamento_fila_screen.dart'; // Import GerenciamentoFilaScreen
import 'package:url_strategy/url_strategy.dart'; // Import url_strategy

void main() {
  setPathUrlStrategy(); // Call setPathUrlStrategy
  runApp(const MyApp());
}

/// The route configuration.

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',

      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(child: LoginScreen());
      },
    ),

    GoRoute(
      path: '/dashboard',

      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
          child: LayoutScreen(body: DashboardScreen()),
        );
      },

      routes: <RouteBase>[
        GoRoute(
          path: 'meumed-academy/videos-tutoriais',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: VideosTutoriaisScreen()),
            );
          },
        ),

        GoRoute(
          path: 'meumed-academy/treinamentos',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: TreinamentosScreen()),
            );
          },
        ),

        GoRoute(
          path: 'meumed-academy/material-apoio',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: MaterialApoioScreen()),
            );
          },
        ),

        // Minha Conta sub-menus
        GoRoute(
          path: 'minha-conta/minhas-informacoes',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: MinhasInformacoesScreen()),
            );
          },
        ),

        GoRoute(
          path: 'minha-conta/meus-documentos',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: MeusDocumentosScreen()),
            );
          },
        ),

        GoRoute(
          path: 'minha-conta/minha-senha',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: MinhaSenhaScreen()),
            );
          },
        ),

        GoRoute(
          path: 'minha-conta/meus-comunicados',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: MeusComunicadosScreen()),
            );
          },
        ),

        // Financeiro sub-menus
        GoRoute(
          path: 'financeiro/extrato-financeiro',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: ExtratoFinanceiroScreen()),
            );
          },
        ),

        GoRoute(
          path: 'financeiro/meus-saques',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: MeusSaquesScreen()),
            );
          },
        ),

        GoRoute(
          path: 'financeiro/meus-cartoes',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: MeusCartoesScreen()),
            );
          },
        ),

        // Telemedicina sub-menus
        GoRoute(
          path: 'telemedicina/gerenciamento-fila',

          pageBuilder: (BuildContext context, GoRouterState state) {
            return const NoTransitionPage(
              child: LayoutScreen(body: GerenciamentoFilaScreen()),
            );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget é a raiz da sua aplicação.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Demonstração Flutter',
      theme: ThemeData(
        // Este é o tema da sua aplicação.
        //
        // EXPERIMENTE: Tente executar sua aplicação com "flutter run". Você verá
        // que a aplicação tem uma barra de ferramentas roxa. Em seguida, sem sair do aplicativo,
        // tente mudar a cor inicial no colorScheme abaixo para Colors.green
        // e então invoque "hot reload" (salve suas alterações ou pressione o botão "hot"
        // reload" em um IDE compatível com Flutter, ou pressione "r" se você usou
        // a linha de comando para iniciar o aplicativo).
        //
        // Observe que o contador não foi redefinido para zero; o estado da aplicação
        // não é perdido durante o recarregamento. Para redefinir o estado, use hot
        // restart em vez disso.
        //
        // Isso funciona para código também, não apenas valores: A maioria das alterações de código pode ser
        // testada com apenas um hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}

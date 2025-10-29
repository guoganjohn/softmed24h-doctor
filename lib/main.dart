import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h_admin/src/screens/login/login_screen.dart';
import 'package:softmed24h_admin/src/screens/dashboard/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardScreen();
      },
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


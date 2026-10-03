

import 'package:ad_galaad_app/main.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
//import 'package:ad_galaad_app/views/main_navigation_view.dart'; // Tu pantalla principal

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    // Reemplaza la pantalla de bienvenida por la pantalla principal
    Navigator.of(context).pushReplacement(
      FluentPageRoute(
        builder: (context) => const MainPage(), // Tu página principal
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FluentTheme(
      data: FluentThemeData.dark(), // O la configuración de tu tema
      child: ScaffoldPage(
        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animación de la paloma
              Lottie.asset(
                'assets/animations/flame.json',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
                controller: _controller,
                onLoaded: (composition) {
                  // Configura la duración del controlador según el archivo JSON
                  _controller.duration = composition.duration;
                  
                  // Inicia la animación y al terminar navega a la pantalla principal
                  _controller.forward().then((_) {
                    _navigateToHome();
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Asamblea de Dios Galaad',
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 48.0,
                  fontWeight: FontWeight.w600,
                ),
                /*
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),*/
              ),
            ],
          ),
        ),
      ),
    );
  }
}
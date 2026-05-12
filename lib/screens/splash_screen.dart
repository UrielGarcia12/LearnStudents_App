// screens/splash_screen.dart
import 'onboarding_screen.dart';
import 'package:flutter/material.dart';
import '../ui/colors.dart';
import '../ui/responsive.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _introCtrl;
  late AnimationController _progressCtrl;
  late AnimationController _exitCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _subtitleFade;
  late Animation<Offset> _subtitleSlide;

  // Para el exit: el fondo sube y se convierte en el banner del login
  late Animation<double> _bgScale;
  late Animation<double> _bgFade;

  @override
  void initState() {
    super.initState();

    _introCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.0, 0.30, curve: Curves.easeIn),
      ),
    );
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.50, 0.85, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.50, 0.85, curve: Curves.easeOutBack),
    ));

    _bgScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );
    _bgFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitCtrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _introCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 950));
    _progressCtrl.forward();

    // Espera que la barra termine
    await Future.delayed(const Duration(milliseconds: 1900));
    if (!mounted) return;

    // Animación de salida suave antes de navegar
    _exitCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (context, animation, _, child) {
          // Curva muy suave tipo "ease in out quint"
          final curved = CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 1.0,
                curve: Curves.easeInOutCubicEmphasized),
          );
          final fade = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
          ));
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _introCtrl.dispose();
    _progressCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashLogoW = Responsive.splashLogoWidth(context);

    return Scaffold(
      backgroundColor: AppColors.bgSplash,
      body: AnimatedBuilder(
        animation: _exitCtrl,
        builder: (_, child) => FadeTransition(
          opacity: _bgFade,
          child: ScaleTransition(scale: _bgScale, child: child),
        ),
        child: Stack(
          children: [
            // Blob morado
            Positioned(
              top: -80, right: -80,
              child: _Blob(
                color: AppColors.primaryPurple.withOpacity(0.35),
                size: 300,
              ),
            ),
            // Blob naranja
            Positioned(
              bottom: -100, left: -60,
              child: _Blob(
                color: AppColors.primaryOrange.withOpacity(0.22),
                size: 340,
              ),
            ),
            // Blob centro
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.05,
              child: _Blob(
                color: AppColors.primaryPurple.withOpacity(0.08),
                size: 220,
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo con Hero
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Hero(
                        tag: 'app_logo',
                        flightShuttleBuilder:
                            (_, anim, __, ___, ____) {
                          // Vuelo muy suave
                          final smoothAnim = CurvedAnimation(
                            parent: anim,
                            curve: Curves.easeInOutCubicEmphasized,
                          );
                          return ScaleTransition(
                            scale: Tween<double>(
                                    begin: 1.0, end: 0.6)
                                .animate(smoothAnim),
                            child: Image.asset(
                              'assets/Titulo.png',
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/Titulo.png',
                          width: splashLogoW,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 56),

                  // Texto + barra
                  AnimatedBuilder(
                    animation: _progressCtrl,
                    builder: (_, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80),
                        child: Column(
                          children: [
                            SlideTransition(
                              position: _subtitleSlide,
                              child: FadeTransition(
                                opacity: _subtitleFade,
                                child: Text(
                                  _loadingText(
                                      _progressCtrl.value),
                                  style: TextStyle(
                                    color: Colors.white
                                        .withOpacity(0.55),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Barra
                            Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor:
                                      _progressCtrl.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                      gradient:
                                          const LinearGradient(
                                        colors: [
                                          AppColors.primaryPurple,
                                          AppColors.primaryOrange,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _loadingText(double p) {
    if (p < 0.35) return "INICIANDO...";
    if (p < 0.75) return "CARGANDO...";
    return "¡LISTO!";
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
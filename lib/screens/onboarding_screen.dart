// screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../ui/colors.dart';
import '../ui/responsive.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _ctrl;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _bodyFade;
  late Animation<Offset> _bodySlide;
  late Animation<double> _btn1Scale;
  late Animation<double> _btn2Fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Logo entra primero con elastic
    _logoFade = _f(0.00, 0.25);
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.00, 0.50, curve: Curves.elasticOut),
      ),
    );

    _titleFade  = _f(0.30, 0.58);
    _titleSlide = _sY(0.30, 0.60);
    _bodyFade   = _f(0.45, 0.72);
    _bodySlide  = _sY(0.45, 0.72);
    _btn1Scale  = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.60, 0.88, curve: Curves.elasticOut),
      ),
    );
    _btn2Fade = _f(0.75, 1.00);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  Animation<double> _f(double s, double e) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _ctrl,
              curve: Interval(s, e, curve: Curves.easeOut)));

  Animation<Offset> _sY(double s, double e) =>
      Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
          .animate(CurvedAnimation(parent: _ctrl,
          curve: Interval(s, e, curve: Curves.easeOutBack)));

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) {
          final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: anim,
                  curve: const Interval(0.1, 1.0, curve: Curves.easeOut)));
          final slide = Tween<Offset>(
              begin: const Offset(0, 0.05), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim,
              curve: Curves.easeInOutCubicEmphasized));
          return FadeTransition(opacity: fade,
              child: SlideTransition(position: slide, child: child));
        },
      ),
    );
  }

  void _showSocialSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'cerrar',
      barrierColor: Colors.black.withOpacity(0.55),
      transitionDuration: const Duration(milliseconds: 650),
      pageBuilder: (_, __, ___) => const _SocialSheet(),
      transitionBuilder: (ctx, anim, secAnim, child) {
        // Entrada: elastic bounce desde abajo
        // Salida: ease in hacia abajo
        final slideIn = Tween<Offset>(
          begin: const Offset(0, 1.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: anim,
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInCubic,
        ));

        final fadeBarrier = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
          parent: anim,
          curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
          reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
        ));

        return FadeTransition(
          opacity: fadeBarrier,
          child: SlideTransition(position: slideIn, child: child),
        );
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hPad = Responsive.hPad(context);
    final logoW = Responsive.logoWidth(context) * 1.3;

    return Scaffold(
      backgroundColor: const Color(0xFF170D30),
      body: Stack(
        children: [
          // ── Blob top-right ──
          Positioned(
            top: -size.height * 0.12,
            right: -size.width * 0.2,
            child: _Blob(
                color: AppColors.primaryPurple.withOpacity(0.28),
                size: size.width * 0.75),
          ),
          // ── Blob bottom-left ──
          Positioned(
            bottom: -size.height * 0.12,
            left: -size.width * 0.25,
            child: _Blob(
                color: AppColors.primaryOrange.withOpacity(0.15),
                size: size.width * 0.90),
          ),

          // ── Contenido ──
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: Responsive.contentWidth(context)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // ── LOGO con Hero (vuela desde splash) ──
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Hero(
                            tag: 'app_logo',
                            flightShuttleBuilder:
                                (_, anim, __, ___, ____) {
                              final curved = CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeInOutCubicEmphasized,
                              );
                              return ScaleTransition(
                                scale: Tween<double>(begin: 1.0, end: 0.75)
                                    .animate(curved),
                                child: Image.asset('assets/Titulo.png',
                                    fit: BoxFit.contain),
                              );
                            },
                            child: Image.asset('assets/Titulo.png',
                                width: logoW),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── TÍTULO ──
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Text(
                            "¡Tu viaje de aprendizaje\ncomienza aquí!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  Responsive.titleSize(context) + 6,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFD2BBFF),
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── DESCRIPCIÓN ──
                      FadeTransition(
                        opacity: _bodyFade,
                        child: SlideTransition(
                          position: _bodySlide,
                          child: const Text(
                            "Alcanza tus metas académicas con el poder de la IA, rutinas inteligentes y el apoyo de tus amigos. Aprender nunca fue tan divertido.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFCCC3D8),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // ── BOTÓN PRIMARIO ──
                      ScaleTransition(
                        scale: _btn1Scale,
                        child: _PrimaryButton(
                          label: "Empezar",
                          icon: Icons.rocket_launch_rounded,
                          onTap: _goToLogin,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── BOTÓN SECUNDARIO: Conócenos ──
                      FadeTransition(
                        opacity: _btn2Fade,
                        child: _SecondaryButton(
                          label: "Conócenos",
                          icon: Icons.explore_rounded,
                          onTap: _showSocialSheet,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// BOTTOM SHEET SOCIAL (con damping/bounce)
// ══════════════════════════════════════════════

class _SocialSheet extends StatelessWidget {
  const _SocialSheet();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
          decoration: const BoxDecoration(
            color: Color(0xFF23193D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A4455),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 24),

              // Título
              const Text(
                "Síguenos",
                style: TextStyle(
                  color: Color(0xFFD2BBFF),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Pronto publicaremos contenido increíble.\n¡Sé el primero en enterarte!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF9B8FBB),
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              // Redes sociales
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _SocialIcon(
      icon: Icons.facebook,
      label: "Facebook",
      color: const Color(0xFF1877F2),
      bgColor: const Color(0xFF1877F2).withOpacity(0.15),
      onTap: () {},
    ),
    _SocialIcon(
      icon: Icons.camera_alt_rounded,
      label: "Instagram",
      color: const Color(0xFFE1306C),
      bgColor: const Color(0xFFE1306C).withOpacity(0.15),
      onTap: () {},
    ),
    _SocialIcon(
      icon: Icons.play_circle_fill,
      label: "YouTube",
      color: const Color(0xFFFF0000),
      bgColor: const Color(0xFFFF0000).withOpacity(0.15),
      onTap: () {},
    ),
  ],
),

              const SizedBox(height: 32),

              // Botón cerrar
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2448),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF4A4455), width: 1.5),
                  ),
                  child: const Text(
                    "Cerrar",
                    style: TextStyle(
                      color: Color(0xFFCCC3D8),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 140));
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: widget.bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: widget.color.withOpacity(0.30), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.20),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(widget.icon, color: widget.color, size: 30),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(
                color: Color(0xFF9B8FBB),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════
// WIDGETS GENERALES
// ══════════════════════════════

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryButton(
      {required this.label, required this.icon, required this.onTap});
  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: EdgeInsets.only(top: _pressed ? 4 : 0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFD2BBFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _pressed
              ? []
              : [
                  const BoxShadow(
                    color: Color(0xFF25005A),
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Color(0xFF3F008E),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            Icon(widget.icon, color: const Color(0xFF3F008E), size: 20),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SecondaryButton(
      {required this.label, required this.icon, required this.onTap});
  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        margin: EdgeInsets.only(top: _pressed ? 4 : 0),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2448),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _pressed
              ? []
              : [
                  const BoxShadow(
                    color: Color(0xFF392F53),
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: Color(0xFFE9DDFF),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 10),
            Icon(widget.icon,
                color: const Color(0xFFCCC3D8), size: 20),
          ],
        ),
      ),
    );
  }
}
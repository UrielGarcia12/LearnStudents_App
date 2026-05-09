// screens/login_screen.dart
import 'package:flutter/material.dart';
import '../ui/colors.dart';
import '../ui/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  late Animation<double> _avatarFade;
  late Animation<double> _avatarScale;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _s1Fade;
  late Animation<Offset> _s1Slide;
  late Animation<double> _s2Fade;
  late Animation<Offset> _s2Slide;
  late Animation<double> _divFade;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;
  late Animation<double> _btnScale;
  late Animation<double> _botFade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _avatarFade  = _f(0.00, 0.28);
    _avatarScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl,
          curve: const Interval(0.05, 0.48,
              curve: Curves.elasticOut)));

    _titleFade  = _f(0.22, 0.48);
    _titleSlide = _sY(0.22, 0.52);

    _s1Fade  = _f(0.32, 0.58);
    _s1Slide = _sX(0.32, 0.60, begin: -0.45);

    _s2Fade  = _f(0.40, 0.65);
    _s2Slide = _sX(0.40, 0.67, begin: -0.45);

    _divFade  = _f(0.50, 0.70);
    _formFade  = _f(0.55, 0.78);
    _formSlide = _sY(0.55, 0.80);

    _btnScale = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl,
          curve: const Interval(0.65, 0.92,
              curve: Curves.elasticOut)));

    _botFade = _f(0.78, 1.00);

    Future.delayed(const Duration(milliseconds: 380), () {
      if (mounted) _ctrl.forward();
    });
  }

  Animation<double> _f(double s, double e) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _ctrl,
          curve: Interval(s, e, curve: Curves.easeOut)));

  Animation<Offset> _sY(double s, double e, {double begin = 0.4}) =>
      Tween<Offset>(
              begin: Offset(0, begin), end: Offset.zero)
          .animate(CurvedAnimation(
              parent: _ctrl,
              curve: Interval(s, e, curve: Curves.easeOutBack)));

  Animation<Offset> _sX(double s, double e,
          {double begin = 0.4}) =>
      Tween<Offset>(
              begin: Offset(begin, 0), end: Offset.zero)
          .animate(CurvedAnimation(
              parent: _ctrl,
              curve: Interval(s, e, curve: Curves.easeOutBack)));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxW    = Responsive.contentWidth(context);
    final hPad    = Responsive.hPad(context);
    final isWide  = !Responsive.isMobile(context);
    final headerH = Responsive.headerHeight(context);
    final avatarS = Responsive.avatarSize(context);
    final logoW   = Responsive.logoWidth(context);
    final titleSz = Responsive.titleSize(context);

    Widget content = Column(
      children: [

        // ── HEADER ──
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: double.infinity,
              height: headerH,
              decoration: BoxDecoration(
                color: AppColors.bgSplash,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(44),
                  bottomRight: Radius.circular(44),
                ),
              ),
              child: Stack(children: [
                // Blobs decorativos
                Positioned(top: -40, right: -40,
                  child: _Blob(AppColors.primaryPurple.withOpacity(0.30), 170)),
                Positioned(bottom: -20, left: -30,
                  child: _Blob(AppColors.primaryOrange.withOpacity(0.20), 130)),

                // Logo Hero centrado en el banner
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Hero(
                      tag: 'app_logo',
                      flightShuttleBuilder: (_, anim, __, ___, ____) {
                        final curved = CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeInOutCubicEmphasized,
                        );
                        return ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 0.58)
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
              ]),
            ),

            // Avatar
            Positioned(
              bottom: -(avatarS / 2),
              child: FadeTransition(
                opacity: _avatarFade,
                child: ScaleTransition(
                  scale: _avatarScale,
                  child: Container(
                    width: avatarS,
                    height: avatarS,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEDE8FF),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.28),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/avatarHombre.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: avatarS / 2 + 16),

        // ── TÍTULO ──
        FadeTransition(
          opacity: _titleFade,
          child: SlideTransition(
            position: _titleSlide,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Column(children: [
                Text(
                  "Obtendrás una experiencia personalizada",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWide ? 14 : 13,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Inicia sesión y\nempieza a aprender",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSz + 4, // más grande
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                    height: 1.15,
                  ),
                ),
              ]),
            ),
          ),
        ),

        const SizedBox(height: 30),

        // ── BOTONES SOCIALES ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Column(children: [
            FadeTransition(
              opacity: _s1Fade,
              child: SlideTransition(
                position: _s1Slide,
                child: _SocialButton(
                  label: "Continuar con Google",
                  icon: Icons.g_mobiledata_rounded,
                  iconColor: const Color(0xFFDB4437),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeTransition(
              opacity: _s2Fade,
              child: SlideTransition(
                position: _s2Slide,
                child: _SocialButton(
                  label: "Continuar con Facebook",
                  icon: Icons.facebook_rounded,
                  iconColor: const Color(0xFF1877F2),
                ),
              ),
            ),
          ]),
        ),

        const SizedBox(height: 24),

        // ── DIVIDER ──
        FadeTransition(
          opacity: _divFade,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Row(children: [
              const Expanded(child: Divider(
                  thickness: 1.5, color: Color(0xFFE0D9F5))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text("o",
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    )),
              ),
              const Expanded(child: Divider(
                  thickness: 1.5, color: Color(0xFFE0D9F5))),
            ]),
          ),
        ),

        const SizedBox(height: 24),

        // ── FORM ──
        FadeTransition(
          opacity: _formFade,
          child: SlideTransition(
            position: _formSlide,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Column(children: [
                _DuoInput(
                    hint: "Correo o usuario",
                    icon: Icons.person_outline_rounded),
                const SizedBox(height: 12),
                _DuoInput(
                    hint: "Contraseña",
                    icon: Icons.lock_outline_rounded,
                    obscure: true),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      )),
                ),
              ]),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── BOTÓN PRINCIPAL ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: ScaleTransition(
            scale: _btnScale,
            child: _MainButton(
              label: "INICIAR SESIÓN",
              onTap: () {},
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ── LINK INFERIOR ──
        FadeTransition(
          opacity: _botFade,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: RichText(
              text: TextSpan(
                text: "¿No tienes cuenta? ",
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                children: const [
                  TextSpan(
                    text: "Regístrate",
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════
// WIDGETS
// ══════════════════════════════

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob(this.color, this.size);
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

class _SocialButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
  });
  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _lift;
  late Animation<double> _shadow;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _lift = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
    _shadow = Tween<double>(begin: 4, end: 14).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: GestureDetector(
        onTapDown: (_) => _hoverCtrl.forward(),
        onTapUp: (_) => _hoverCtrl.reverse(),
        onTapCancel: () => _hoverCtrl.reverse(),
        onTap: () {},
        child: AnimatedBuilder(
          animation: _hoverCtrl,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _lift.value),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFE5DFF5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.03 + _hoverCtrl.value * 0.05),
                    blurRadius: _shadow.value,
                    offset: Offset(0, _shadow.value * 0.4),
                  ),
                ],
              ),
              child: child,
            ),
          ),
          child: Row(children: [
            Icon(widget.icon, color: widget.iconColor, size: 26),
            const SizedBox(width: 14),
            Text(widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textDark,
                )),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textMuted),
          ]),
        ),
      ),
    );
  }
}

class _DuoInput extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool obscure;
  const _DuoInput(
      {required this.hint, required this.icon, this.obscure = false});
  @override
  State<_DuoInput> createState() => _DuoInputState();
}

class _DuoInputState extends State<_DuoInput>
    with SingleTickerProviderStateMixin {
  bool _focused = false;
  late AnimationController _focusCtrl;
  late Animation<double> _borderGlow;

  @override
  void initState() {
    super.initState();
    _focusCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _borderGlow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _focusCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _focusCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) {
        setState(() => _focused = f);
        f ? _focusCtrl.forward() : _focusCtrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _borderGlow,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple
                    .withOpacity(0.15 * _borderGlow.value),
                blurRadius: 14 * _borderGlow.value,
                offset: Offset(0, 4 * _borderGlow.value),
              ),
            ],
          ),
          child: child,
        ),
        child: TextField(
          obscureText: widget.obscure,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600),
            prefixIcon: Icon(widget.icon,
                color: _focused
                    ? AppColors.primaryPurple
                    : AppColors.textMuted),
            filled: true,
            fillColor: _focused
                ? const Color(0xFFF0EBFF)
                : const Color(0xFFF5F3FF),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: Color(0xFFE5DFF5), width: 1.5)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: AppColors.primaryPurple, width: 2)),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 18, horizontal: 16),
          ),
        ),
      ),
    );
  }
}

class _MainButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _MainButton({required this.label, required this.onTap});
  @override
  State<_MainButton> createState() => _MainButtonState();
}

class _MainButtonState extends State<_MainButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _lift;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _lift = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
    _glow = Tween<double>(begin: 0.45, end: 0.70).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _hoverCtrl.forward(),
        onTapUp: (_) {
          _hoverCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _hoverCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _hoverCtrl,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _lift.value),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryPurple,
                    AppColors.primaryOrange,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple
                        .withOpacity(_glow.value),
                    blurRadius: 20 + _hoverCtrl.value * 8,
                    offset: Offset(0, 6 + _hoverCtrl.value * 2),
                  ),
                ],
              ),
              child: child,
            ),
          ),
          child: const Center(
            child: Text(
              "INICIAR SESIÓN",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
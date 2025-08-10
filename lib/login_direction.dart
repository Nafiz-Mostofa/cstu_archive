import 'dart:ui';
import 'package:flutter/material.dart';
import 'login.dart';
import 'admin_login.dart';

class LoginDirectionPage extends StatelessWidget {
  const LoginDirectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Back disabled
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "LOGIN PANEL",
            style: TextStyle(color:Colors.white ,fontWeight: FontWeight.w700, letterSpacing: 0.5),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: _GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _Header(),
                  const SizedBox(height: 24),
                  _AnimatedPrimaryButton(
                    icon: Icons.admin_panel_settings_rounded,
                    label: "Admin Login",
                    color: const Color(0xFFFFA726),
                    onTap: () {
                      _pushWithTransition(context, const AdminLoginPage());
                    },
                  ),
                  const SizedBox(height: 14),
                  _AnimatedPrimaryButton(
                    icon: Icons.person_rounded,
                    label: "Student Login",
                    color: const Color(0xFF42A5F5),
                    onTap: () {
                      _pushWithTransition(context, const LoginPage());
                    },
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Smooth slide+fade transition
  static Future<void> _pushWithTransition(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, animation, secondaryAnimation) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.0, 0.04), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: page,
          ),
        ),
      ),
    );
  }
}

/// Premium “glass” card container
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 24,
                  spreadRadius: -4,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Title + subtitle header
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.school_rounded, size: 58, color: Colors.white),
        SizedBox(height: 12),
        Text(
          "CSTU Archive",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6),
        Text(
          "Choose your login type",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// Press animation + subtle shimmer
class _AnimatedPrimaryButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedPrimaryButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<_AnimatedPrimaryButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late final AnimationController _shineCtrl =
  AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
    ..repeat();

  @override
  void dispose() {
    _shineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.white;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Button body
            Container(
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.color, widget.color.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.35),
                    blurRadius: 24,
                    spreadRadius: -2,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: base, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: base,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            // Subtle animated shine
            AnimatedBuilder(
              animation: _shineCtrl,
              builder: (context, _) {
                final t = _shineCtrl.value;
                return Transform.translate(
                  offset: Offset(260 * (t - 0.5), 0),
                  child: Container(
                    width: 50,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.18),
                          Colors.white.withOpacity(0.0),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

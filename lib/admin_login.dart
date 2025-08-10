import 'dart:ui';
import 'package:flutter/material.dart';
import 'admin_signup.dart';
import 'admin_forgot_password.dart';
import 'admin_panel.dart';
import '../services/admin_auth_service.dart';
import 'login_direction.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage>
    with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  Future<void> loginAdmin() async {
    if (isLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    final response = await AdminAuthService.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );
    setState(() => isLoading = false);
    if (!mounted) return;
    if (response['success'] == true) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, a, __) => FadeTransition(
            opacity: CurvedAnimation(parent: a, curve: Curves.easeOutCubic),
            child: const AdminPanelPage(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Login failed')),
      );
    }
  }

  Future<bool> _onWillPop() async => false;

  @override
  Widget build(BuildContext context) {
    final kb = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "ADMIN LOGIN",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.5),
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
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    kb > 0 ? kb + 16 : 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 20),
                    child: Center(
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        offset: kb > 0 ? const Offset(0, -0.06) : Offset.zero,
                        child: _GlassCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const _Header(),
                              const SizedBox(height: 16),
                              _LabeledField(
                                label: "Username",
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: usernameController,
                                  textInputAction: TextInputAction.next,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: "Enter username",
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              _LabeledField(
                                label: "Password",
                                child: TextField(
                                  controller: passwordController,
                                  style: const TextStyle(color: Colors.white),
                                  obscureText: obscure,
                                  decoration: InputDecoration(
                                    hintText: "Enter password",
                                    hintStyle: const TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() => obscure = !obscure),
                                      icon: Icon(
                                        obscure ? Icons.visibility_off : Icons.visibility,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) => loginAdmin(),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _AnimatedPrimaryButton(
                                icon: Icons.login_rounded,
                                label: isLoading ? "Signing in..." : "Login",
                                color: const Color(0xFF42A5F5),
                                busy: isLoading,
                                onTap: loginAdmin,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _pushWithTransition(context, const AdminForgotPasswordPage());
                                    },
                                    child: const Text("Forgot Password?", style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text("•", style: TextStyle(color: Colors.white70)),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      _pushWithTransition(context, const AdminSignupPage());
                                    },
                                    child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white24, height: 22),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 300),
                                      pageBuilder: (_, a, __) => FadeTransition(
                                        opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
                                        child: const LoginDirectionPage(),
                                      ),
                                    ),
                                        (route) => false,
                                  );
                                },
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                label: const Text(
                                  "Back to Login Selection",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> _pushWithTransition(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, animation, __) => FadeTransition(
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

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final maxW = screenW - 32; // padding 16+16 বাদ
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW.clamp(0, 520)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
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
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.admin_panel_settings_rounded, size: 56, color: Colors.white),
        SizedBox(height: 10),
        Text(
          "CSTU Archive",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6),
        Text(
          "Sign in to your admin account",
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

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _AnimatedPrimaryButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool busy;

  const _AnimatedPrimaryButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.busy = false,
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
    final base = Colors.white;
    final radius = 14.0;
    const h = 54.0;
    const shineW = 48.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTap: widget.busy ? () {} : widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth == double.infinity
                ? MediaQuery.of(context).size.width
                : constraints.maxWidth;
            final travel = (w - shineW).clamp(0, w); // নিরাপদ ট্রান্সলেট

            return ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.color, widget.color.withOpacity(0.85)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(radius),
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
                        if (!widget.busy) ...[
                          Icon(widget.icon, color: base, size: 22),
                          const SizedBox(width: 10),
                        ],
                        widget.busy
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : Text(
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
                  if (!widget.busy)
                    AnimatedBuilder(
                      animation: _shineCtrl,
                      builder: (context, _) {
                        final t = _shineCtrl.value; // 0..1
                        final dx = travel * t - (shineW / 2);
                        return Transform.translate(
                          offset: Offset(dx, 0),
                          child: Container(
                            width: shineW,
                            height: h,
                            decoration: BoxDecoration(
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
            );
          },
        ),
      ),
    );
  }
}


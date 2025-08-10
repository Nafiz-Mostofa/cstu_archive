import 'dart:ui';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'signup.dart';
import 'forgot_password.dart';
import 'login_direction.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscure = true;

  Future<void> loginUser() async {
    if (isLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    final response = await AuthService.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (!mounted) return;
    if (response['success'] == true) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 320),
          pageBuilder: (_, a, __) => FadeTransition(
            opacity: CurvedAnimation(parent: a, curve: Curves.easeOutCubic),
            child: HomePage(username: usernameController.text.trim()),
          ),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Login failed')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (_, a, __) => FadeTransition(
          opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
          child: const LoginDirectionPage(),
        ),
      ),
    );
    return false;
  }

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
            "STUDENT LOGIN",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.5),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
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
                  padding: EdgeInsets.fromLTRB(16, 24, 16, kb > 0 ? kb + 16 : 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
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
                              const SizedBox(height: 20),
                              _LabeledField(
                                label: "Username",
                                child: TextField(
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
                              const SizedBox(height: 12),
                              _LabeledField(
                                label: "Password",
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: obscure,
                                  style: const TextStyle(color: Colors.white),
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
                                ),
                              ),
                              const SizedBox(height: 18),
                              _AnimatedPrimaryButton(
                                icon: Icons.login_rounded,
                                label: isLoading ? "Signing in..." : "Login",
                                color: const Color(0xFF42A5F5),
                                busy: isLoading,
                                onTap: loginUser,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _push(context, const ForgotPasswordPage());
                                    },
                                    child: const Text("Forgot Password?", style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text("•", style: TextStyle(color: Colors.white70)),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: () {
                                      _push(context, const SignupPage());
                                    },
                                    child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Divider(color: Colors.white24, height: 22),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(milliseconds: 280),
                                      pageBuilder: (_, a, __) => FadeTransition(
                                        opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
                                        child: const LoginDirectionPage(),
                                      ),
                                    ),
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

  static void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, a, __) => FadeTransition(
          opacity: CurvedAnimation(parent: a, curve: Curves.easeOutCubic),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.0, 0.04), end: Offset.zero)
                .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
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
    final maxW = (screenW - 32).clamp(0.0, 520.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
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
        Icon(Icons.person, size: 56, color: Colors.white),
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
          "Sign in with your student account",
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
    const base = Colors.white;
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTap: widget.busy ? () {} : widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
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
                    style: const TextStyle(
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

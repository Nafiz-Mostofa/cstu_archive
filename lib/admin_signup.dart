import 'dart:ui';
import 'package:flutter/material.dart';
import 'admin_login.dart';
import '../services/admin_auth_service.dart';

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({super.key});

  @override
  State<AdminSignupPage> createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool obscurePass = true;
  bool obscureConfirm = true;

  Future<void> registerAdmin() async {
    final email = emailController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    final response =
    await AdminAuthService.signup(email, username, password, phone);
    setState(() => isLoading = false);
    if (!mounted) return;

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Registration successful")),
      );
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 280),
          pageBuilder: (_, a, __) => FadeTransition(
            opacity: CurvedAnimation(parent: a, curve: Curves.easeOutCubic),
            child: const AdminLoginPage(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kb = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "ADMIN SIGNUP",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  24,
                  16,
                  kb > 0 ? kb + 16 : 24,
                ),
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
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: "Email (must be pre-registered)",
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(hint: "Enter your email"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _LabeledField(
                              label: "Username",
                              child: TextField(
                                controller: usernameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(hint: "Choose a username"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _LabeledField(
                              label: "Password",
                              child: TextField(
                                controller: passwordController,
                                obscureText: obscurePass,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(
                                  hint: "Create a password",
                                  suffix: IconButton(
                                    onPressed: () =>
                                        setState(() => obscurePass = !obscurePass),
                                    icon: Icon(
                                      obscurePass
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _LabeledField(
                              label: "Confirm Password",
                              child: TextField(
                                controller: confirmPasswordController,
                                obscureText: obscureConfirm,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(
                                  hint: "Re-enter your password",
                                  suffix: IconButton(
                                    onPressed: () => setState(
                                            () => obscureConfirm = !obscureConfirm),
                                    icon: Icon(
                                      obscureConfirm
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _LabeledField(
                              label: "Phone Number",
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(
                                  hint: "Enter your phone number",
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _AnimatedPrimaryButton(
                              icon: Icons.app_registration_rounded,
                              label: isLoading ? "Registering..." : "Register",
                              color: const Color(0xFFFFA726),
                              busy: isLoading,
                              onTap: registerAdmin,
                              height: 48,
                            ),
                            const SizedBox(height: 6),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                    const Duration(milliseconds: 260),
                                    pageBuilder: (_, a, __) => FadeTransition(
                                      opacity: CurvedAnimation(
                                          parent: a, curve: Curves.easeOut),
                                      child: const AdminLoginPage(),
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Already have an account? Login",
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
    );
  }

  InputDecoration _fieldDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      suffixIcon: suffix,
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
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.22),
                    blurRadius: 18,
                    spreadRadius: -3,
                    offset: const Offset(0, 10),
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
        Icon(Icons.how_to_reg_rounded, size: 48, color: Colors.white),
        SizedBox(height: 8),
        Text(
          "Create Admin Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          "Use pre-registered email to complete signup",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
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
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              )),
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
  final double height;

  const _AnimatedPrimaryButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.busy = false,
    this.height = 54,
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
    final radius = 12.0;
    final h = widget.height;
    const shineW = 44.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.98),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTap: widget.busy ? () {} : widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth == double.infinity
                ? MediaQuery.of(context).size.width - 32
                : constraints.maxWidth;
            final travel = (w - shineW).clamp(0, w);

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
                          blurRadius: 20,
                          spreadRadius: -2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!widget.busy) ...[
                          Icon(widget.icon, color: base, size: 20),
                          const SizedBox(width: 8),
                        ],
                        widget.busy
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : Text(
                          widget.label,
                          style: const TextStyle(
                            color: base,
                            fontSize: 16,
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

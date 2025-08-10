import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final studentIdController = TextEditingController();
  final usernameController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  Future<void> resetPassword() async {
    final sid = studentIdController.text.trim();
    final uname = usernameController.text.trim();
    final newPass = newPasswordController.text.trim();

    if (sid.isEmpty || uname.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    final response = await AuthService.forgotPassword(sid, uname, newPass);

    setState(() => isLoading = false);

    if (!mounted) return;
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successful!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to reset password')),
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
          "RESET PASSWORD",
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
                            const SizedBox(height: 18),
                            _LabeledField(
                              label: "Student ID",
                              child: TextField(
                                controller: studentIdController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(
                                  hint: "Enter your student ID",
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: "Username",
                              child: TextField(
                                controller: usernameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(
                                  hint: "Enter your username",
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _LabeledField(
                              label: "New Password",
                              child: TextField(
                                controller: newPasswordController,
                                obscureText: obscure,
                                style: const TextStyle(color: Colors.white),
                                decoration: _fieldDecoration(
                                  hint: "Enter new password",
                                  suffix: IconButton(
                                    onPressed: () => setState(() => obscure = !obscure),
                                    icon: Icon(
                                      obscure ? Icons.visibility_off : Icons.visibility,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                onSubmitted: (_) => resetPassword(),
                              ),
                            ),
                            const SizedBox(height: 18),
                            _AnimatedPrimaryButton(
                              icon: Icons.lock_reset_rounded,
                              label: isLoading ? "Processing..." : "Reset Password",
                              color: const Color(0xFF42A5F5),
                              busy: isLoading,
                              onTap: resetPassword,
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
    return const InputDecoration().copyWith(
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
        Icon(Icons.password_rounded, size: 56, color: Colors.white),
        SizedBox(height: 10),
        Text(
          "Forgot your password?",
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
          "Verify ID & username to reset",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.5,
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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                fontSize: 12.5,
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

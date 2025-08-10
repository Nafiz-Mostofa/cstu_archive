import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  late String currentUsername;

  @override
  void initState() {
    super.initState();
    currentUsername = widget.username;

    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == "SystemNavigator.pop") {
        return null;
      }
    });

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final data = await AuthService.getUserDetails(currentUsername);

    if (data['success'] == true) {
      setState(() {
        userData = {
          "name": data['name'],
          "student_id": data['student_id'],
          "gp": data['gp'],
          "semester_credit": data['earned_credit'],
          "total_credit": data['total_credit'],
          "gpa": data['gpa'],
          "cgpa": data['cgpa'],
          "failed_subjects": data['failed_subjects'],
        };
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to fetch user data')),
        );
      }
    }
  }

  Future<bool> _onWillPop() async => false;

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Logout"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    }
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
            "Personal Information",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.4),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16, 20, 16, kb > 0 ? kb + 16 : 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 36),
                    child: Column(
                      children: [
                        _GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _Header(),
                              const SizedBox(height: 14),
                              _InfoRow(
                                icon: Icons.badge_outlined,
                                label: "Name",
                                value: _val(userData['name']),
                              ),
                              _InfoRow(
                                icon: Icons.perm_identity_rounded,
                                label: "Student ID",
                                value: _val(userData['student_id']),
                              ),
                              _InfoRow(
                                icon: Icons.star_rate_rounded,
                                label: "GP",
                                value: _val(userData['gp']),
                              ),
                              _InfoRow(
                                icon: Icons.menu_book_rounded,
                                label: "Semester Credit",
                                value: _val(userData['semester_credit']),
                              ),
                              _InfoRow(
                                icon: Icons.collections_bookmark_rounded,
                                label: "Total Credit",
                                value: _val(userData['total_credit']),
                              ),
                              _InfoRow(
                                icon: Icons.trending_up_rounded,
                                label: "GPA",
                                value: _val(userData['gpa']),
                              ),
                              _InfoRow(
                                icon: Icons.stacked_line_chart_rounded,
                                label: "CGPA",
                                value: _val(userData['cgpa']),
                              ),
                              _InfoRow(
                                icon: Icons.cancel_presentation_rounded,
                                label: "Failed Subjects",
                                value: _val(userData['failed_subjects']),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: _PrimaryButton(
                            color: Colors.redAccent,
                            icon: Icons.logout_rounded,
                            label: "Logout",
                            onTap: _confirmLogout,
                          ),
                        ),
                      ],
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

  String _val(dynamic v) => (v == null || (v is String && v.trim().isEmpty)) ? "Not Available" : v.toString();
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final maxW = (screenW - 32).clamp(0.0, 560.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withOpacity(0.16)),
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
        Icon(Icons.account_circle_rounded, size: 56, color: Colors.white),
        SizedBox(height: 8),
        Text(
          "Your Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Semester & academic overview",
          style: TextStyle(color: Colors.white70, fontSize: 13.5),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
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
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
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
                    blurRadius: 22,
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

import 'package:cstu_archive/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> filteredStudents = [];
  bool isLoading = true;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2/flutter_auth/get_all_students.php"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            students = List<Map<String, dynamic>>.from(data['students']);
            filteredStudents = students;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          _toast(data['message'] ?? 'No data found');
        }
      } else {
        setState(() => isLoading = false);
        _toast('Failed to fetch data');
      }
    } catch (_) {
      setState(() => isLoading = false);
      _toast('Network error');
    }
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AdminLoginPage()),
            (route) => false,
      );
    }
  }

  Future<bool> _onWillPop() async => false;

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    );
    final dark = ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: light,
        darkTheme: dark,
        home: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("Database",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700, letterSpacing: 0.5),),
              centerTitle: true,
              actions: [
                IconButton(
                  tooltip: 'Logout',
                  icon: const Icon(Icons.logout_rounded,color: Colors.white,),
                  onPressed: confirmLogout,
                ),
              ],
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: fetchStudents,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final s = filteredStudents[index];
                  return _GlassStudentCard(
                    student: s,
                    index: index,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphism + entrance animation
class _GlassStudentCard extends StatelessWidget {
  const _GlassStudentCard({required this.student, required this.index});

  final Map<String, dynamic> student;
  final int index;

  String _v(String key) => (student[key] ?? 'N/A').toString();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 20, end: 0),
      duration: Duration(milliseconds: 250 + (index % 6) * 30),
      curve: Curves.easeOutCubic,
      builder: (context, dy, child) {
        return Opacity(
          opacity: (20 - dy) / 20,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: child,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: avatar + name + id
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: cs.primaryContainer.withOpacity(0.9),
                      child: Text(
                        _initials(_v('student_name')),
                        style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _v('student_name'),
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.badge_outlined, size: 16, color: Colors.white70),
                              const SizedBox(width: 6),
                              Text(
                                _v('student_id'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.15), height: 1),

                // All attributes — one per row with icons
                const SizedBox(height: 10),
                _AttrRow(icon: Icons.alternate_email, label: 'Username', value: _v('username')),
                _AttrRow(icon: Icons.email_outlined, label: 'Email', value: _v('email')),
                _AttrRow(icon: Icons.analytics_outlined, label: 'GPA', value: _v('gpa')),
                _AttrRow(icon: Icons.stacked_bar_chart, label: 'CGPA', value: _v('cgpa')),
                _AttrRow(icon: Icons.school_outlined, label: 'GP', value: _v('gp')),
                _AttrRow(icon: Icons.calculate_outlined, label: 'Semester Credit', value: _v('semester_credit')),
                _AttrRow(icon: Icons.assessment_outlined, label: 'Total Credit', value: _v('total_credit')),
                _AttrRow(icon: Icons.error_outline, label: 'Failed Subjects', value: _v('failed_subjects')),
                _AttrRow(icon: Icons.playlist_add_check_outlined, label: 'Subjects to Register', value: _v('subjects_to_register')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

/// single attribute row with icon + label + value
class _AttrRow extends StatelessWidget {
  const _AttrRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Colors.white70,
      fontWeight: FontWeight.w700,
    );
    final valueStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 10),
          SizedBox(
            width: 150, // label column fixed width
            child: Text("$label:", style: labelStyle),
          ),
          Expanded(
            child: Text(value, style: valueStyle, softWrap: true),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/admin_service.dart';
import '../auth/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService _adminService = AdminService();

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _confirmDelete(String uid, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete User?", style: GoogleFonts.dmSerifText()),
        content: Text(
          "Are you sure you want to remove '$name'?\nThis will delete their account data, recipes, and saved items.\n\nNote: This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _deleteUser(uid);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(String uid) async {
    try {
      await _adminService.deleteUserData(uid);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User removed successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error removing user: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hardcoded admin email
    final adminEmail = "admin@chefup.com";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: GoogleFonts.dmSerifText(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User Management",
                style: GoogleFonts.dmSerifText(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _adminService.getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error loading users"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final users = snapshot.data ?? [];

                    if (users.isEmpty) {
                      return Center(child: Text("No users found"));
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final uid = user['uid'] as String;
                        final email = user['email'] as String? ?? "No Email";
                        final name = user['displayName'] as String? ?? "No Name";
                        
                        // Check if this is the admin user (prevent self-delete)
                        // In a real app we might check roles, but here we check the known email
                        final isAdmin = email == adminEmail;

                        return Card(
                          margin: EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF78A55A),
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : "?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              name,
                              style: GoogleFonts.dmSerifText(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(email),
                                Text(
                                  "UID: $uid",
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: isAdmin
                                ? Chip(
                                    label: Text("Admin"),
                                    backgroundColor: Colors.amber.withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: Colors.amber[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _confirmDelete(uid, name),
                                  ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

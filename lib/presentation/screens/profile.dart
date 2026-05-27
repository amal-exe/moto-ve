import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // You can now define variables here that can change
  String userName = "Name";
  String userEmail = "email";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Action for settings
            },
            icon:  Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFF071018),
              Color(0xFF0B1F2A),
              Color(0xFF12384A),
            ],
          ),
        ),
        child: Column(
          children: [
             SizedBox(height: 100),

            /// PROFILE IMAGE
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: const CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(''),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Logic to pick image
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration:  BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(Icons.edit, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),

             SizedBox(height: 16),

            /// USER INFO
            Text(
              userName,
              style:  TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              userEmail,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),

             SizedBox(height: 30),

            /// STATS SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn("Garage", "0"),
                _buildStatColumn("Trips", "0"),
                _buildStatColumn("Points", "0k"),
              ],
            ),

             SizedBox(height: 30),

            /// MENU LIST
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.only(top: 20),
                  children: [
                    _buildMenuTile(Icons.person_outline, "Account Details"),
                    _buildMenuTile(Icons.favorite_border, "My Favorites"),
                    _buildMenuTile(Icons.history, "Booking History"),
                    _buildMenuTile(Icons.payment, "Payment Methods"),
                    const Divider(color: Colors.white24),
                    _buildMenuTile(
                      Icons.logout,
                      "Logout",
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, {Color color = Colors.white}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 16),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white24,
      ),
      onTap: () {
        // Add navigation or setState logic here
      },
    );
  }
}
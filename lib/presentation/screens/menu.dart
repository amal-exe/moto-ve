import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moto_ve/presentation/screens/profile.dart';

import 'vehicle/home_page.dart';

class MenuPage extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const MenuPage({super.key, required this.isOpen, required this.onClose});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  Widget menuTile(
      IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 6,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "";

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // DARK OVERLAY
        if (widget.isOpen)
          GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

        // SLIDING MENU
        // SLIDING MENU
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: widget.isOpen ? 0 : -width * 0.80,
          top: 0,
          // REMOVED 'bottom' so the container can shrink to fit content

          child: Material(
            color: Colors.transparent,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
            clipBehavior: Clip.antiAlias,

            child: Container(
              width: width * 0.78,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),

              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),

                    /// PROFILE
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      capitalizeFirstLetter(
                        FirebaseAuth.instance.currentUser?.displayName ?? "User",
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
                        },
                        child: menuTile(Icons.person_outline, "Profile")),
                    menuTile(Icons.feedback_outlined, "Feedback"),
                    menuTile(Icons.description_outlined, "Terms & Conditions"),
                    menuTile(Icons.privacy_tip_outlined, "Privacy Policy"),
                    menuTile(Icons.phone_outlined, "Contact Us"),
                    menuTile(
                      Icons.logout,
                      "Logout",
                      onTap: () async {

                        await FirebaseAuth.instance.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  HomePage(),
                          ),
                              (route) => false,
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

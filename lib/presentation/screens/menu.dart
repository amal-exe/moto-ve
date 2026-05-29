import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_ve/presentation/screens/profile.dart';
import '../../widget/theme/theme_mode.dart';
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
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.045,
        vertical: width * 0.012,
      ),

      child: ListTile(
        contentPadding: EdgeInsets.zero,

        leading: Icon(icon, color: Colors.white, size: width < 400 ? 24 : 28),

        title: Text(
          title,

          style: TextStyle(
            color: Colors.white,

            fontSize: width < 400 ? 15 : 18,

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
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    return Stack(
      children: [
        /// DARK OVERLAY
        if (widget.isOpen)
          GestureDetector(
            onTap: widget.onClose,

            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

        /// MENU
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),

          curve: Curves.easeInOut,

          left: widget.isOpen ? 0 : -width * 0.80,

          top: 0,
          bottom: 0,

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
                color: Colors.black.withOpacity(0.92),

                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),

              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: height * 0.03),

                      /// PROFILE IMAGE
                      Center(
                        child: CircleAvatar(
                          radius: width < 400 ? 38 : 46,

                          backgroundColor: Colors.white,

                          child: Icon(
                            Icons.person,

                            size: width < 400 ? 38 : 48,

                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.018),

                      /// USERNAME
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          child: Text(
                            capitalizeFirstLetter(
                              FirebaseAuth.instance.currentUser?.displayName ??
                                  "User",
                            ),

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: TextStyle(
                              color: Colors.white,

                              fontSize: width < 400 ? 20 : 24,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.04),

                      /// MENU ITEMS
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (context) => const ProfilePage(),
                                    ),
                                  );
                                },

                                child: menuTile(
                                  context,
                                  Icons.person_outline,
                                  "Profile",
                                ),
                              ),

                              menuTile(
                                context,
                                Icons.feedback_outlined,
                                "Feedback",
                              ),

                              menuTile(
                                context,
                                Icons.description_outlined,
                                "Terms & Conditions",
                              ),

                              menuTile(
                                context,
                                Icons.privacy_tip_outlined,
                                "Privacy Policy",
                              ),

                              menuTile(
                                context,
                                Icons.phone_outlined,
                                "Contact Us",
                              ),

                              menuTile(

                                context,

                                Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Icons.light_mode
                                    : Icons.dark_mode,

                                Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? "Light Mode"
                                    : "Dark Mode",

                                onTap: () {

                                  context
                                      .read<ThemeCubit>()
                                      .toggleTheme();
                                },
                              ),

                              menuTile(
                                context,
                                Icons.logout,
                                "Logout",

                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();

                                  Navigator.pushAndRemoveUntil(
                                    context,

                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),

                                    (route) => false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

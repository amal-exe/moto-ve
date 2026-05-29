import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moto_ve/presentation/screens/recommendation/budget_page.dart';
import 'package:moto_ve/presentation/screens/vehicle/bike_page.dart';
import 'package:moto_ve/presentation/screens/vehicle/car_page.dart';
import 'package:moto_ve/presentation/screens/vehicle/evs_page.dart';
import '../../../bloc/favourite/favourite_bloc.dart';
import '../../../bloc/favourite/favourite_event.dart';
import '../../../bloc/favourite/favourite_state.dart';
import '../../../widget/carousel/home_carousel.dart';
import '../auth/register_page.dart';
import '../favourite/favourite_page.dart';
import '../menu.dart';
import 'detail_page.dart';
import 'explore_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {



  Widget premiumCategoryCard({
    required IconData icon,
    required String title,
    required Color glowColor,
    required VoidCallback onTap,
  }) {

    return LayoutBuilder(
      builder: (context, constraints) {

        final small = constraints.maxWidth < 125;

        return GestureDetector(
          onTap: onTap,

          child: Container(
            height: small ? 110 : 135,

            padding: EdgeInsets.symmetric(
              horizontal: small ? 8 : 14,
              vertical: small ? 8 : 14,
            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                small ? 18 : 24,
              ),

              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [
                  Color(0xFF07111F),
                  Color(0xFF0D1726),
                ],
              ),

              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.12),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.08),
                  blurRadius: small ? 14 : 22,
                  spreadRadius: 1,
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [

                /// ICON
                Container(
                  height: small ? 36 : 48,
                  width: small ? 36 : 48,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      colors: [
                        glowColor,
                        glowColor.withOpacity(0.65),
                      ],
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withOpacity(0.35),
                        blurRadius: small ? 10 : 18,
                      ),
                    ],
                  ),

                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: small ? 18 : 24,
                  ),
                ),

                /// TITLE
                Flexible(
                  child: Text(
                    title,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: small ? 13 : 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                /// ARROW
                Align(
                  alignment: Alignment.bottomRight,

                  child: Container(
                    height: small ? 26 : 34,
                    width: small ? 26 : 34,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white.withOpacity(0.05),

                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.10),
                      ),
                    ),

                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: glowColor,
                      size: small ? 14 : 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addToFavorites(Map<String, dynamic> item) {
    final alreadyExists = favoriteItems.any(
      (fav) => fav['name'] == item['name'],
    );

    setState(() {
      if (alreadyExists) {
        favoriteItems.removeWhere((fav) => fav['name'] == item['name']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("${item['name']} removed from favorites"),
          ),
        );
      } else {
        favoriteItems.add(item);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("${item['name']} added to favorites"),
          ),
        );
      }
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  String getFirstName() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.displayName == null) {
      return "Login/Register";
    }

    String firstName = user.displayName!.split(" ").first;

    return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "";

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// CHECK FAVORITE
  bool isFavorite(Map<String, dynamic> item) {
    return favoriteItems.any((fav) => fav['name'] == item['name']);
  }

  List<Map<String, dynamic>> favoriteItems = [];

  TextEditingController searchController = TextEditingController();

  String searchText = '';

  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor:
            Theme.of(context)
                .appBarTheme
                .backgroundColor,
            surfaceTintColor: Colors.transparent,

            leadingWidth: 68,

            leading: Padding(
              padding: const EdgeInsets.only(left: 12,right: 5),

              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isMenuOpen = true;
                  });
                },

                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    height: 44,
                    width: 44,

                    decoration: BoxDecoration(
                      color:
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color?.withOpacity(0.04),

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.12),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.08),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    ),

                    child:  Icon(
                      Icons.menu_rounded,
                      color:
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            titleSpacing: 0,

            title: LayoutBuilder(
              builder: (context, constraints) {
                final width = MediaQuery.of(context).size.width;

                return Row(
                  children: [
                    /// LOGO
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,

                        child: RichText(
                          overflow: TextOverflow.ellipsis,

                          text:  TextSpan(
                            children: [
                              TextSpan(
                                text: "Drive",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                  letterSpacing: 0.3,
                                ),
                              ),

                              const TextSpan(
                                text: "Wise",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF00E5FF),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (width > 360) const SizedBox(width: 6),
                  ],
                );
              },
            ),

            actions: [
              /// PROFILE BUTTON
              Container(
                constraints: BoxConstraints(
                  minWidth: 42,
                  maxWidth: MediaQuery.of(context).size.width * 0.28,
                ),

                margin: const EdgeInsets.only(right: 8),

                child: GestureDetector(
                  onTap: () {
                    if (FirebaseAuth.instance.currentUser == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    }
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.10),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.05),
                          blurRadius: 16,
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Container(
                          height: 28,
                          width: 28,

                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,

                            gradient: LinearGradient(
                              colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
                            ),
                          ),

                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),

                        const SizedBox(width: 6),

                        Flexible(
                          child: Text(
                            user == null
                                ? "Login"
                                : capitalizeFirstLetter(getFirstName()),

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style:  TextStyle(
                              color:
                              Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// FAVORITE BUTTON
              Padding(
                padding: const EdgeInsets.only(right: 12),

                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritePage(),
                      ),
                    );
                  },

                  child: Container(
                    height: 44,
                    width: 44,

                    decoration: BoxDecoration(
                      color:
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color?.withOpacity(0.04),

                      borderRadius: BorderRadius.circular(16),

                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.12),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.08),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFF00E5FF),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFF102532),

                    borderRadius: BorderRadius.circular(14),

                    border: Border.all(
                      color: const Color(0xFF26C6DA)
                          .withOpacity(0.12),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF26C6DA)
                            .withOpacity(0.08),

                        blurRadius: 18,
                      ),
                    ],
                  ),

                  child: TextField(
                    controller: searchController,

                    textInputAction: TextInputAction.search,

                    onSubmitted: (value) {

                      final query =
                      value.trim().toLowerCase();

                      if (query.isEmpty) return;

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => ExplorePage(
                            search: query,
                          ),
                        ),
                      );
                    },

                    style:  TextStyle(
                      color:
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),

                    cursorColor:
                    const Color(0xFF26C6DA),

                    decoration: const InputDecoration(

                      icon: Icon(
                        Icons.search,
                        color: Color(0xFF6FEFFF),
                      ),

                      hintText:
                      "Search cars, bikes, EVs...",

                      hintStyle: TextStyle(
                        color: Color(0xFF9EDAE2),
                        fontSize: 14,
                      ),

                      border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width < 400 ? 14 : 18,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width < 400 ? 22 : 28,
                    ),

                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,

                      colors: [
                        Color(0xFF08131F),
                        Color(0xFF0B1D2E),
                        Color(0xFF10293F),
                      ],
                    ),

                    border: Border.all(
                      color: Colors.cyanAccent.withOpacity(0.12),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.10),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 700;

                      return Stack(
                        children: [
                          /// CYAN GLOW
                          Positioned(
                            top: -40,
                            right: -20,

                            child: Container(
                              height: isMobile ? 100 : 140,
                              width: isMobile ? 100 : 140,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                color: Colors.cyanAccent.withOpacity(0.08),
                              ),
                            ),
                          ),

                          isMobile
                              /// MOBILE LAYOUT
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    /// IMAGE
                                    Center(
                                      child: Hero(
                                        tag: "hero_car",

                                        child: Image.asset(
                                          "assets/123456.png",

                                          fit: BoxFit.contain,

                                          height:
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width <
                                                  400
                                              ? 130
                                              : 160,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    /// TITLE
                                    Text(
                                      "Find Your\nNext Machine",

                                      style: TextStyle(
                                        color:
                                        Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,

                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                400
                                            ? 22
                                            : 28,

                                        height: 1.15,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.2,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    /// SUBTITLE
                                    Text(
                                      "Explore luxury cars, bikes & EVs with futuristic experiences.",

                                      style: TextStyle(
                                        color:
                                        Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color?.withOpacity(0.65),

                                        fontSize:
                                            MediaQuery.of(context).size.width <
                                                400
                                            ? 12
                                            : 13.5,

                                        height: 1.5,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),

                                    const SizedBox(height: 22),

                                    /// BUTTON
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BudgetPage(),
                                          ),
                                        );
                                      },

                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width <
                                                  400
                                              ? 14
                                              : 18,

                                          vertical:
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width <
                                                  400
                                              ? 12
                                              : 14,
                                        ),

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),

                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF00E5FF),
                                              Color(0xFF00B8D4),
                                            ],
                                          ),

                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.cyanAccent
                                                  .withOpacity(0.35),
                                              blurRadius: 18,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),

                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,

                                          children: [
                                            Text(
                                              "Explore Now",

                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,

                                                fontSize:
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width <
                                                        400
                                                    ? 12
                                                    : 14,
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            Container(
                                              height: 22,
                                              width: 22,

                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.12,
                                                ),
                                                shape: BoxShape.circle,
                                              ),

                                              child: const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.black,
                                                size: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              /// TABLET/DESKTOP LAYOUT
                              : Row(
                                  children: [
                                    /// LEFT CONTENT
                                    Expanded(
                                      flex: 6,

                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 10,
                                        ),

                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,

                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),

                                              decoration: BoxDecoration(
                                                color: Colors.cyanAccent
                                                    .withOpacity(0.12),

                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),

                                              child: const Text(
                                                "PREMIUM VEHICLES",

                                                style: TextStyle(
                                                  color: Color(0xFF00E5FF),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                             const Text(
                                              "Find Your\nNext Machine",

                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                height: 1.15,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.2,
                                              ),
                                            ),

                                            const SizedBox(height: 12),

                                            Text(
                                              "Explore luxury cars, bikes & EVs with futuristic experiences.",

                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.65,
                                                ),
                                                fontSize: 13.5,
                                                height: 1.5,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),

                                            const SizedBox(height: 24),

                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BudgetPage(),
                                                  ),
                                                );
                                              },

                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 14,
                                                    ),

                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(18),

                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFF00E5FF),
                                                          Color(0xFF00B8D4),
                                                        ],
                                                      ),
                                                ),

                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,

                                                  children: [
                                                    const Text(
                                                      "Explore Now",

                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                      ),
                                                    ),

                                                    const SizedBox(width: 10),

                                                    Container(
                                                      height: 24,
                                                      width: 24,

                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.12),
                                                        shape: BoxShape.circle,
                                                      ),

                                                      child: const Icon(
                                                        Icons
                                                            .arrow_forward_rounded,
                                                        color: Colors.black,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    /// RIGHT IMAGE
                                    Expanded(
                                      flex: 5,

                                      child: Hero(
                                        tag: "hero_car",

                                        child: Image.asset(
                                          "assets/123456.png",

                                          fit: BoxFit.contain,
                                          height: 180,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const HomeCarousel(),

                const SizedBox(height: 20),

                Row(
                  children: [

                    Expanded(
                      child: premiumCategoryCard(
                        icon: Icons.directions_car_filled_rounded,
                        title: "Cars",
                        glowColor: const Color(0xFF00E5FF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CarPage(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: premiumCategoryCard(
                        icon: Icons.two_wheeler_rounded,
                        title: "Bikes",
                        glowColor: const Color(0xFF00B8D4),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BikePage(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: premiumCategoryCard(
                        icon: Icons.electric_bolt_rounded,
                        title: "EVs",
                        glowColor: const Color(0xFF00F0FF),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EvPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                 Text(
                  'Category',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                    Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color,
                  ),
                ),

                const SizedBox(height: 20),

                 Text(
                  'Trending Bikes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                    Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 190,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('vehicle')
                        .where('category', isEqualTo: 'bike')
                        .where('isElectric', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No Bikes",
                            style: TextStyle(color:
                            Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;

                          data['id'] = docs[index].id;

                          return Stack(
                            children: [
                              /// CARD
                              Container(
                                width: 260,
                                margin: const EdgeInsets.only(right: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(carId: docs[index].id),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),

                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,

                                          colors: [
                                            Color(0xFF1A3442),
                                            Color(0xFF2D6075),
                                            Color(0xFF1C4253),
                                          ],
                                        ),

                                        border: Border.all(
                                          color: Colors.cyanAccent.withOpacity(0.10),
                                          width: 1,
                                        ),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.cyanAccent.withOpacity(0.08),
                                            blurRadius: 22,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            /// LEFT SIDE CONTENT
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  /// BRAND
                                                  Text(
                                                    data['brand'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),

                                                  SizedBox(height: 6),

                                                  /// NAME
                                                  Text(
                                                    data['name'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),

                                                  SizedBox(height: 10),

                                                  /// PRICE
                                                  Text(
                                                    "₹${data['price']} Lakh onwards",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 12,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 10),

                                                  /// FAVORITE BUTTON
                                                  BlocBuilder<
                                                    FavoriteBloc,
                                                    FavoriteState
                                                  >(
                                                    builder: (context, state) {
                                                      List<Map<String, dynamic>>
                                                      favoriteItems = [];

                                                      if (state
                                                          is FavoriteLoaded) {
                                                        favoriteItems =
                                                            state.favoriteItems;
                                                      }

                                                      final isFavorite =
                                                          favoriteItems.any(
                                                            (fav) =>
                                                                fav['name'] ==
                                                                data['name'],
                                                          );

                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (isFavorite) {
                                                            context
                                                                .read<
                                                                  FavoriteBloc
                                                                >()
                                                                .add(
                                                                  RemoveFavoriteEvent(
                                                                    data,
                                                                  ),
                                                                );
                                                          } else {
                                                            context
                                                                .read<
                                                                  FavoriteBloc
                                                                >()
                                                                .add(
                                                                  AddFavoriteEvent(
                                                                    data,
                                                                  ),
                                                                );
                                                          }
                                                        },

                                                        child: Icon(
                                                          isFavorite
                                                              ? Icons.favorite
                                                              : Icons
                                                                    .favorite_border,
                                                          color: Colors.red,
                                                          size: 22,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                              width: 140,
                                              child: Center(
                                                child: Image.network(
                                                  data['image'],
                                                  width: 140,
                                                  fit: BoxFit.contain,
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

                              /// RATING
                              Positioned(
                                top: 10,
                                right: 24,
                                child: Builder(
                                  builder: (context) {
                                    double rating =
                                        double.tryParse(
                                          data['rating'].toString(),
                                        ) ??
                                        0.0;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: rating < 4.0
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                           Icon(
                                            Icons.star,
                                            size: 10,
                                            color:
                                            Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            rating.toStringAsFixed(1),
                                            style: TextStyle(
                                              color:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'Explore Cars',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                    Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 190,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('vehicle')
                        .where('category', isEqualTo: 'car')
                        .where('isElectric', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return  Center(
                          child: Text(
                            "No Cars",
                            style: TextStyle(color:
                            Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;

                          data['id'] = docs[index].id;

                          return Stack(
                            children: [
                              /// CARD
                              Container(
                                width: 260,
                                margin: const EdgeInsets.only(right: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(carId: docs[index].id),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),

                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,

                                          colors: [
                                            Color(0xFF1A3442),
                                            Color(0xFF2D6075),
                                            Color(0xFF1C4253),
                                          ],
                                        ),

                                        border: Border.all(
                                          color: Colors.cyanAccent.withOpacity(0.10),
                                          width: 1,
                                        ),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.cyanAccent.withOpacity(0.08),
                                            blurRadius: 22,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            /// LEFT SIDE CONTENT
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  /// BRAND
                                                  Text(
                                                    data['brand'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),

                                                  SizedBox(height: 6),

                                                  /// NAME
                                                  Text(
                                                    data['name'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),

                                                  SizedBox(height: 10),

                                                  /// PRICE
                                                  Text(
                                                    "₹${data['price']} Lakh onwards",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                      fontSize: 12,
                                                    ),
                                                  ),

                                                  SizedBox(height: 10),

                                                  /// FAVORITE BUTTON
                                                  BlocBuilder<
                                                    FavoriteBloc,
                                                    FavoriteState
                                                  >(
                                                    builder: (context, state) {
                                                      List<Map<String, dynamic>>
                                                      favoriteItems = [];

                                                      if (state
                                                          is FavoriteLoaded) {
                                                        favoriteItems =
                                                            state.favoriteItems;
                                                      }

                                                      final isFavorite =
                                                          favoriteItems.any(
                                                            (fav) =>
                                                                fav['name'] ==
                                                                data['name'],
                                                          );

                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (isFavorite) {
                                                            context
                                                                .read<
                                                                  FavoriteBloc
                                                                >()
                                                                .add(
                                                                  RemoveFavoriteEvent(
                                                                    data,
                                                                  ),
                                                                );
                                                          } else {
                                                            context
                                                                .read<
                                                                  FavoriteBloc
                                                                >()
                                                                .add(
                                                                  AddFavoriteEvent(
                                                                    data,
                                                                  ),
                                                                );
                                                          }
                                                        },

                                                        child: Icon(
                                                          isFavorite
                                                              ? Icons.favorite
                                                              : Icons
                                                                    .favorite_border,
                                                          color: Colors.red,
                                                          size: 22,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// RIGHT SIDE IMAGE
                                            SizedBox(
                                              width: 140,
                                              child: Center(
                                                child: Image.network(
                                                  data['image'],
                                                  width: 140,
                                                  fit: BoxFit.contain,
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

                              /// RATING
                              Positioned(
                                top: 10,
                                right: 24,
                                child: Builder(
                                  builder: (context) {
                                    double rating =
                                        double.tryParse(
                                          data['rating'].toString(),
                                        ) ??
                                        0.0;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: rating < 4.0
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 10,
                                            color:
                                            Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            rating.toStringAsFixed(1),
                                            style: TextStyle(
                                              color:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'Explore EVs',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                    Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color,
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  height: 190,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('vehicle')
                        .where('isElectric', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return  Center(
                          child: Text(
                            "No EV's",
                            style: TextStyle(color:
                            Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;

                          data['id'] = docs[index].id;

                          return Stack(
                            children: [
                              /// CARD
                              Container(
                                width: 260,
                                margin: const EdgeInsets.only(right: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(carId: docs[index].id),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),

                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,

                                      colors: [
                                        Color(0xFF1A3442),
                                        Color(0xFF2D6075),
                                        Color(0xFF1C4253),
                                      ],
                                    ),

                                    border: Border.all(
                                      color: Colors.cyanAccent.withOpacity(0.10),
                                      width: 1,
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyanAccent.withOpacity(0.08),
                                        blurRadius: 22,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            /// LEFT SIDE CONTENT
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  /// BRAND
                                                  Text(
                                                    data['brand'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),

                                                  SizedBox(height: 6),

                                                  /// NAME
                                                  Text(
                                                    data['name'],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),

                                                  SizedBox(height: 10),

                                                  /// PRICE
                                                  Text(
                                                    "₹${data['price']} Lakh onwards",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                      fontSize: 12,
                                                    ),
                                                  ),

                                                  SizedBox(height: 10),

                                                  /// FAVORITE BUTTON
                                                  BlocBuilder<
                                                    FavoriteBloc,
                                                    FavoriteState
                                                  >(
                                                    builder: (context, state) {
                                                      List<Map<String, dynamic>>
                                                      favoriteItems = [];

                                                      if (state
                                                          is FavoriteLoaded) {
                                                        favoriteItems =
                                                            state.favoriteItems;
                                                      }

                                                      final isFavorite =
                                                          favoriteItems.any(
                                                            (fav) =>
                                                                fav['name'] ==
                                                                data['name'],
                                                          );

                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (isFavorite) {
                                                            context
                                                                .read<
                                                                  FavoriteBloc
                                                                >()
                                                                .add(
                                                                  RemoveFavoriteEvent(
                                                                    data,
                                                                  ),
                                                                );
                                                          } else {
                                                            context
                                                                .read<
                                                                  FavoriteBloc
                                                                >()
                                                                .add(
                                                                  AddFavoriteEvent(
                                                                    data,
                                                                  ),
                                                                );
                                                          }
                                                        },

                                                        child: Icon(
                                                          isFavorite
                                                              ? Icons.favorite
                                                              : Icons
                                                                    .favorite_border,
                                                          color: Colors.red,
                                                          size: 22,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// RIGHT SIDE IMAGE
                                            SizedBox(
                                              width: 140,
                                              child: Center(
                                                child: Image.network(
                                                  data['image'],
                                                  width: 140,
                                                  fit: BoxFit.contain,
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

                              /// RATING
                              Positioned(
                                top: 10,
                                right: 24,
                                child: Builder(
                                  builder: (context) {
                                    double rating =
                                        double.tryParse(
                                          data['rating'].toString(),
                                        ) ??
                                        0.0;

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: rating < 4.0
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 10,
                                            color:
                                            Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            rating.toStringAsFixed(1),
                                            style: TextStyle(
                                              color:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
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

        MenuPage(
          isOpen: isMenuOpen,
          onClose: () {
            setState(() {
              isMenuOpen = false;
            });
          },
        ),
      ],
    );
  }
}

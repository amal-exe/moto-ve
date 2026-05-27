import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_ve/presentation/screens/vehicle/detail_page.dart';
import 'package:moto_ve/presentation/screens/vehicle/home_page.dart';

import '../../../bloc/favourite/favourite_bloc.dart';
import '../../../bloc/favourite/favourite_event.dart';
import '../../../bloc/favourite/favourite_state.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {

          List<Map<String, dynamic>> favoriteItems = [];

          if (state is FavoriteLoaded) {
            favoriteItems = state.favoriteItems;
          }

          if (favoriteItems.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites Added",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteItems.length,

            itemBuilder: (context, index) {

              final data = favoriteItems[index];

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4B3AC7),
                      Color(0xFF24126A),
                    ],
                  ),
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          carId: data['id'],
                        ),
                      ),
                    );
                  },

                  /// IMAGE
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: data['image'] != null
                        ? Image.network(
                      data['image'],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,

                      errorBuilder:
                          (context, error, stackTrace) {

                        return Container(
                          width: 70,
                          height: 70,
                          color: Colors.black26,

                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                          ),
                        );
                      },
                    )

                        : Container(
                      width: 70,
                      height: 70,
                      color: Colors.black26,

                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /// NAME
                  title: Text(
                    data['name'] ?? "No Name",

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  /// PRICE
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),

                    child: Text(
                      "₹${data['price'] ?? 'N/A'} Lakh",

                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  /// DELETE
                  trailing: GestureDetector(
                    onTap: () {

                      context.read<FavoriteBloc>().add(
                        RemoveFavoriteEvent(data),
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
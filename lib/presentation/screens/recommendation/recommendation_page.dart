import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recommendation/recommendation_bloc.dart';
import '../../../bloc/recommendation/recommendation_event.dart';
import '../../../bloc/recommendation/recommendation_state.dart';
import '../../../data/models/user_preference.dart';
import '../vehicle/detail_page.dart';

class BestPickups extends StatelessWidget {
  final UserPreference userPreference;

  const BestPickups({super.key, required this.userPreference});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecommendationBloc()..add(FetchRecommendations(userPreference)),
      child: Scaffold(
        backgroundColor: const Color(0xFF071018),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          iconTheme: const IconThemeData(color: Color(0xFF6FEFFF)),

          leading: IconButton(
            onPressed: () => Navigator.pop(context),

            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6FEFFF)),
          ),

          title: const Text(
            "Recommended For You",

            style: TextStyle(
              color: Color(0xFF6FEFFF),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: BlocBuilder<RecommendationBloc, RecommendationState>(
          builder: (context, state) {
            if (state.status == RecommendationStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == RecommendationStatus.failure ||
                state.vehicles.isEmpty) {
              return const Center(
                child: Text(
                  "No recommendations found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) {
                final v = state.vehicles[index];
                final match = state.matchPercentages[v.id] ?? 0;

                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(carId: v.id)),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      Color(0xFF142D3A),
                      Color(0xFF1B5368),
                      Color(0xFF102733),
                    ],
                  ),

                  border: Border.all(
                    color: Color(0xFF00D9FF).withOpacity(0.18),
                    width: 1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00D9FF).withOpacity(0.12),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                    child: Row(
                      children: [
                        _VehicleThumbnail(imageUrl: v.image),
                        const SizedBox(width: 12),
                        _VehicleInfo(v: v, match: match),
                        _MatchCircle(match: match),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Sub-widgets for cleaner code
class _VehicleThumbnail extends StatelessWidget {
  final String imageUrl;
  const _VehicleThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF102532),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFF26C6DA).withOpacity(0.15),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 50,
          width: 50,

          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            scale: 4,

            errorBuilder: (_, __, ___) =>
            const Icon(
              Icons.image_not_supported,
              color: Colors.white54,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleInfo extends StatelessWidget {
  final dynamic v;
  final int match;
  const _VehicleInfo({required this.v, required this.match});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            v.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "₹${v.price} Lakh • ${v.power} HP",
            style: const TextStyle(color: Color(0xFFB8EAF2)),
          ),
          const SizedBox(height: 5),
          Text(
            "Match: $match%",
            style: const TextStyle(color: Color(0xFF6FEFFF)),
          ),
        ],
      ),
    );
  }
}

class _MatchCircle extends StatelessWidget {
  final int match;
  const _MatchCircle({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 52,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: const LinearGradient(
          colors: [
            Color(0xFF26C6DA),
            Color(0xFF00BCD4),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0xFF26C6DA).withOpacity(0.35),
            blurRadius: 18,
          ),
        ],
      ),

      child: Center(
        child: Text(
          "$match%",

          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

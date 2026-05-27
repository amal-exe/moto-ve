import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_ve/data/models/user_preference.dart';
import '../../../bloc/recommendation/recommendation_bloc.dart';
import '../../../bloc/recommendation/recommendation_event.dart';
import '../../../bloc/recommendation/recommendation_state.dart';
import '../recommendation/recommendation_page.dart'; // Ensure correct path

class PriorityPage extends StatelessWidget {
  const PriorityPage({super.key});

  final List<Map<String, dynamic>> options = const [
    {
      "title": "Mileage",
      "subtitle": "Get best fuel efficiency",
      "icon": Icons.local_gas_station,
    },
    {
      "title": "Power / Performance",
      "subtitle": "More power and speed",
      "icon": Icons.speed,
    },
    {
      "title": "Features",
      "subtitle": "High tech and safety",
      "icon": Icons.star_outline,
    },
    {
      "title": "Low Maintenance",
      "subtitle": "Reliability over long term",
      "icon": Icons.build_circle_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<PreferenceBloc, PreferenceState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "Step 4 of 4",
                      style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "What matters most\nto you?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = state.priority == option["title"];

                        return GestureDetector(
                          onTap: () {
                            context.read<PreferenceBloc>().add(UpdatePriority(option["title"]) as PreferenceEvent);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1F2E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.cyanAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(option["icon"], color: Colors.white70),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option["title"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        option["subtitle"],
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(Icons.check_circle, color: Colors.cyanAccent),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// Finish Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Create the final UserPreference from the current Bloc state
                        final finalPreference = UserPreference(
                          budget: state.budget.toInt(),
                          usage: state.usage,
                          type: state.vehicleType,
                          priority: state.priority,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BestPickups(userPreference: finalPreference),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Finish",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
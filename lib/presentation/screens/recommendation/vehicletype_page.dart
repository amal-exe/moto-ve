import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/recommendation/recommendation_bloc.dart';
import '../../../bloc/recommendation/recommendation_event.dart';
import '../../../bloc/recommendation/recommendation_state.dart';
import 'priority_page.dart'; // Import your Step 4 page

class VehicleTypePage extends StatelessWidget {
  const VehicleTypePage({super.key});

  final List<Map<String, dynamic>> options = const [
    {"title": "SUV", "subtitle": "Spacious and powerful", "icon": Icons.directions_car_filled},
    {"title": "Sedan", "subtitle": "Comfort and style", "icon": Icons.directions_car},
    {"title": "Hatchback", "subtitle": "Compact and efficient", "icon": Icons.time_to_leave},
    {"title": "Bike", "subtitle": "Two wheelers", "icon": Icons.two_wheeler},
    {"title": "EV", "subtitle": "Electric vehicles", "icon": Icons.electric_car},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<PreferenceBloc, PreferenceState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "Step 3 of 4",
                      style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "What type of vehicle do you prefer?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Options list
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = state.vehicleType == option["title"];

                        return GestureDetector(
                          onTap: () {
                            context.read<PreferenceBloc>().add(UpdateVehicleType(option["title"]));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141A2E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Colors.cyanAccent : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(option["icon"], color: Colors.white, size: 26),
                                const SizedBox(width: 15),
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
                                        style: TextStyle(color: Colors.grey[400], fontSize: 13),
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

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PriorityPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
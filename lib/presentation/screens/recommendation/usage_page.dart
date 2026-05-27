import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_ve/presentation/screens/recommendation/vehicletype_page.dart';
import '../../../bloc/recommendation/recommendation_bloc.dart';
import '../../../bloc/recommendation/recommendation_event.dart';
import '../../../bloc/recommendation/recommendation_state.dart';

class UsagePage extends StatelessWidget {
  const UsagePage({super.key});

  final List<Map<String, dynamic>> options = const [
    {"title": "City Driving", "subtitle": "Mostly in city", "icon": Icons.directions_car},
    {"title": "Highway Driving", "subtitle": "Mostly on highways", "icon": Icons.alt_route},
    {"title": "Both", "subtitle": "Mix of city and highway", "icon": Icons.motorcycle},
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
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const _StepCounter(current: 2, total: 4),
                  const SizedBox(height: 20),
                  const Text(
                    "How do you mostly use your vehicle?",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Options List
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = state.usage == option["title"];

                        return GestureDetector(
                          onTap: () => context.read<PreferenceBloc>().add(UpdateUsage(option["title"]) as PreferenceEvent),
                          child: _UsageOptionCard(
                            option: option,
                            isSelected: isSelected,
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
                            MaterialPageRoute(builder: (context) =>  VehicleTypePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.black)),
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

class _StepCounter extends StatelessWidget {
  final int current, total;
  const _StepCounter({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Step $current of $total",
        style: const TextStyle(color: Colors.cyanAccent, fontSize: 14),
      ),
    );
  }
}

class _UsageOptionCard extends StatelessWidget {
  final Map<String, dynamic> option;
  final bool isSelected;

  const _UsageOptionCard({required this.option, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
          Icon(option["icon"], color: Colors.white, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option["title"], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(option["subtitle"], style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              ],
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle, color: Colors.cyanAccent)
        ],
      ),
    );
  }
}
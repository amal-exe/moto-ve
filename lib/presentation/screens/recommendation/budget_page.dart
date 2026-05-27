import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_ve/presentation/screens/recommendation/usage_page.dart';

import '../../../bloc/recommendation/recommendation_bloc.dart';
import '../../../bloc/recommendation/recommendation_event.dart';
import '../../../bloc/recommendation/recommendation_state.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  // Extracted currency formatter for cleaner code
  String _formatCurrency(double value) {
    int val = value.toInt();
    String s = val.toString();
    if (s.length > 3) {
      String last3 = s.substring(s.length - 3);
      String rest = s.substring(0, s.length - 3);
      rest = rest.replaceAllMapped(RegExp(r'\B(?=(\d{2})+(?!\d))'), (match) => ',');
      return '₹$rest,$last3';
    }
    return '₹$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071018),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocBuilder<PreferenceBloc, PreferenceState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const _StepHeader(step: "1", totalSteps: "4", question: "What is your budget?"),
                  const SizedBox(height: 40),

                  // Display Value
                  Center(
                    child: Text(
                      _formatCurrency(state.budget),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF26C6DA),
                      inactiveTrackColor: const Color(0xFF102532),
                      thumbColor: const Color(0xFF6FEFFF),
                      overlayColor: const Color(0xFF26C6DA).withOpacity(0.2),
                    ),
                    child: Slider(
                      min: 100000,
                      max: 2500000,
                      divisions: 240,
                      value: state.budget,
                      onChanged: (val) => context.read<PreferenceBloc>().add(UpdateBudget(val) as PreferenceEvent),
                    ),
                  ),

                  const _MinMaxLabels(min: "₹1,00,000", max: "₹25,00,000"),
                  const Spacer(),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // In Step 2 (Usage), you will continue using the same Bloc instance
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  UsagePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF26C6DA),
                        shadowColor: const Color(0xFF26C6DA),
                        elevation: 12,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text("Next", style: TextStyle(fontSize: 16, color: Colors.black)),
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

// Reusable UI Components
class _StepHeader extends StatelessWidget {
  final String step, totalSteps, question;
  const _StepHeader({required this.step, required this.totalSteps, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text("Step $step of $totalSteps", style: const TextStyle(color: Colors.cyanAccent, fontSize: 14))),
        const SizedBox(height: 10),
        Center(child: Text(question, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
        const SizedBox(height: 6),
        const Center(child: Text("Select your budget range", style: TextStyle(color: Colors.white54, fontSize: 14))),
      ],
    );
  }
}

class _MinMaxLabels extends StatelessWidget {
  final String min, max;
  const _MinMaxLabels({required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(min, style: const TextStyle(color: Colors.white54)),
        Text(max, style: const TextStyle(color: Colors.white54)),
      ],
    );
  }
}
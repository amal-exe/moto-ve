import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/emi/emi_bloc.dart';
import '../../../bloc/emi/emi_event.dart';
import '../../../bloc/emi/emi_state.dart';

class EmiPage extends StatefulWidget {
  final double vehiclePrice;

  const EmiPage({
    super.key,
    required this.vehiclePrice,
  });

  @override
  State<EmiPage> createState() => _EmiPageState();
}

class _EmiPageState extends State<EmiPage> {

  late TextEditingController interestController;

  @override
  void initState() {
    super.initState();

    interestController =
        TextEditingController(text: "9");
  }

  @override
  void dispose() {
    interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double fullPrice =
        widget.vehiclePrice * 100000;

    final double minDP = fullPrice * 0.10;
    final double maxDP = fullPrice * 0.80;

    return BlocProvider(
      create: (context) =>
      EmiBloc(
        vehiclePrice: widget.vehiclePrice,
      )..add(
        CalculateEmiResult(9),
      ),

      child: Scaffold(
        backgroundColor: const Color(0xFF071018),

        appBar: AppBar(
          backgroundColor: const Color(0xFF071018),
          elevation: 0,

          iconTheme: const IconThemeData(
            color: Color(0xFF6FEFFF),
          ),

          title: const Text(
            "EMI Calculator",

            style: TextStyle(
              color: Color(0xFF6FEFFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: BlocBuilder<EmiBloc, EmiState>(
          builder: (context, state) {

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  _PriceCard(
                    price: widget.vehiclePrice,
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Down Payment: ₹ ${(state.downPayment / 1000).toStringAsFixed(0)}K",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Slider(
                    value: state.downPayment
                        .clamp(minDP, maxDP),

                    min: minDP,
                    max: maxDP,

                    activeColor:
                    const Color(0xFF26C6DA),

                    inactiveColor:
                    const Color(0xFF102532),

                    thumbColor:
                    const Color(0xFF6FEFFF),

                    onChanged: (val) {

                      context.read<EmiBloc>().add(
                        UpdateDownPayment(
                          (val / 1000).round() * 1000,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  _TenureSelector(
                    selectedYears: state.years,
                  ),

                  const SizedBox(height: 25),

                  TextField(
                    controller: interestController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    keyboardType:
                    TextInputType.number,

                    cursorColor:
                    const Color(0xFF26C6DA),

                    decoration: InputDecoration(
                      filled: true,

                      fillColor:
                      const Color(0xFF102532),

                      hintText: "Interest %",

                      hintStyle: const TextStyle(
                        color: Color(0xFF9EDAE2),
                      ),

                      enabledBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide: BorderSide(
                          color: const Color(
                              0xFF26C6DA)
                              .withOpacity(0.12),
                        ),
                      ),

                      focusedBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide: const BorderSide(
                          color: Color(0xFF26C6DA),
                        ),
                      ),

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _CalculateButton(
                    onPressed: () {

                      double rate =
                          double.tryParse(
                            interestController.text,
                          ) ??
                              9;

                      context.read<EmiBloc>().add(
                        CalculateEmiResult(rate),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  _ResultCard(
                    emi: state.emiResult,
                    months: state.years * 12,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PriceCard extends StatefulWidget {
  final double price;

  const _PriceCard({
    super.key,
    required this.price,
  });

  @override
  State<_PriceCard> createState() =>
      _PriceCardState();
}

class _PriceCardState
    extends State<_PriceCard> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

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
          color: const Color(0xFF00D9FF)
              .withOpacity(0.18),
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9FF)
                .withOpacity(0.12),

            blurRadius: 20,
            spreadRadius: 1,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Text(
        "₹ ${widget.price} Lakh",

        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TenureSelector extends StatefulWidget {
  final int selectedYears;

  const _TenureSelector({
    super.key,
    required this.selectedYears,
  });

  @override
  State<_TenureSelector> createState() =>
      _TenureSelectorState();
}

class _TenureSelectorState
    extends State<_TenureSelector> {

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [3, 5, 7].map((e) {

        bool selected =
            widget.selectedYears == e;

        return Expanded(
          child: GestureDetector(
            onTap: () {

              context.read<EmiBloc>().add(
                UpdateTenure(e),
              );
            },

            child: Container(
              margin: const EdgeInsets.all(6),

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(14),

                color: selected
                    ? null
                    : const Color(0xFF102532),

                gradient: selected
                    ? const LinearGradient(
                  colors: [
                    Color(0xFF26C6DA),
                    Color(0xFF1B5368),
                  ],
                )
                    : null,

                border: Border.all(
                  color: const Color(0xFF26C6DA)
                      .withOpacity(0.12),
                ),
              ),

              child: Center(
                child: Text(
                  "$e Years",

                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFFB8EAF2),

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CalculateButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _CalculateButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<_CalculateButton> createState() =>
      _CalculateButtonState();
}

class _CalculateButtonState
    extends State<_CalculateButton> {

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 52,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF26C6DA),

          foregroundColor: Colors.black,

          elevation: 12,

          shadowColor:
          const Color(0xFF26C6DA),

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),

        onPressed: widget.onPressed,

        child: const Text(
          "Calculate EMI",

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatefulWidget {
  final double emi;
  final int months;

  const _ResultCard({
    super.key,
    required this.emi,
    required this.months,
  });

  @override
  State<_ResultCard> createState() =>
      _ResultCardState();
}

class _ResultCardState
    extends State<_ResultCard> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

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
          color: const Color(0xFF00D9FF)
              .withOpacity(0.18),
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9FF)
                .withOpacity(0.12),

            blurRadius: 20,
            spreadRadius: 1,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [

          const Text(
            "Monthly EMI",

            style: TextStyle(
              color: Color(0xFFB8EAF2),
            ),
          ),

          Text(
            "₹ ${widget.emi.toInt()}",

            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Total: ${widget.months} months",

            style: const TextStyle(
              color: Color(0xFF9EDAE2),
            ),
          ),
        ],
      ),
    );
  }
}
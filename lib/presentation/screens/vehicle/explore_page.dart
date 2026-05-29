import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/vehicle/vehicle_bloc.dart';
import '../../../bloc/vehicle/vehicle_event.dart';
import '../../../bloc/vehicle/vehicle_state.dart';
import 'detail_page.dart';

class ExplorePage extends StatefulWidget {
  final String? search;

  const ExplorePage({
    super.key,
    this.search,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ExploreBloc()..add(LoadVehicles());

        if (widget.search != null &&
            widget.search!.isNotEmpty) {
          bloc.add(
            SearchQueryChanged(widget.search!),
          );
        }

        return bloc;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF071018),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                IconButton(
                  onPressed: () =>
                      Navigator.pop(context),

                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF6FEFFF),
                  ),
                ),

                const SizedBox(height: 10),

                _SearchBar(
                  initialValue: widget.search,
                ),

                const SizedBox(height: 20),

                const Expanded(
                  child: _ExploreGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  final String? initialValue;

  const _SearchBar({
    super.key,
    this.initialValue,
  });

  @override
  State<_SearchBar> createState() =>
      _SearchBarState();
}

class _SearchBarState
    extends State<_SearchBar> {

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
      text: widget.initialValue,
    );

    controller.selection =
        TextSelection.collapsed(
          offset:
          widget.initialValue?.length ?? 0,
        );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
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
        controller: controller,

        onChanged: (value) {
          context.read<ExploreBloc>().add(
            SearchQueryChanged(value),
          );
        },

        style: const TextStyle(
          color: Colors.white,
        ),

        cursorColor: const Color(0xFF26C6DA),

        decoration: const InputDecoration(
          icon: Icon(
            Icons.search,
            color: Color(0xFF6FEFFF),
          ),

          hintText:
          "Search cars, bikes, EVs...",

          hintStyle: TextStyle(
            color: Color(0xFF9EDAE2),
          ),

          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _ExploreGrid extends StatefulWidget {
  const _ExploreGrid({super.key});

  @override
  State<_ExploreGrid> createState() =>
      _ExploreGridState();
}

class _ExploreGridState
    extends State<_ExploreGrid> {

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context).size.width;

    final height =
        MediaQuery.of(context).size.height;

    return BlocBuilder<ExploreBloc,
        ExploreState>(
      builder: (context, state) {

        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF26C6DA),
            ),
          );
        }

        if (state.filteredVehicles.isEmpty) {
          return const Center(
            child: Text(
              "No Vehicles Found",

              style: TextStyle(
                color: Color(0xFF9EDAE2),
              ),
            ),
          );
        }

        return GridView.builder(
          itemCount:
          state.filteredVehicles.length,

          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
            width < 600 ? 2 : 3,

            crossAxisSpacing: 12,
            mainAxisSpacing: 18,

            childAspectRatio:
            width < 400 ? 0.62 : 0.72,
          ),

          itemBuilder: (context, index) {

            final doc =
            state.filteredVehicles[index];

            final data =
            doc.data() as Map<String, dynamic>;

            final rating = double.tryParse(
              data['rating'].toString(),
            ) ??
                0.0;

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(
                    carId: doc.id,
                  ),
                ),
              ),

              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(18),

                  gradient:
                  const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      Color(0xFF142D3A),
                      Color(0xFF1B5368),
                      Color(0xFF102733),
                    ],
                  ),

                  border: Border.all(
                    color: const Color(
                        0xFF00D9FF)
                        .withOpacity(0.18),

                    width: 1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                          0xFF00D9FF)
                          .withOpacity(0.12),

                      blurRadius: 20,
                      spreadRadius: 1,

                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Stack(
                  children: [

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        SizedBox(
                          height: height * 0.015,
                        ),

                        Expanded(
                          flex: 5,

                          child: Padding(
                            padding:
                            const EdgeInsets
                                .symmetric(
                              horizontal: 10,
                            ),

                            child: Image.network(
                              data['image'],

                              fit: BoxFit.contain,

                              width:
                              double.infinity,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 4,

                          child: Padding(
                            padding:
                            const EdgeInsets
                                .all(12),

                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                              children: [

                                Text(
                                  data['brand'] ??
                                      '',

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  const TextStyle(
                                    color: Color(
                                        0xFF6FEFFF),

                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  data['name'] ??
                                      '',

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  TextStyle(
                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight
                                        .bold,

                                    fontSize:
                                    width *
                                        0.038,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  "₹ ${data['price']} Lakh",

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  const TextStyle(
                                    color: Color(
                                        0xFFE4FCFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      top: 10,
                      right: 10,

                      child: _RatingBadge(
                        rating: rating,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(12),

        color: const Color(0xFF26C6DA)
            .withOpacity(0.18),

        border: Border.all(
          color: const Color(0xFF6FEFFF)
              .withOpacity(0.18),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [

          const Icon(
            Icons.star,
            size: 12,
            color: Color(0xFF6FEFFF),
          ),

          const SizedBox(width: 3),

          Text(
            rating.toStringAsFixed(1),

            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
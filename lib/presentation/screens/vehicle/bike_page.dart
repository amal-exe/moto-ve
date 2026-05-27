import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/vehicle/vehicle_bloc.dart';
import '../../../bloc/vehicle/vehicle_event.dart';
import '../../../bloc/vehicle/vehicle_state.dart';
import 'detail_page.dart';
import 'home_page.dart';

class BikePage extends StatefulWidget {
  const BikePage({super.key});

  @override
  State<BikePage> createState() => _BikePageState();
}

class _BikePageState extends State<BikePage> {
  final TextEditingController searchController =
  TextEditingController();

  late BikeBloc bikeBloc;

  /// TEMP FILTERS
  String tempBrand = "All";
  String tempType = "All";
  String tempCC = "All";
  String tempMileage = "All";

  @override
  void initState() {
    super.initState();

    bikeBloc = BikeBloc()
      ..add(LoadFilters());
  }

  @override
  void dispose() {
    bikeBloc.close();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bikeBloc,

      child: Scaffold(
        backgroundColor: const Color(0xFF071018),

        /// APPBAR
        appBar: AppBar(
          backgroundColor: const Color(0xFF071018),
          elevation: 0,
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF6FEFFF),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
            },
          ),

          title: const Text(
            "Bikes",
            style: TextStyle(
              color: Color(0xFF6FEFFF),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(
                Icons.tune_rounded,
                color: Color(0xFF6FEFFF),
              ),

              onPressed: () {
                final currentState =
                    bikeBloc.state;

                /// INITIAL VALUES
                tempBrand =
                    currentState.selectedBrand;

                tempType =
                    currentState.selectedType;

                tempCC =
                    currentState.selectedCC;

                tempMileage =
                    currentState.selectedMileage;

                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,

                  backgroundColor:
                  const Color(0xFF102532),

                  shape:
                  const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),

                  builder: (bottomSheetContext) {
                    return StatefulBuilder(
                      builder: (
                          modalContext,
                          setModalState,
                          ) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                            bottom:
                            MediaQuery.of(
                              modalContext,
                            )
                                .viewInsets
                                .bottom +
                                25,
                          ),

                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [
                                /// HANDLE
                                Center(
                                  child: Container(
                                    width: 60,
                                    height: 5,

                                    decoration:
                                    BoxDecoration(
                                      color:
                                      Colors.white24,

                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                          10),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    height: 25),

                                /// TITLE
                                const Center(
                                  child: Text(
                                    "Filter Bikes",

                                    style: TextStyle(
                                      color: Color(
                                          0xFF6FEFFF),

                                      fontSize: 24,

                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    height: 30),

                                /// BRAND
                                _buildDropdown(
                                  title: "Company",

                                  value: tempBrand,

                                  items:
                                  currentState
                                      .brands,

                                  onChanged: (v) {
                                    setModalState(
                                          () {
                                        tempBrand =
                                        v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                    height: 18),

                                /// TYPE
                                _buildDropdown(
                                  title: "Type",

                                  value: tempType,

                                  items:
                                  currentState
                                      .types,

                                  onChanged: (v) {
                                    setModalState(
                                          () {
                                        tempType =
                                        v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                    height: 18),

                                /// CC
                                _buildDropdown(
                                  title: "CC Range",

                                  value: tempCC,

                                  items: const [
                                    "All",
                                    "100-250",
                                    "250-400",
                                    "400-650",
                                    "650-1000",
                                    "1000-2000",
                                  ],

                                  onChanged: (v) {
                                    setModalState(
                                          () {
                                        tempCC = v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                    height: 18),

                                /// MILEAGE
                                _buildDropdown(
                                  title: "Mileage",

                                  value:
                                  tempMileage,

                                  items: const [
                                    "All",
                                    "10-20",
                                    "20-30",
                                    "30-50",
                                  ],

                                  onChanged: (v) {
                                    setModalState(
                                          () {
                                        tempMileage =
                                        v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                    height: 35),

                                /// BUTTONS
                                Row(
                                  children: [
                                    /// RESET
                                    Expanded(
                                      child:
                                      OutlinedButton(
                                        style:
                                        OutlinedButton
                                            .styleFrom(
                                          side:
                                          const BorderSide(
                                            color: Color(
                                                0xFF6FEFFF),
                                          ),

                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                16),
                                          ),

                                          padding:
                                          const EdgeInsets.symmetric(
                                            vertical:
                                            16,
                                          ),
                                        ),

                                        onPressed:
                                            () {
                                          setModalState(
                                                () {
                                              tempBrand =
                                              "All";

                                              tempType =
                                              "All";

                                              tempCC =
                                              "All";

                                              tempMileage =
                                              "All";
                                            },
                                          );
                                        },

                                        child:
                                        const Text(
                                          "Reset",

                                          style:
                                          TextStyle(
                                            color: Color(
                                                0xFF6FEFFF),

                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 14),

                                    /// APPLY
                                    Expanded(
                                      child:
                                      ElevatedButton(
                                        style:
                                        ElevatedButton
                                            .styleFrom(
                                          backgroundColor:
                                          const Color(
                                              0xFF6FEFFF),

                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                16),
                                          ),

                                          padding:
                                          const EdgeInsets.symmetric(
                                            vertical:
                                            16,
                                          ),
                                        ),

                                        onPressed:
                                            () {
                                          bikeBloc.add(
                                            FilterChanged(
                                              brand:
                                              tempBrand,
                                              type:
                                              tempType,
                                              cc: tempCC,
                                              mileage:
                                              tempMileage,
                                            ),
                                          );

                                          Navigator.pop(
                                            bottomSheetContext,
                                          );
                                        },

                                        child:
                                        const Text(
                                          "Apply",

                                          style:
                                          TextStyle(
                                            color: Colors
                                                .black,

                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),

        /// BODY
        body: SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: Column(
              children: [
                const SizedBox(height: 14),

                /// SEARCH BAR
                Container(
                  height: 56,

                  decoration: BoxDecoration(
                    color:
                    const Color(0xFF102532),

                    borderRadius:
                    BorderRadius.circular(
                        18),

                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),

                  child: TextField(
                    controller: searchController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                    InputDecoration(
                      border:
                      InputBorder.none,

                      hintText:
                      "Search bikes...",

                      hintStyle:
                      TextStyle(
                        color: Colors.white
                            .withOpacity(0.5),
                      ),

                      prefixIcon:
                      const Icon(
                        Icons.search,
                        color:
                        Color(0xFF6FEFFF),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                /// BIKE GRID
                Expanded(
                  child: BlocBuilder<
                      BikeBloc,
                      BikeState>(
                    bloc: bikeBloc,

                    builder: (
                        context,
                        state,
                        ) {
                      if (state.isLoading) {
                        return const Center(
                          child:
                          CircularProgressIndicator(),
                        );
                      }

                      if (state
                          .filteredBikes
                          .isEmpty) {
                        return const Center(
                          child: Text(
                            "No Bikes Found",

                            style: TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        physics:
                        const BouncingScrollPhysics(),

                        itemCount: state
                            .filteredBikes
                            .length,

                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,

                          crossAxisSpacing:
                          14,

                          mainAxisSpacing:
                          14,

                          childAspectRatio:
                          0.72,
                        ),

                        itemBuilder:
                            (context, index) {
                          final doc = state
                              .filteredBikes[
                          index];

                          final data = doc
                              .data()
                          as Map<String,
                              dynamic>;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailPage(
                                        carId:
                                        doc.id,
                                      ),
                                ),
                              );
                            },

                            child: Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    24),

                                gradient:
                                const LinearGradient(
                                  begin: Alignment
                                      .topLeft,

                                  end: Alignment
                                      .bottomRight,

                                  colors: [
                                    Color(
                                        0xFF142D3A),

                                    Color(
                                        0xFF1B5368),
                                  ],
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                        0.25),

                                    blurRadius:
                                    12,
                                  ),
                                ],
                              ),

                              child: Padding(
                                padding:
                                const EdgeInsets
                                    .all(12),

                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                                  children: [
                                    /// IMAGE
                                    Expanded(
                                      child:
                                      Center(
                                        child:
                                        Image.network(
                                          data[
                                          'image'],

                                          fit: BoxFit
                                              .contain,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                        10),

                                    /// BRAND
                                    Text(
                                      data['brand'] ??
                                          '',

                                      style:
                                      const TextStyle(
                                        color: Color(
                                            0xFF6FEFFF),

                                        fontSize:
                                        11,

                                        fontWeight:
                                        FontWeight
                                            .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                        4),

                                    /// NAME
                                    Text(
                                      data['name'] ??
                                          '',

                                      maxLines:
                                      1,

                                      overflow:
                                      TextOverflow
                                          .ellipsis,

                                      style:
                                      const TextStyle(
                                        color: Colors
                                            .white,

                                        fontSize:
                                        16,

                                        fontWeight:
                                        FontWeight
                                            .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                        10),

                                    /// PRICE
                                    Text(
                                      "₹${data['price']}",

                                      style:
                                      const TextStyle(
                                        color: Colors
                                            .white,

                                        fontWeight:
                                        FontWeight
                                            .w700,

                                        fontSize:
                                        15,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                        10),

                                    /// SPECS
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,

                                      children: [
                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal:
                                            8,

                                            vertical:
                                            4,
                                          ),

                                          decoration:
                                          BoxDecoration(
                                            color: Colors
                                                .white10,

                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),

                                          child:
                                          Text(
                                            "${data['spec']?['enginecc'] ?? 0} CC",

                                            style:
                                            const TextStyle(
                                              color: Colors
                                                  .white70,

                                              fontSize:
                                              10,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                            horizontal:
                                            8,

                                            vertical:
                                            4,
                                          ),

                                          decoration:
                                          BoxDecoration(
                                            color: Colors
                                                .white10,

                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),

                                          child:
                                          Text(
                                            "${data['spec']?['mileage'] ?? 0} Km/L",

                                            style:
                                            const TextStyle(
                                              color: Colors
                                                  .white70,

                                              fontSize:
                                              10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: const TextStyle(
            color: Color(0xFF6FEFFF),
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 16,
          ),

          decoration: BoxDecoration(
            color:
            const Color(0xFF183646),

            borderRadius:
            BorderRadius.circular(18),

            border: Border.all(
              color: Colors.white10,
            ),
          ),

          child: DropdownButton<String>(
            value: value,

            isExpanded: true,

            dropdownColor:
            const Color(0xFF183646),

            underline: const SizedBox(),

            style: const TextStyle(
              color: Colors.white,
            ),

            iconEnabledColor:
            const Color(0xFF6FEFFF),

            items: items
                .map(
                  (item) =>
                  DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
            )
                .toList(),

            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
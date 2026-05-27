import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/vehicle/vehicle_bloc.dart';
import '../../../bloc/vehicle/vehicle_event.dart';
import '../../../bloc/vehicle/vehicle_state.dart';
import 'detail_page.dart';
import 'home_page.dart';

class EvPage extends StatefulWidget {
  const EvPage({super.key});

  @override
  State<EvPage> createState() => _EvPageState();
}

class _EvPageState extends State<EvPage> {

  final TextEditingController searchController =
  TextEditingController();

  late EvBloc evBloc;

  /// TEMP FILTERS
  String tempBrand = "All";
  String tempType = "All";
  String tempBattery = "All";
  String tempRange = "All";

  @override
  void initState() {
    super.initState();

    evBloc = EvBloc()
      ..add(
        LoadEvFilters(),
      );
  }

  @override
  void dispose() {
    evBloc.close();
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: evBloc,

      child: Scaffold(
        backgroundColor:
        const Color(0xFF071018),

        /// APPBAR
        appBar: AppBar(
          backgroundColor:
          const Color(0xFF071018),

          elevation: 0,
          centerTitle: true,

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color:
              Color(0xFF6FEFFF),
            ),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const HomePage(),
                ),
              );
            },
          ),

          title: const Text(
            "EVs",

            style: TextStyle(
              color:
              Color(0xFF6FEFFF),

              fontSize: 24,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(
                Icons.tune_rounded,

                color:
                Color(0xFF6FEFFF),
              ),

              onPressed: () {

                final currentState =
                    evBloc.state;

                /// INITIAL VALUES
                tempBrand =
                    currentState
                        .selectedBrand;

                tempType =
                    currentState
                        .selectedType;

                tempBattery =
                    currentState
                        .selectedBattery;

                tempRange =
                    currentState
                        .selectedRange;

                showModalBottomSheet(
                  context: context,

                  isScrollControlled:
                  true,

                  backgroundColor:
                  const Color(
                      0xFF102532),

                  shape:
                  const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .vertical(
                      top:
                      Radius.circular(
                          30),
                    ),
                  ),

                  builder:
                      (bottomSheetContext) {

                    return StatefulBuilder(
                      builder: (
                          modalContext,
                          setModalState,
                          ) {

                        return Padding(
                          padding:
                          EdgeInsets.only(
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

                          child:
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                /// HANDLE
                                Center(
                                  child:
                                  Container(
                                    width: 60,
                                    height: 5,

                                    decoration:
                                    BoxDecoration(
                                      color:
                                      Colors
                                          .white24,

                                      borderRadius:
                                      BorderRadius.circular(
                                          10),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 25,
                                ),

                                /// TITLE
                                const Center(
                                  child: Text(
                                    "Filter EVs",

                                    style:
                                    TextStyle(
                                      color: Color(
                                          0xFF6FEFFF),

                                      fontSize:
                                      24,

                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                /// BRAND
                                _buildDropdown(
                                  title:
                                  "Company",

                                  value:
                                  tempBrand,

                                  items:
                                  currentState
                                      .brands,

                                  onChanged:
                                      (v) {

                                    setModalState(
                                          () {
                                        tempBrand =
                                        v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                  height: 18,
                                ),

                                /// TYPE
                                _buildDropdown(
                                  title:
                                  "Type",

                                  value:
                                  tempType,

                                  items:
                                  currentState
                                      .types,

                                  onChanged:
                                      (v) {

                                    setModalState(
                                          () {
                                        tempType =
                                        v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                  height: 18,
                                ),

                                /// BATTERY
                                _buildDropdown(
                                  title:
                                  "Battery (kWh)",

                                  value:
                                  tempBattery,

                                  items:
                                  const [
                                    "All",
                                    "3-7",
                                    "7-15",
                                    "15-25",
                                    "25-40",
                                    "40-60",
                                  ],

                                  onChanged:
                                      (v) {

                                    setModalState(
                                          () {
                                        tempBattery =
                                        v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                  height: 18,
                                ),

                                /// RANGE
                                _buildDropdown(
                                  title:
                                  "Range (Km)",

                                  value:
                                  tempRange,

                                  items:
                                  const [
                                    "All",
                                    "100-200",
                                    "200-300",
                                    "300-400",
                                    "400-600",
                                  ],

                                  onChanged:
                                      (v) {

                                    setModalState(
                                          () {
                                        tempRange =
                                        v!;
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(
                                  height: 35,
                                ),

                                /// BUTTONS
                                Row(
                                  children: [

                                    /// RESET
                                    Expanded(
                                      child:
                                      OutlinedButton(
                                        style:
                                        OutlinedButton.styleFrom(
                                          side:
                                          const BorderSide(
                                            color:
                                            Color(
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

                                              tempBattery =
                                              "All";

                                              tempRange =
                                              "All";
                                            },
                                          );
                                        },

                                        child:
                                        const Text(
                                          "Reset",

                                          style:
                                          TextStyle(
                                            color:
                                            Color(
                                                0xFF6FEFFF),

                                            fontWeight:
                                            FontWeight
                                                .bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 14,
                                    ),

                                    /// APPLY
                                    Expanded(
                                      child:
                                      ElevatedButton(
                                        style:
                                        ElevatedButton.styleFrom(
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

                                          evBloc.add(
                                            EvFilterChanged(
                                              brand:
                                              tempBrand,

                                              type:
                                              tempType,

                                              battery:
                                              tempBattery,

                                              range:
                                              tempRange,
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
                                            color:
                                            Colors
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

                const SizedBox(
                    height: 14),

                /// SEARCH BAR
                Container(
                  height: 56,

                  decoration:
                  BoxDecoration(
                    color:
                    const Color(
                        0xFF102532),

                    borderRadius:
                    BorderRadius.circular(
                        18),

                    border: Border.all(
                      color:
                      Colors.white10,
                    ),
                  ),

                  child: TextField(
                    controller:
                    searchController,

                    onChanged: (value) {
                      evBloc.add(
                        EvSearchChanged(
                            value),
                      );
                    },

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),

                    decoration:
                    InputDecoration(
                      border:
                      InputBorder.none,

                      hintText:
                      "Search EVs...",

                      hintStyle:
                      TextStyle(
                        color: Colors
                            .white
                            .withOpacity(
                            0.5),
                      ),

                      prefixIcon:
                      const Icon(
                        Icons.search,

                        color: Color(
                            0xFF6FEFFF),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 18),

                /// EV GRID
                Expanded(
                  child: BlocBuilder<
                      EvBloc,
                      EvState>(
                    bloc: evBloc,

                    builder: (
                        context,
                        state,
                        ) {

                      if (state
                          .isLoading) {

                        return const Center(
                          child:
                          CircularProgressIndicator(),
                        );
                      }

                      if (state
                          .filteredEvs
                          .isEmpty) {

                        return const Center(
                          child: Text(
                            "No EVs Found",

                            style:
                            TextStyle(
                              color: Colors
                                  .white,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        physics:
                        const BouncingScrollPhysics(),

                        itemCount:
                        state
                            .filteredEvs
                            .length,

                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                          2,

                          crossAxisSpacing:
                          14,

                          mainAxisSpacing:
                          14,

                          childAspectRatio:
                          0.72,
                        ),

                        itemBuilder:
                            (
                            context,
                            index,
                            ) {

                          final doc =
                          state.filteredEvs[
                          index];

                          final data =
                          doc.data()
                          as Map<
                              String,
                              dynamic>;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                      DetailPage(
                                        carId:
                                        doc.id,
                                      ),
                                ),
                              );
                            },

                            child:
                            Container(
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    24),

                                gradient:
                                const LinearGradient(
                                  begin:
                                  Alignment
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
                                    .all(
                                    12),

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
                                      10,
                                    ),

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
                                      4,
                                    ),

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
                                      10,
                                    ),

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
                                      10,
                                    ),

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
                                            color:
                                            Colors.white10,

                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),

                                          child:
                                          Text(
                                            "${data['spec']?['batteryCapacity'] ?? data['spec']?['battery'] ?? 0} kWh",

                                            style:
                                            const TextStyle(
                                              color:
                                              Colors.white70,

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
                                            color:
                                            Colors.white10,

                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),

                                          child:
                                          Text(
                                            "${data['spec']?['range'] ?? 0} Km",

                                            style:
                                            const TextStyle(
                                              color:
                                              Colors.white70,

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

            fontWeight:
            FontWeight.bold,
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
            BorderRadius.circular(
                18),

            border: Border.all(
              color: Colors.white10,
            ),
          ),

          child:
          DropdownButton<String>(
            value: value,

            isExpanded: true,

            dropdownColor:
            const Color(
                0xFF183646),

            underline:
            const SizedBox(),

            style: const TextStyle(
              color: Colors.white,
            ),

            iconEnabledColor:
            const Color(
                0xFF6FEFFF),

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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/vehicle/vehicle_bloc.dart';
import '../../../bloc/vehicle/vehicle_event.dart';
import '../../../bloc/vehicle/vehicle_state.dart';
import '../emi/emi_page.dart';

class DetailPage extends StatefulWidget {
  final String carId;
  const DetailPage({super.key, required this.carId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc()..add(LoadVehicleDetails(widget.carId)),
      child: Scaffold(
        backgroundColor: const Color(0xFF071018),
        appBar: AppBar(
          backgroundColor: const Color(0xFF071018),
          elevation: 0,

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF6FEFFF),
            ),

            onPressed: () => Navigator.pop(context),
          ),

          title: const Text(
            "Vehicle Details",

            style: TextStyle(
              color: Color(0xFF6FEFFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state.status == DetailStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == DetailStatus.failure) {
              return Center(child: Text(state.errorMessage ?? "Error", style: const TextStyle(color: Colors.white)));
            }
            if (state.status == DetailStatus.success) {
              final data = state.vehicleData!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      _buildMainCard(context, data),
                      const SizedBox(height: 25),
                      _buildTabs(),
                      const SizedBox(height: 20),
                      _buildTabContent(data, state.reviews ?? []),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

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
            blurRadius: 22,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['brand'] ?? 'N/A', style: const TextStyle(color: Color(0xFF6FEFFF), fontSize: 15, letterSpacing: 2)),
          const SizedBox(height: 5),
          Text((data['name'] ?? 'N/A').toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          Center(child: Image.network(data['image'], height: 220, fit: BoxFit.contain)),
          const SizedBox(height: 20),
          Row(
            children: [
              Text("₹ ${data['price']} Lakh", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              const Text('Onwards', style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26C6DA),

                  shadowColor: const Color(0xFF26C6DA),

                  elevation: 12, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmiPage(vehiclePrice: (data['price'] ?? 0).toDouble()))),
              child: const Text("Check EMI Plans", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: const Color(0xFF26C6DA),

      labelColor: const Color(0xFF6FEFFF),

      unselectedLabelColor: const Color(0xFF9EDAE2),
      tabs: const [Tab(text: "Specs"), Tab(text: "Features"), Tab(text: "Reviews")],
    );
  }

  Widget _buildTabContent(Map<String, dynamic> data, List<QueryDocumentSnapshot> reviews) {
    return SizedBox(
      height: 400,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildSpecs(data),
          _buildFeatures(data['features'] ?? []),
          _buildReviews(reviews),
        ],
      ),
    );
  }

  Widget _buildSpecs(Map<String, dynamic> data) {
    final spec = data['spec'] as Map<String, dynamic>?;
    return ListView(
      children: [
        _specRow("Engine CC", "${spec?['enginecc'] ?? 'N/A'} CC"),
        _specRow("Engine", "${data['engine']}"),
        _specRow("Power", "${data['power']}"),
        _specRow("Torque", "${data['torque']}"),
        _specRow("Top Speed", "${data['topspeed']}"),
      ],
    );
  }

  Widget _buildFeatures(List features) {
    if (features.isEmpty) return const Center(child: Text("No features", style: TextStyle(color: Colors.white)));
    return ListView.builder(
      itemCount: features.length,
      itemBuilder: (context, index) {
        final f = features[index];
        return ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.orange),
          title: Text(f['title'] ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(f['description'] ?? "", style: const TextStyle(color: Colors.white70)),
        );
      },
    );
  }

  Widget _buildReviews(List<QueryDocumentSnapshot> reviews) {
    if (reviews.isEmpty) return const Center(child: Text("No reviews yet", style: TextStyle(color: Colors.white)));
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final r = reviews[index].data() as Map<String, dynamic>;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r['name'] ?? "User", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Text("⭐ ${r['rating']}", style: const TextStyle(color: Colors.white)),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Text(r['review'] ?? "", style: const TextStyle(color: Colors.white70)),
            ],
          ),
        );
      },
    );
  }

  Widget _specRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
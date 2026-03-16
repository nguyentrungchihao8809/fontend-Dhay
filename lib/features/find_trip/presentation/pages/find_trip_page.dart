import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/find_trip_bloc.dart';
import '../bloc/find_trip_event.dart';
import '../bloc/find_trip_state.dart';

class FindTripPage extends StatefulWidget {
  const FindTripPage({super.key});

  @override
  State<FindTripPage> createState() => _FindTripPageState();
}

class _FindTripPageState extends State<FindTripPage> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FindTripBloc>().add(LoadRecentTripsEvent());
  }

  void _swapLocations() {
    final temp = _pickupController.text;
    setState(() {
      _pickupController.text = _destinationController.text;
      _destinationController.text = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopSection(),
            const Padding(
              padding: EdgeInsets.only(left: 32, top: 40, bottom: 15),
              child: Text(
                'Lịch sử chuyến đi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      height: 335,
      decoration: const BoxDecoration(
        color: Color(0xFFD9D8D8), // Rectangle 205
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 6),
            blurRadius: 4,
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Back Button
          Positioned(
            left: 31,
            top: 26,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 56,
                height: 49,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBFBFB),
                  border: Border.all(color: const Color(0xFF909090)),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(5, 5), blurRadius: 5)
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
          // Title
          Positioned(
            left: 34,
            top: 106,
            child: Text(
              'Bạn muốn đi đâu?',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                shadows: [const Shadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4))],
              ),
            ),
          ),
          // Input Fields
          Positioned(
            left: 31,
            top: 148,
            right: 35,
            child: CustomTextField(
              controller: _pickupController,
              hintText: 'Điểm đón...',
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                width: 26, height: 26,
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: Center(
                  child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 31,
            top: 213,
            right: 35,
            child: CustomTextField(
              controller: _destinationController,
              hintText: 'Điểm đến...',
              prefixIcon: const Icon(Icons.location_on, color: Colors.black, size: 30),
            ),
          ),
          // Swap Icon
          Positioned(
            right: 15,
            top: 185,
            child: IconButton(
              icon: const Icon(Icons.swap_vert, size: 30, color: Colors.black),
              onPressed: _swapLocations,
            ),
          ),
          // Handle bar at bottom of gray area
          Positioned(
            left: 164,
            top: 306,
            child: Container(
              width: 84, height: 8,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return BlocBuilder<FindTripBloc, FindTripState>(
      builder: (context, state) {
        if (state is FindTripLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FindTripError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        } else if (state is FindTripLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.recentTrips.length,
            itemBuilder: (context, index) {
              final item = state.recentTrips[index];
              return _buildHistoryItem(item);
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildHistoryItem(dynamic item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 31, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F2F2),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 5), blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.distance} km – ${item.address}',
            style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF3B3939)),
          ),
        ],
      ),
    );
  }
}
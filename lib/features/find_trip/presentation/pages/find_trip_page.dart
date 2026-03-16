import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/find_trip_bloc.dart';
import '../bloc/find_trip_event.dart';
import '../bloc/find_trip_state.dart';
import '../widgets/location_input_section.dart';
import '../widgets/history_list_item.dart';

class FindTripPage extends StatefulWidget {
  const FindTripPage({super.key});

  @override
  State<FindTripPage> createState() => _FindTripPageState();
}

class _FindTripPageState extends State<FindTripPage> {
  final _pickupController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FindTripBloc>().add(LoadRecentTripsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho toàn bộ body
        children: [
          // 1. Header màu xám chuẩn Figma
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 25),
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bạn muốn đi đâu?',
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                LocationInputSection(
                  pickupController: _pickupController,
                  destinationController: _destinationController,
                  onSwap: () {
                    final temp = _pickupController.text;
                    _pickupController.text = _destinationController.text;
                    _destinationController.text = temp;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                    width: 80,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ],
            ),
          ),

          // 2. PHẦN LỊCH SỬ CHUYẾN ĐI (Đã thêm chữ ở đây)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 31, top: 30, bottom: 10),
                  child: Text(
                    'Lịch sử chuyến đi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<FindTripBloc, FindTripState>(
                    builder: (context, state) {
                      if (state is FindTripLoaded) {
                        return ListView.builder(
                          padding: EdgeInsets.zero, // Xóa padding mặc định của ListView
                          itemCount: state.recentTrips.length,
                          itemBuilder: (context, index) => HistoryListItem(
                            location: state.recentTrips[index],
                            onTap: () => _destinationController.text = state.recentTrips[index].name,
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
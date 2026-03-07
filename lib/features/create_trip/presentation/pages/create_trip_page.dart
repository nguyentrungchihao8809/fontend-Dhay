import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/create_trip_bloc.dart';
import '../widgets/location_input_field.dart';
import '../widgets/recent_destination_item.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  // --- BIẾN LƯU TRẠNG THÁI ---
  String _selectedDate = "Hôm nay";
  String _selectedTime = DateFormat('HH:mm').format(DateTime.now());

  // --- HÀM TẠO DANH SÁCH 30 NGÀY ---
  List<DateTime> _generateDates() {
    return List.generate(30, (index) => DateTime.now().add(Duration(days: index)));
  }

  // --- HÀM HIỂN THỊ DIALOG HẸN GIỜ ---
  void _showDateTimePicker(BuildContext context) {
    final dates = _generateDates();

    // LOGIC LÀM TRÒN LÊN 5 PHÚT GẦN NHẤT
    DateTime now = DateTime.now();
    int hour = now.hour;
    int initialMinuteIndex = (now.minute / 5).ceil();

    if (initialMinuteIndex == 12) {
      hour += 1;
      initialMinuteIndex = 0;
    }

    int initialTimeIndex = (hour * 12) + initialMinuteIndex;
    String formattedInitialTime = "${(hour % 24).toString().padLeft(2, '0')}:${(initialMinuteIndex * 5).toString().padLeft(2, '0')}";
    _selectedTime = formattedInitialTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. Header
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.black, size: 28),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const Text(
                              "Tạo chuyến đi",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),

                      // 2 & 3. Tiêu đề cột và Vòng quay
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.black, width: 1.2)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Ngày Hẹn", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                Text("Giờ Hẹn", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 160,
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CupertinoPicker(
                                        scrollController: FixedExtentScrollController(initialItem: 0),
                                        itemExtent: 40,
                                        onSelectedItemChanged: (index) {
                                          setState(() {
                                            _selectedDate = (index == 0) ? "Hôm nay" : DateFormat('dd-MM-yyyy').format(dates[index]);
                                          });
                                          setModalState(() {});
                                        },
                                        children: dates.map((date) {
                                          String label = DateFormat('dd-MM-yyyy').format(date);
                                          if (date.day == DateTime.now().day) label = "Hôm nay";
                                          return Center(child: Text(label, style: const TextStyle(fontSize: 16)));
                                        }).toList(),
                                      ),
                                    ),
                                    Container(width: 1, color: Colors.black, height: 120),
                                    Expanded(
                                      child: CupertinoPicker(
                                        scrollController: FixedExtentScrollController(initialItem: initialTimeIndex),
                                        itemExtent: 40,
                                        onSelectedItemChanged: (index) {
                                          setState(() {
                                            int hour = (index ~/ 12) % 24;
                                            int min = (index % 12) * 5;
                                            _selectedTime = "${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}";
                                          });
                                          setModalState(() {});
                                        },
                                        children: List.generate(24 * 12, (index) {
                                          int hour = (index ~/ 12) % 24;
                                          int min = (index % 12) * 5;
                                          return Center(child: Text("${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 16)));
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),

                      // 4. Thông tin mô tả
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Column(
                          children: [
                            Text(
                              "Tạo lịch hẹn vào: $_selectedDate . $_selectedTime",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 25),
                            _buildInfoItem(Icons.favorite, "Tạo lịch hẹn, DHAY sẽ giúp bạn kết nối mọi người và đảm bảo đúng hẹn!"),
                            const SizedBox(height: 15),
                            _buildInfoItem(Icons.bolt, "Chúng tôi luôn bảo vệ quyền lợi của bạn. Tạo chuyến đi, mọi thứ sẽ được đảm bảo!", size: 30),
                          ],
                        ),
                      ),

                      // 5. Nút Xác nhận
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text("Xác Nhận", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String label, {double size = 20}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: size, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 21, bottom: 10),
              child: Center(
                child: Text(
                  "Tạo chuyến đi",
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black),
                ),
              ),
            ),
            const Divider(color: Color(0xFFF9F9F9), thickness: 2, indent: 27, endIndent: 27),

            // --- [CẬP NHẬT] CHIPS SELECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              child: Row(
                children: [
                  // Bấm vào đây cũng hiện Dialog
                  _buildChip(
                      Icons.calendar_month,
                      "Lịch Hẹn",
                      onTap: () => _showDateTimePicker(context)
                  ),
                  const SizedBox(width: 26),
                  _buildChip(Icons.star, "Đã lưu"),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: LocationInputField(),
            ),

            const SizedBox(height: 16),

            // --- NÚT THỜI GIAN XUẤT PHÁT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () => _showDateTimePicker(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 10),
                      Text(
                        "$_selectedDate . $_selectedTime",
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<CreateTripBloc, CreateTripState>(
                builder: (context, state) {
                  if (state is CreateTripLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.black));
                  }
                  if (state is CreateTripLoaded) {
                    final results = state.lastModifiedField == LocationFieldType.pickup
                        ? state.pickupResults
                        : state.dropoffResults;
                    if (results.isEmpty) return _buildRecentSection();
                    return ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: results.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final location = results[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                          title: Text(location.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                          subtitle: Text(location.address, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () {
                            context.read<CreateTripBloc>().add(SelectLocationEvent(location, state.lastModifiedField));
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    );
                  }
                  if (state is CreateTripError) return Center(child: Text(state.message));
                  return _buildRecentSection();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24, top: 25, bottom: 10),
          child: Text(
            "Gần đây",
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            children: const [
              RecentDestinationItem(
                startLocation: "Công viên Gia Định . Quận Gò Vấp . Tp.HCM",
                endLocation: "Nhà Thờ Đức Bà . Quận 1 . Tp.HCM",
                distance: "7 km",
                duration: "15 - 20 phút",
              ),
              SizedBox(height: 20),
              RecentDestinationItem(
                startLocation: "Nhà Thờ Đức Bà . Quận 1 . Tp.HCM",
                endLocation: "Khu đô thị Phú Mỹ Hưng . Quận 7 . Tp.HCM",
                distance: "7 km",
                duration: "20 - 30 phút",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- [CẬP NHẬT] HÀM BUILD CHIP CÓ ONTAP ---
  Widget _buildChip(IconData icon, String label, {VoidCallback? onTap}) {
    return Material( // Thêm Material để hiệu ứng InkWell hiển thị đẹp
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: const Color(0xFFF5F4FA),
              borderRadius: BorderRadius.circular(13)
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.black),
              const SizedBox(width: 5),
              Text(
                  label,
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black)
              ),
              const Icon(Icons.keyboard_arrow_down, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
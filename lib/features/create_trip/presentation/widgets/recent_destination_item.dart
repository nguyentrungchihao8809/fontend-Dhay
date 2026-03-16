import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // THÊM DÒNG NÀY
import '../pages/save_location_page.dart';
import '../bloc/create_trip_bloc.dart'; // THÊM DÒNG NÀY
import '../../domain/entity/saved_trip_entity.dart'; // THÊM DÒNG NÀY

class RecentDestinationItem extends StatefulWidget {
  final String startLocation;
  final String endLocation;
  final String distance;
  final String duration;

  const RecentDestinationItem({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
  });

  @override
  State<RecentDestinationItem> createState() => _RecentDestinationItemState();
}

class _RecentDestinationItemState extends State<RecentDestinationItem> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEFCFF),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD9D9D9),
            blurRadius: 10,
            spreadRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.radio_button_checked, size: 14, color: Colors.black),
                  Container(width: 2, height: 26, color: const Color(0xFFB9B9B9)),
                  const Icon(Icons.location_on, size: 14, color: Colors.black),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.startLocation,
                      style: _textStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.endLocation,
                      style: _textStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.distance, style: _infoStyle()),
                Text(widget.duration, style: _infoStyle()),
              ],
            ),
          ),

          // --- ICON BOOKMARK VỚI CUSTOM DIALOG ---
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () async {
                if (!_isSaved) {
                  // CHỈNH SỬA TẠI ĐÂY: Nhận dữ liệu Entity từ trang SaveLocationPage
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SaveLocationPage(
                        initialPickup: widget.startLocation,
                        initialDropoff: widget.endLocation,
                      ),
                    ),
                  );

                  // Kiểm tra nếu kết quả trả về là một SavedTripEntity (đã bấm Lưu ở Ảnh 4)
                  if (result != null && result is SavedTripEntity) {
                    if (mounted) {
                      // Đẩy dữ liệu vào Bloc để cập nhật danh sách cho Ảnh 3
                      context.read<CreateTripBloc>().add(AddSavedTripEvent(result));

                      setState(() {
                        _isSaved = true;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đã lưu địa chỉ thành công!")),
                      );
                    }
                  }
                } else {
                  // --- CUSTOM DIALOG ĐÚNG VIBE ---
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Xóa địa chỉ",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Cưng có chắc muốn xóa địa chỉ này khỏi danh sách đã lưu không?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Text(
                                        "Hủy",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF959595),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() => _isSaved = false);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Đã xóa địa chỉ!")),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        "Xóa",
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
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
                }
              },
              child: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border,
                  size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() => const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: Colors.black,
  );

  TextStyle _infoStyle() => const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 8,
    color: Color(0xFF959595),
  );
}
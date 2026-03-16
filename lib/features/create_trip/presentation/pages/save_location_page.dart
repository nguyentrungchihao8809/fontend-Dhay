import 'package:flutter/material.dart';
import '../../domain/entity/saved_trip_entity.dart'; // Nhớ import entity này nhé

class SaveLocationPage extends StatefulWidget {
  final String initialPickup; // Địa chỉ đi lấy từ mục gần đây
  final String initialDropoff; // Địa chỉ đến lấy từ mục gần đây

  const SaveLocationPage({
    super.key,
    required this.initialPickup,
    required this.initialDropoff,
  });

  @override
  State<SaveLocationPage> createState() => _SaveLocationPageState();
}

class _SaveLocationPageState extends State<SaveLocationPage> {
  // --- CONTROLLERS ---
  late TextEditingController _pickupController;
  late TextEditingController _dropoffController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedTag = "Nhà";

  @override
  void initState() {
    super.initState();
    // Khởi tạo Controller với dữ liệu được truyền sang
    _pickupController = TextEditingController(text: widget.initialPickup);
    _dropoffController = TextEditingController(text: widget.initialDropoff);
  }

  @override
  void dispose() {
    // Nhớ dispose để tránh leak bộ nhớ nha cưng
    _pickupController.dispose();
    _dropoffController.dispose();
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thông tin địa chỉ đã lưu",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Poppins'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildLabel("Tên địa chỉ"),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Tên địa chỉ đã lưu....",
                hintStyle: TextStyle(color: Color(0xFFD9D9D9)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5)),
              ),
            ),
            const SizedBox(height: 30),
            _buildLabel("Địa chỉ"),
            const SizedBox(height: 10),

            // --- BOX ĐỊA CHỈ (Rectangle 367 style) ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // TextField cho địa chỉ đi với ICON MỚI
                  _buildEditableAddressField(
                      Icons.circle, _pickupController, "Địa chỉ đi của bạn....",
                      size: 14),
                  const Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Divider(color: Color(0xFFF2F2F2), thickness: 1),
                  ),
                  // TextField cho địa chỉ đến
                  _buildEditableAddressField(
                      Icons.location_on, _dropoffController, "Địa chỉ đến của bạn....",
                      size: 22),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- TAGS SELECTION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tagWidget(Icons.home, "Nhà"),
                _tagWidget(Icons.school, "Trường"),
                _tagWidget(Icons.work, "Công ty"),
                _tagWidget(Icons.more_horiz, "Khác"),
              ],
            ),

            const SizedBox(height: 30),
            _buildLabel("Ghi chú"),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: "Thêm ghi chú nếu cần nha....",
                hintStyle: TextStyle(color: Color(0xFFD9D9D9)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5)),
              ),
            ),
            const SizedBox(height: 60),

            // --- NÚT LƯU ĐỊA CHỈ (ĐÃ CẬP NHẬT LOGIC TRẢ DỮ LIỆU) ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cưng đặt cái tên cho địa chỉ đã nha!")),
                    );
                    return;
                  }

                  // Gói dữ liệu vào Entity để gửi về trang trước
                  final newTrip = SavedTripEntity(
                    name: _nameController.text.trim(),
                    startLocation: _pickupController.text, // Lấy từ controller để lỡ User có sửa địa chỉ
                    endLocation: _dropoffController.text,   // Lấy từ controller
                    tag: _selectedTag,
                  );

                  // Trả dữ liệu về cho RecentDestinationItem
                  Navigator.pop(context, newTrip);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("Lưu địa chỉ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HỖ TRỢ (GIỮ NGUYÊN) ---

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Poppins'));

  Widget _buildEditableAddressField(IconData icon, TextEditingController controller, String hint, {double size = 20}) {
    return Row(
      children: [
        icon == Icons.circle
            ? Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Center(
            child: Container(
              width: size / 2.5,
              height: size / 2.5,
              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            ),
          ),
        )
            : Icon(icon, size: size, color: Colors.black),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Poppins'),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tagWidget(IconData icon, String label) {
    bool isSelected = _selectedTag == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTag = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : const Color(0xFFF4F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}
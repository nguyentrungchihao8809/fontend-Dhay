import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../bloc/invoice_state.dart';

class TripInvoicePage extends StatefulWidget {
  const TripInvoicePage({super.key});

  @override
  State<TripInvoicePage> createState() => _TripInvoicePageState();
}

class _TripInvoicePageState extends State<TripInvoicePage> {
  @override
  void initState() {
    super.initState();
    // Gọi event lấy dữ liệu (Bỏ const ở đây để tránh lỗi constructor)
    context.read<InvoiceBloc>().add(FetchInvoiceDetails('trip_123'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          } else if (state is InvoiceError) {
            return Center(child: Text(state.message));
          } else if (state is InvoiceLoaded) {
            final invoice = state.invoice;
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 30),
                    _buildGreetingSection(invoice),
                    const SizedBox(height: 20),
                    _buildPricingSection(invoice),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: Divider(color: Colors.black, thickness: 1),
                    ),
                    _buildDriverSection(invoice),
                    _buildRouteSection(invoice),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Center(
            child: Text(
              'Chi Tiết Hóa Đơn',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(dynamic invoice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 160,
            child: Text(
              'Cảm ơn bạn đã tin tưởng và sử dụng DHAY',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(invoice.date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text(invoice.time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text(
                '${invoice.duration} | ${invoice.distance}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPricingSection(dynamic invoice) {
    String formatCurrency(double amount) {
      return amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chúng tôi hy vọng bạn sẽ có một chuyến ghép xe tuyệt vời hôm nay với DHAY.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              Text('${formatCurrency(invoice.subTotal)} VNĐ',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 15),
          _priceRow('DHAY voucher', '-${formatCurrency(invoice.voucherDiscount)} VNĐ'),
          _priceRow('DHAY cước phí', '${formatCurrency(invoice.totalFare)} VNĐ'),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
        ],
      ),
    );
  }

  Widget _buildDriverSection(dynamic invoice) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chi tiết', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.grey), // ✅ Fixed: moved child out of BoxDecoration
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(invoice.driverName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 8),
                        Text(invoice.driverRating.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const Icon(Icons.star, color: Color(0xFFFFC907), size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(invoice.vehiclePlate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection(dynamic invoice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Icon(Icons.radio_button_checked, size: 20, color: Colors.black),
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFB9B9B9),
                  ),
                ),
                const Icon(Icons.location_on, size: 20, color: Colors.black),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _locationDetail(invoice.pickupTime, invoice.pickupLocation, invoice.pickupAddress),
                  const SizedBox(height: 40),
                  _locationDetail(invoice.dropoffTime, invoice.dropoffLocation, invoice.dropoffAddress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationDetail(String time, String title, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(
          address,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
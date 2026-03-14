import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:ghepxenew/core/theme/app_colors.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/payment_method_item.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(GetPaymentMethodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paymentBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 15),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)
            ),
            boxShadow: [
              BoxShadow(color: AppColors.appBarShadow, blurRadius: 10, offset: Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 16),
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'Phương Thức Thanh Toán',
                style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is PaymentLoaded) {
            // Lấy phương thức Tiền mặt
            final cashMethod = state.methods.firstWhereOrNull((m) => m.type == 'CASH');
            // Lấy các phương thức ví điện tử
            final walletMethods = state.methods.where((m) => m.type != 'CASH').toList();

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Chọn một phương thức thanh toán\ncủa bạn.',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5
                        ),
                      ),
                      const SizedBox(height: 25),

                      // KHỐI TIỀN MẶT (NẰM RIÊNG)
                      if (cashMethod != null)
                        PaymentMethodItem(
                          method: cashMethod,
                          isSelected: state.selectedMethodId == cashMethod.id,
                          onTap: () => context.read<PaymentBloc>().add(SelectPaymentMethodEvent(cashMethod.id)),
                        ),

                      const SizedBox(height: 20),

                      // DÒNG "OR"
                      Row(
                        children: [
                          Expanded(child: Divider(thickness: 1.5, color: AppColors.black.withOpacity(0.5))),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          Expanded(child: Divider(thickness: 1.5, color: AppColors.black.withOpacity(0.5))),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // --- BOX TRẮNG CHỨA 4 PHƯƠNG THỨC VÍ (GIỐNG ẢNH 3) ---
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: AppColors.divider.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: walletMethods.map((method) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: PaymentMethodItem(
                                method: method,
                                isSelected: state.selectedMethodId == method.id,
                                isFlat: true, // Không đổ bóng cho từng item bên trong để giống ảnh
                                onTap: () => context.read<PaymentBloc>().add(SelectPaymentMethodEvent(method.id)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 180), // Khoảng trống cho bottom bar
                    ],
                  ),
                ),
                _buildBottomAction(context),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Tổng số tiền thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('30.100 VNĐ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => context.read<PaymentBloc>().add(ConfirmPaymentEvent(30100)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBlack,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
                child: const Text(
                  'Thanh Toán',
                  style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
enum VehicleType {
  MOTORBIKE("Xe máy", 2), // Bao gồm cả tài xế là 2, chỗ trống thường là 1
  CAR_4_SEATER("Ô tô 4 chỗ", 4),
  CAR_7_SEATER("Ô tô 7 chỗ", 7);

  final String label;
  final int maxCapacity;
  const VehicleType(this.label, this.maxCapacity);
}
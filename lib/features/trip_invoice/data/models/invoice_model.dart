import '../../domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.date,
    required super.time,
    required super.duration,
    required super.distance,
    required super.totalFare,
    required super.voucherDiscount,
    required super.subTotal,
    required super.driverName,
    required super.driverRating,
    required super.vehiclePlate,
    required super.pickupTime,
    required super.pickupLocation,
    required super.pickupAddress,
    required super.dropoffTime,
    required super.dropoffLocation,
    required super.dropoffAddress,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      duration: json['duration'] ?? '',
      distance: json['distance'] ?? '',
      totalFare: (json['total_fare'] as num).toDouble(),
      voucherDiscount: (json['voucher_discount'] as num).toDouble(),
      subTotal: (json['sub_total'] as num).toDouble(),
      driverName: json['driver_name'] ?? '',
      driverRating: (json['driver_rating'] as num).toDouble(),
      vehiclePlate: json['vehicle_plate'] ?? '',
      pickupTime: json['pickup_time'] ?? '',
      pickupLocation: json['pickup_location'] ?? '',
      pickupAddress: json['pickup_address'] ?? '',
      dropoffTime: json['dropoff_time'] ?? '',
      dropoffLocation: json['dropoff_location'] ?? '',
      dropoffAddress: json['dropoff_address'] ?? '',
    );
  }
}
import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String date;
  final String time;
  final String duration;
  final String distance;
  final double totalFare;
  final double voucherDiscount;
  final double subTotal;
  final String driverName;
  final double driverRating;
  final String vehiclePlate;
  final String pickupTime;
  final String pickupLocation;
  final String pickupAddress;
  final String dropoffTime;
  final String dropoffLocation;
  final String dropoffAddress;

  const InvoiceEntity({
    required this.date,
    required this.time,
    required this.duration,
    required this.distance,
    required this.totalFare,
    required this.voucherDiscount,
    required this.subTotal,
    required this.driverName,
    required this.driverRating,
    required this.vehiclePlate,
    required this.pickupTime,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.dropoffTime,
    required this.dropoffLocation,
    required this.dropoffAddress,
  });

  @override
  List<Object?> get props => [date, driverName, vehiclePlate, totalFare];
}
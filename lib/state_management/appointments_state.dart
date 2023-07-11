

import 'package:appointment_app_v2/model/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/service_model.dart';
import '../model/user_model.dart';

/// Pagination
final indexMakeAppointmentProvider = StateProvider<int>((ref) => 0);

/// Professional
final currentProfessionalProvider = StateProvider<UserModel>((ref) => UserModel(firstname: '', lastname: '', dateOfBirth: '', email: '', phone: '', role: ''));
final currentProfessionalIndexProvider = StateProvider<int>((ref) => -1);

/// Service
final currentServiceProvider = StateProvider<ServiceModel>((ref) => ServiceModel(professionalId: '', shopId: '', name: '', description: '', duration: 0, price: 0));
final currentServiceIndexProvider = StateProvider<int>((ref) => -1);

/// Appointment
final currentAppointmentProvider = StateProvider<AppointmentModel>((ref) => AppointmentModel(shopId: '', professionalId: '', clientId: '', serviceId: '', clientPhone: '', startDate: Timestamp.fromDate(DateTime.utc(1971,1,1)), endDate: Timestamp.fromDate(DateTime.utc(1971,1,1)), date: '', serviceName: '', servicePrice: 20, serviceDuration: 60, status: ''));
final currentAppointmentIndexProvider = StateProvider<int>((ref) => -1);
final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
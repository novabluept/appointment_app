
import 'package:appointment_app_v2/model/appointment_model.dart';
import 'package:appointment_app_v2/model/time_slot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/service_model.dart';
import '../model/user_model.dart';

/// Pagination
final isNavigationFromHomeProvider = StateProvider<bool>((ref) => false);
final appointmentFromAppointmentsHistoryProvider = StateProvider<AppointmentModel>((ref) => AppointmentModel(shopId: '', professionalId: '', clientId: '', serviceId: '', professionalPhone: '', professionalFirstName: '', professionalLastName: '', professionalImagePath: '', startDate: Timestamp.fromDate(DateTime.utc(1971,1,1)), endDate: Timestamp.fromDate(DateTime.utc(1971,1,1)), date: '', serviceName: '', servicePrice: 0, serviceDuration: 0, status: ''));
final currentAppointmentIndexProvider = StateProvider<int>((ref) => 0);

/// Professional
final listProfessionalsProvider = StateProvider<List<UserModel>>((ref) => []);
final currentProfessionalProvider = StateProvider<UserModel>((ref) => UserModel(firstname: '', lastname: '', dateOfBirth: '', email: '', phone: '', role: ''));
final currentProfessionalIndexProvider = StateProvider<int>((ref) => -1);

/// Service
final listServicesProvider = StateProvider<List<ServiceModel>>((ref) => []);
final currentServiceProvider = StateProvider<ServiceModel>((ref) => ServiceModel(professionalId: '', shopId: '', name: '', description: '', duration: 0, price: 0));
final currentServiceIndexProvider = StateProvider<int>((ref) => -1);

/// Appointment
final currentSlotProvider = StateProvider<TimeSlotModel>((ref) => TimeSlotModel(startTime: TimeOfDay(hour: 0,minute: 0), endTime: TimeOfDay(hour: 0,minute: 0)));
final currentSlotIndexProvider = StateProvider<int>((ref) => -1);
final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {

  static final String col_appointmentId = "appointmentId";
  static final String col_shopId = "shopId";
  static final String col_professionalId = "professionalId";
  static final String col_clientId = "clientId";
  static final String col_serviceId = "serviceId";
  static final String col_professionalPhone = "professionalPhone";
  static final String col_professionalFirstName = "professionalFirstName";
  static final String col_professionalLastName = "professionalLastName";
  static final String col_professionalImagePath = "professionalImagePath";
  static final String col_professionalImageUint8list = "professionalImageUint8list";
  static final String col_startDate = "startDate";
  static final String col_endDate = "endDate";
  static final String col_date = "date";
  static final String col_serviceName = "serviceName";
  static final String col_servicePrice = "servicePrice";
  static final String col_serviceDuration = "serviceDuration";
  static final String col_status = "status";

  String appointmentId;
  String shopId;
  String professionalId;
  String clientId;
  String serviceId;
  String professionalPhone;
  String professionalFirstName;
  String professionalLastName;
  String professionalImagePath;
  Uint8List? professionalImageUint8list;
  Timestamp startDate;
  Timestamp endDate;
  String date;
  String serviceName;
  double servicePrice;
  int serviceDuration;
  String status;

  AppointmentModel({
    this.appointmentId = '',
    required this.shopId,
    required this.professionalId,
    required this.clientId,
    required this.serviceId,
    required this.professionalPhone,
    required this.professionalFirstName,
    required this.professionalLastName,
    required this.professionalImagePath,
    this.professionalImageUint8list,
    required this.startDate,
    required this.endDate,
    required this.date,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDuration,
    required this.status,
  });

  @override
  int get hashCode =>
      appointmentId.hashCode ^
      shopId.hashCode ^
      professionalId.hashCode ^
      clientId.hashCode ^
      serviceId.hashCode ^
      professionalPhone.hashCode ^
      professionalFirstName.hashCode ^
      professionalLastName.hashCode ^
      professionalImagePath.hashCode ^
      professionalImageUint8list.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      date.hashCode ^
      serviceName.hashCode ^
      servicePrice.hashCode ^
      serviceDuration.hashCode ^
      status.hashCode;

  AppointmentModel.fromJson(Map<String, dynamic> json)
      : appointmentId = json[col_appointmentId] != null ? json[col_appointmentId] : '',
        shopId = json[col_shopId] != null ? json[col_shopId] : '',
        professionalId = json[col_professionalId] != null ? json[col_professionalId] : '',
        clientId = json[col_clientId] != null ? json[col_clientId] : '',
        serviceId = json[col_serviceId] != null ? json[col_serviceId] : '',
        professionalPhone = json[col_professionalPhone] != null ? json[col_professionalPhone] : '',
        professionalFirstName = json[col_professionalFirstName] != null ? json[col_professionalFirstName] : '',
        professionalLastName = json[col_professionalLastName] != null ? json[col_professionalLastName] : '',
        professionalImagePath = json[col_professionalImagePath] != null ? json[col_professionalImagePath] : '',
        professionalImageUint8list = json[col_professionalImageUint8list] != null ? json[col_professionalImageUint8list] : null,
        startDate = json[col_startDate] != null ? json[col_startDate] : Timestamp.fromDate(DateTime.utc(1971,1,1)),
        endDate = json[col_endDate] != null ? json[col_endDate] : Timestamp.fromDate(DateTime.utc(1971,1,1)),
        date = json[col_date] != null ? json[col_date] : '',
        serviceName = json[col_serviceName] != null ? json[col_serviceName] : '',
        servicePrice = json[col_servicePrice] != null ? double.tryParse(json[col_servicePrice].toString())! : 0.0,
        serviceDuration = json[col_serviceDuration] != null ? int.tryParse(json[col_serviceDuration].toString())! : 0,
        status = json[col_status] != null ? json[col_status] : ''
  ;

  Map<String, dynamic> toJson() => {
    col_appointmentId: appointmentId,
    col_shopId: shopId,
    col_professionalId: professionalId,
    col_clientId: clientId,
    col_serviceId: serviceId,
    col_professionalPhone : professionalPhone,
    col_professionalFirstName : professionalFirstName,
    col_professionalLastName : professionalLastName,
    col_professionalImagePath : professionalImagePath,
    col_professionalImageUint8list : professionalImageUint8list,
    col_startDate: startDate,
    col_endDate: endDate,
    col_date: date,
    col_serviceName: serviceName,
    col_servicePrice: servicePrice,
    col_serviceDuration: serviceDuration,
    col_status: status,
  };

}
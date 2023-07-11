import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {

  static final String col_appointmentId = "appointmentId";
  static final String col_shopId = "shopId";
  static final String col_professionalId = "professionalId";
  static final String col_clientId = "clientId";
  static final String col_serviceId = "serviceId";
  static final String col_clientPhone = "clientPhone";
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
  String clientPhone;
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
    required this.clientPhone,
    required this.startDate,
    required this.endDate,
    required this.date,
    required this.serviceName,
    required this.servicePrice,
    required this.serviceDuration,
    required this.status,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json)
      : appointmentId = json[col_appointmentId] != null ? json[col_appointmentId] : '',
        shopId = json[col_shopId] != null ? json[col_shopId] : '',
        professionalId = json[col_professionalId] != null ? json[col_professionalId] : '',
        clientId = json[col_clientId] != null ? json[col_clientId] : '',
        serviceId = json[col_serviceId] != null ? json[col_serviceId] : '',
        clientPhone = json[col_clientPhone] != null ? json[col_clientPhone] : '',
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
    col_clientPhone: clientPhone,
    col_startDate: startDate,
    col_endDate: endDate,
    col_date: date,
    col_serviceName: serviceName,
    col_servicePrice: servicePrice,
    col_serviceDuration: serviceDuration,
    col_status: status,
  };

}
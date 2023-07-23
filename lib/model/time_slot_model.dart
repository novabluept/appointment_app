import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeSlotModel {

  static final String col_startTime = "startTime";
  static final String col_endTime = "endTime";
  static final String col_hasAppointment = "hasAppointment";

  TimeOfDay startTime;
  TimeOfDay endTime;
  bool? hasAppointment;

  TimeSlotModel({
    required this.startTime,
    required this.endTime,
    this.hasAppointment = false
  });

  @override
  int get hashCode =>
      startTime.hashCode ^
      endTime.hashCode ^
      hasAppointment.hashCode
  ;

  TimeSlotModel.fromJson(Map<String, dynamic> json)
      : startTime = json[col_startTime] != null ? json[col_startTime] : TimeOfDay.now(),
        endTime = json[col_endTime] != null ? json[col_endTime] : TimeOfDay.now(),
        hasAppointment = json[col_hasAppointment] != null ? json[col_hasAppointment] : false
  ;

  Map<String, dynamic> toJson() => {
    col_startTime: startTime,
    col_endTime: endTime,
    col_hasAppointment: hasAppointment
  };

}
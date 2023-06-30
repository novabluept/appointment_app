import 'dart:typed_data';

class ServiceModel {

  static final String col_serviceId = "serviceId";
  static final String col_userId = "userId";
  static final String col_shopId = "shopId";
  static final String col_name = "name";
  static final String col_description = "description";
  static final String col_duration = "duration";
  static final String col_price = "price";

  String serviceId;
  String userId;
  String shopId;
  String name;
  String description;
  int duration;
  double price;

  ServiceModel({
    this.serviceId = '',
    required this.userId,
    required this.shopId,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ServiceModel &&
              runtimeType == other.runtimeType &&
              serviceId == other.serviceId &&
              userId == other.userId &&
              shopId == other.shopId &&
              name == other.name &&
              description == other.description &&
              duration == other.duration &&
              price == other.price;

  @override
  int get hashCode =>
      serviceId.hashCode ^
      userId.hashCode ^
      shopId.hashCode ^
      name.hashCode ^
      description.hashCode ^
      duration.hashCode ^
      price.hashCode;

  ServiceModel.fromJson(Map<String, dynamic> json)
      : serviceId = json[col_serviceId] != null ? json[col_serviceId] : '',
        userId = json[col_userId] != null ? json[col_userId] : '',
        shopId = json[col_shopId] != null ? json[col_shopId] : '',
        name = json[col_name] != null ? json[col_name] : '',
        description = json[col_description] != null ? json[col_description] : '',
        duration = json[col_duration] != null ? int.tryParse(json[col_duration].toString())! : 0,
        price = json[col_price] != null ? double.tryParse(json[col_price].toString())! : 0.0
  ;

  Map<String, dynamic> toJson() => {
    col_serviceId: serviceId,
    col_userId: userId,
    col_shopId: shopId,
    col_name: name,
    col_description: description,
    col_duration: duration,
    col_price: price,
  };

}

import 'dart:typed_data';

class ShopModel {

  static final String col_shopId = "shopId";
  static final String col_imagePath = "imagePath";
  static final String col_imageUnit8list = "imageUnit8list";
  static final String col_name = "name";
  static final String col_city = "city";  /// Address
  static final String col_state = "state";
  static final String col_streetName = "streetName";
  static final String col_zipCode = "zipCode";
  static final String col_professionals = "professionals";

  String shopId;
  String imagePath;
  Uint8List? imageUnit8list;
  String name;
  String city;
  String state;
  String streetName;
  String zipCode;
  List<dynamic> professionals;

  ShopModel({
    this.shopId = '',
    required this.imagePath,
    required this.imageUnit8list,
    required this.name,
    required this.city,
    required this.state,
    required this.streetName,
    required this.zipCode,
    required this.professionals,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShopModel &&
              runtimeType == other.runtimeType &&
              shopId == other.shopId &&
              imagePath == other.imagePath &&
              name == other.name &&
              city == other.city &&
              state == other.state &&
              streetName == other.streetName &&
              zipCode == other.zipCode
              ;

  @override
  int get hashCode =>
      shopId.hashCode ^
      imagePath.hashCode ^
      name.hashCode ^
      city.hashCode ^
      state.hashCode ^
      streetName.hashCode ^
      zipCode.hashCode ^
      professionals.hashCode;

  ShopModel.fromJson(Map<String, dynamic> json)
      : shopId = json[col_shopId] != null ? json[col_shopId] : '',
        imagePath = json[col_imagePath] != null ? json[col_imagePath] : '',
        imageUnit8list = json[col_imageUnit8list] != null ? json[col_imageUnit8list] : null,
        name = json[col_name] != null ? json[col_name] : '',
        city = json[col_city] != null ? json[col_city] : '',
        state = json[col_state] != null ? json[col_state] : '',
        streetName = json[col_streetName] != null ? json[col_streetName] : '',
        zipCode = json[col_zipCode] != null ? json[col_zipCode] : '',
        professionals = json[col_professionals] != null ? json[col_professionals] : '';

  Map<String, dynamic> toJson() => {
    col_shopId: shopId,
    col_imagePath: imagePath,
    col_imageUnit8list: imageUnit8list,
    col_name: name,
    col_city: city,
    col_state: state,
    col_streetName: streetName,
    col_zipCode: zipCode,
    col_professionals : professionals
  };

}
// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

class UserModel {
  UserModel({
    this.lat,
    this.lon,
    this.mcc,
    this.mnc,
    this.lac,
    this.cellid,
    this.averageSignalStrength,
    this.range,
    this.samples,
    this.changeable,
    this.radio,
    this.rnc,
    this.cid,
    this.tac,
    this.sid,
    this.nid,
    this.bid,
    this.message,
  });
  double lat;
  double lon;
  int mcc;
  int mnc;
  int lac;
  int cellid;
  int averageSignalStrength;
  int range;
  int samples;
  int changeable;
  String radio;
  int rnc;
  int cid;
  int tac;
  int sid;
  int nid;
  int bid;
  dynamic message;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      lat: (json['lat'] != null) ? json["lat"].toDouble() : null,
      lon: (json['lon'] != null) ? json["lon"].toDouble() : null,
      mcc: json["mcc"],
      mnc: json["mnc"],
      lac: json["lac"],
      cellid: json["cellid"],
      averageSignalStrength: json["averageSignalStrength"],
      range: json["range"],
      samples: json["samples"],
      changeable: json["changeable"],
      radio: json["radio"],
      rnc: json["rnc"],
      cid: json["cid"],
      tac: json["tac"],
      sid: json["sid"],
      nid: json["nid"],
      bid: json["bid"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "mcc": mcc,
        "mnc": mnc,
        "lac": lac,
        "cellid": cellid,
        "averageSignalStrength": averageSignalStrength,
        "range": range,
        "samples": samples,
        "changeable": changeable,
        "radio": radio,
        "rnc": rnc,
        "cid": cid,
        "tac": tac,
        "sid": sid,
        "nid": nid,
        "bid": bid,
        "message": message,
      };
}

import 'dart:convert';
import 'package:flutter/material.dart';

class Player {
  final String name;
  final String image;
  final String teamlogo;
  final String position;
  final String ppg;
  final String apg;
  final String rpg;
  final String fgPercentage;
  final String threePtPercentage;
  final String age;
  final String height;
  final String weight;
  final String team;
  final String jerseyNumber;
  final int teamId;
  final Color bgcolor;

  Player({
    required this.name,
    required this.image,
    required this.teamlogo,
    required this.position,
    required this.ppg,
    required this.apg,
    required this.rpg,
    this.fgPercentage = '-',
    this.threePtPercentage = '-',
    this.age = '-',
    this.height = '-',
    this.weight = '-',
    this.team = '-',
    this.jerseyNumber = '-',
    this.teamId = 0,
    required this.bgcolor,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'teamlogo': teamlogo,
      'position': position,
      'ppg': ppg,
      'apg': apg,
      'rpg': rpg,
      'fgPercentage': fgPercentage,
      'threePtPercentage': threePtPercentage,
      'age': age,
      'height': height,
      'weight': weight,
      'team': team,
      'jerseyNumber': jerseyNumber,
      'teamId': teamId,
      'bgcolorValue': bgcolor.toARGB32(),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] ?? 'Unknown',
      image: json['image'] ?? '',
      teamlogo: json['teamlogo'] ?? '',
      position: json['position'] ?? '-',
      ppg: json['ppg'] ?? '0.0',
      apg: json['apg'] ?? '0.0',
      rpg: json['rpg'] ?? '0.0',
      fgPercentage: json['fgPercentage'] ?? '-',
      threePtPercentage: json['threePtPercentage'] ?? '-',
      age: json['age'] ?? '-',
      height: json['height'] ?? '-',
      weight: json['weight'] ?? '-',
      team: json['team'] ?? '-',
      jerseyNumber: json['jerseyNumber'] ?? '-',
      teamId: json['teamId'] ?? 0,
      bgcolor: Color(json['bgcolorValue'] ?? 0xFF552583),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Player.fromJsonString(String jsonString) {
    return Player.fromJson(jsonDecode(jsonString));
  }

  Object stats() {
    return {"Ppg": ppg, "Apg": apg, "Rpg": rpg};
  }
}

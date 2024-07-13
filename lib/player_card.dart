// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Player {
  String name;
  String image;
  String teamlogo;
  String position;
  String ppg; // points per game
  String asp; // assist per game
  String rpg; // rebounds per game
  Color bgcolor;
  Object stats() {
    return {"Ppg": ppg, "Asp": asp, "Rpg": rpg};
  }

  Player(
    this.name,
    this.image,
    this.teamlogo,
    this.position,
    this.ppg,
    this.asp,
    this.rpg,
    this.bgcolor,
  );
}

List<Player> players = [
  Player(
    "Lebron\nJames",
    "assets/1.webp",
    "assets/logo1.png",
    "Forward",
    "25.7",
    "7.3",
    "8.3",
    const Color(0xff552583),
  ), // player 1

  Player(
    "Michael\nJordan",
    "assets/2.png",
    "assets/logo2.png",
    "Guard",
    "30.1",
    "6.2",
    "5.3",
    const Color(0xffce1141),
  ), // player 2

  Player(
    "Stephen\nCurry",
    "assets/3.webp",
    "assets/logo3.png",
    "Center",
    "26.4",
    "4.5",
    "5.1",
    const Color(0xff006bb6),
  ), // player 3

  Player(
    "Kobe\nBryant",
    "assets/4.png",
    "assets/logo1.png",
    "Forward-Guard",
    "25.0",
    "5.2",
    "4.7",
    const Color(0xff552583),
  ), // player 4

  Player(
    "Shaquilla\nO’Neal",
    "assets/5.png",
    "assets/logo1.png",
    "Forward",
    "23.7",
    "10.9",
    "2.5",
    const Color(0xff552583),
  ), // player 5

  Player(
    "Tim\nDuncan",
    "assets/6.png",
    "assets/logo6.png",
    "Center-Forward",
    "19.0",
    "10.8",
    "3.0",
    const Color(0xff98002e),
  ), //player 6

  Player(
    "Kevin\nDurant",
    "assets/7.webp",
    "assets/logo4.png",
    "Forward",
    "27.1",
    "6.6",
    "5.0",
    const Color(0xff1d1160),
  ), // player 7

  Player(
    "Karl\nMalone",
    "assets/8.webp",
    "assets/logo5.png",
    "Forward",
    "25.0",
    "10.1",
    "3.6",
    const Color(0xff002b5c),
  ), // player 8

  Player(
    "Jerry\nWest",
    "assets/9.png",
    "assets/logo1.png",
    "Guard",
    "27.0",
    "5.8",
    "6.7",
    const Color(0xff552583),
  ), // player 9

  Player(
    "Tony\nParker",
    "assets/10.webp",
    "assets/logo6.png",
    "Guard",
    "15.5",
    "2.7",
    "5.6",
    const Color(0xff98002e),
  ), // player 10
];

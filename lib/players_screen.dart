import 'package:basketball/player_card.dart';
import 'package:basketball/widgets/player_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3e0843),
      appBar: AppBar(
        backgroundColor: const Color(0xff3e0843),
        title: Text(
          "Top Players",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            return PlayerCardWidget(player: players[index]);
          },
        ),
      ),
    );
  }
}

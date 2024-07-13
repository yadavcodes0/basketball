import 'package:basketball/player_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../player_card.dart';

class PlayerCardWidget extends StatelessWidget {
  const PlayerCardWidget({super.key, required this.player});
  final Player player;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlayerCardScreen(player: player);
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: h * 0.2,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: player.bgcolor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Image.asset(
                player.image,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: 90,
                  image: AssetImage(
                    player.teamlogo,
                  ),
                ),
                Text(
                  player.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

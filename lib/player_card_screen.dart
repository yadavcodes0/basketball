import 'package:basketball/player_card.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerCardScreen extends StatefulWidget {
  const PlayerCardScreen({super.key, required this.player});

  final Player player;

  @override
  State<PlayerCardScreen> createState() => _PlayerCardScreenState();
}

class _PlayerCardScreenState extends State<PlayerCardScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: widget.player.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: h * 0.03, horizontal: w * 0.1)
                      .copyWith(bottom: 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        EvaIcons.arrowBack,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01),
                    child: Row(
                      children: [
                        Text(
                          widget.player.name.toUpperCase(),
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: h * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Image(
                          image: AssetImage(widget.player.teamlogo),
                          height: h * 0.15,
                        ),
                      ],
                    ),
                  ),
                  Image(
                    image: AssetImage(widget.player.image),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: widget.player.bgcolor,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Position: ${widget.player.position}",
                        style: GoogleFonts.montserrat(
                          color: widget.player.bgcolor,
                          fontSize: h * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: h * 0.04),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Statistics :-",
                          style: GoogleFonts.montserrat(
                            color: widget.player.bgcolor,
                            fontSize: h * 0.03,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Text(
                        "Points Per Game: ${widget.player.ppg}",
                        style: GoogleFonts.montserrat(
                          color: widget.player.bgcolor,
                          fontSize: h * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Text(
                        "Assist Per Game: ${widget.player.asp}",
                        style: GoogleFonts.montserrat(
                          color: widget.player.bgcolor,
                          fontSize: h * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Text(
                        "Rebounds Per Game: ${widget.player.rpg}",
                        style: GoogleFonts.montserrat(
                          color: widget.player.bgcolor,
                          fontSize: h * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

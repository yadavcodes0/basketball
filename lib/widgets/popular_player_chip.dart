import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../player_card.dart';
import '../theme/app_theme.dart';

class PopularPlayerChip extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;

  const PopularPlayerChip({
    super.key,
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    player.bgcolor,
                    player.bgcolor.withAlpha(180),
                  ],
                ),
                border: Border.all(
                  color: AppTheme.accentOrange.withAlpha(120),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: player.bgcolor.withAlpha(80),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: player.image.startsWith('http')
                    ? Image.network(
                        player.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.sports_basketball,
                          color: Colors.white.withAlpha(180),
                          size: 30,
                        ),
                      )
                    : Image.asset(
                        player.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.sports_basketball,
                          color: Colors.white.withAlpha(180),
                          size: 30,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              player.name.split(' ').first,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

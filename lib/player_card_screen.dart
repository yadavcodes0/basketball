import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player_card.dart';
import 'services/favorites_service.dart';
import 'theme/app_theme.dart';
import 'utils/responsive.dart';
import 'widgets/stat_card_widget.dart';

class PlayerCardScreen extends StatefulWidget {
  const PlayerCardScreen({super.key, required this.player});
  final Player player;

  @override
  State<PlayerCardScreen> createState() => _PlayerCardScreenState();
}

class _PlayerCardScreenState extends State<PlayerCardScreen>
    with SingleTickerProviderStateMixin {
  bool _isFavorite = false;
  late AnimationController _animController;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _checkFavorite() async {
    final fav = await FavoritesService.isFavorite(widget.player.name);
    if (mounted) setState(() => _isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesService.removeFavorite(widget.player.name);
    } else {
      await FavoritesService.addFavorite(widget.player);
    }
    if (mounted) setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final player = widget.player;
    final maxW = Responsive.contentMaxWidth(context);
    final pad = Responsive.horizontalPadding(context);
    final isWide = !Responsive.isMobile(context);
    final nameSize = Responsive.value(context, mobile: h * 0.032, tablet: 28.0, desktop: 32.0);
    final sectionFont = Responsive.value(context, mobile: 18.0, tablet: 20.0, desktop: 22.0);
    final imageH = Responsive.value(context, mobile: h * 0.28, tablet: 280.0, desktop: 320.0);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    player.bgcolor,
                    player.bgcolor.withAlpha(180),
                    AppTheme.background,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxW),
                    child: Column(
                      children: [
                        // Top bar
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: pad, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(50),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _toggleFavorite,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(50),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      _isFavorite
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      key: ValueKey(_isFavorite),
                                      size: 24,
                                      color: _isFavorite
                                          ? AppTheme.accentOrange
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Name + logo
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: pad),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      player.name.toUpperCase(),
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: nameSize,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      player.team,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white70,
                                        fontSize: isWide ? 16 : 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildTeamLogo(h),
                            ],
                          ),
                        ),
                        // Player image
                        const SizedBox(height: 8),
                        Hero(
                          tag: 'player_${player.name}',
                          child: SizedBox(
                            height: imageH,
                            child: _buildPlayerImage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Centered content below
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick info bar
                    FadeTransition(
                      opacity: _slideAnim,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: pad, vertical: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withAlpha(10)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _infoItem(Icons.tag, player.jerseyNumber),
                                _divider(),
                                _infoItem(Icons.sports_basketball, player.position),
                                _divider(),
                                _infoItem(Icons.height, player.height),
                                _divider(),
                                _infoItem(Icons.monitor_weight_outlined, player.weight),
                                _divider(),
                                _infoItem(Icons.cake_outlined, player.age),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Season statistics
                    FadeTransition(
                      opacity: _slideAnim,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(pad, 16, pad, 12),
                        child: Text(
                          'Season Statistics',
                          style: GoogleFonts.montserrat(
                            fontSize: sectionFont,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _slideAnim,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: pad),
                        child: Row(
                          children: [
                            Expanded(
                              child: StatCardWidget(
                                value: player.ppg,
                                label: 'PPG',
                                accentColor: player.bgcolor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StatCardWidget(
                                value: player.apg,
                                label: 'APG',
                                accentColor: player.bgcolor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StatCardWidget(
                                value: player.rpg,
                                label: 'RPG',
                                accentColor: player.bgcolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _slideAnim,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(pad, 10, pad, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: StatCardWidget(
                                value: '${player.fgPercentage}%',
                                label: 'FG%',
                                accentColor: player.bgcolor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StatCardWidget(
                                value: '${player.threePtPercentage}%',
                                label: '3PT%',
                                accentColor: player.bgcolor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Career info
                    FadeTransition(
                      opacity: _slideAnim,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(pad, 24, pad, 12),
                        child: Text(
                          'Career Info',
                          style: GoogleFonts.montserrat(
                            fontSize: sectionFont,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    FadeTransition(
                      opacity: _slideAnim,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: pad),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withAlpha(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _careerRow(Icons.group_outlined, 'Team', player.team),
                            const SizedBox(height: 14),
                            _careerRow(
                                Icons.emoji_events_outlined, 'Position', player.position),
                            const SizedBox(height: 14),
                            _careerRow(Icons.tag, 'Jersey', '#${player.jerseyNumber}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(double h) {
    if (widget.player.teamlogo.startsWith('http')) {
      return Image.network(
        widget.player.teamlogo,
        height: h * 0.08,
        errorBuilder: (_, __, ___) => Icon(
          Icons.sports_basketball,
          size: h * 0.06,
          color: Colors.white54,
        ),
      );
    }
    return Image.asset(
      widget.player.teamlogo,
      height: h * 0.08,
      errorBuilder: (_, __, ___) => Icon(
        Icons.sports_basketball,
        size: h * 0.06,
        color: Colors.white54,
      ),
    );
  }

  Widget _buildPlayerImage() {
    if (widget.player.image.startsWith('http')) {
      return Image.network(
        widget.player.image,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.sports_basketball,
          size: 80,
          color: Colors.white.withAlpha(100),
        ),
      );
    }
    return Image.asset(
      widget.player.image,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.sports_basketball,
        size: 80,
        color: Colors.white.withAlpha(100),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value) {
    final isWide = !Responsive.isMobile(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isWide ? 22 : 18, color: widget.player.bgcolor),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: isWide ? 13 : 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withAlpha(15),
    );
  }

  Widget _careerRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.player.bgcolor.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: widget.player.bgcolor),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 11,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

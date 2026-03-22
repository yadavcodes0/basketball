import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../player_card.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../player_card_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Player> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final favs = await FavoritesService.getFavorites();
    if (mounted) {
      setState(() {
        _favorites = favs;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(Player player) async {
    await FavoritesService.removeFavorite(player.name);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);
    final titleSize = Responsive.value(context, mobile: 28.0, tablet: 34.0, desktop: 38.0);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.contentMaxWidth(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(pad, 24, pad, 20),
                  child: Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppTheme.accentOrange, AppTheme.accentOrangeLight],
                        ).createShader(bounds),
                        child: Text(
                          'Favorites',
                          style: GoogleFonts.montserrat(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (_favorites.isNotEmpty)
                        Text(
                          '${_favorites.length} saved',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppTheme.accentOrange))
                      : _favorites.isEmpty
                          ? _buildEmptyState()
                          : _buildFavoritesGrid(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentOrange.withAlpha(20),
            ),
            child: Icon(
              Icons.sports_basketball_rounded,
              size: 60,
              color: AppTheme.accentOrange.withAlpha(100),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No favorites yet',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Search and save your\nfavorite players!',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    final pad = Responsive.horizontalPadding(context);
    final columns = Responsive.favoritesGridColumns(context);

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      color: AppTheme.accentOrange,
      backgroundColor: AppTheme.cardBackground,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: pad),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final player = _favorites[index];
          return _buildFavoriteCard(player);
        },
      ),
    );
  }

  Widget _buildFavoriteCard(Player player) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlayerCardScreen(player: player),
          ),
        );
        _loadFavorites();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.cardBackground,
              player.bgcolor.withAlpha(30),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: player.bgcolor.withAlpha(40),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: player.bgcolor.withAlpha(40),
                    ),
                    child: ClipOval(
                      child: _buildImage(player),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    player.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    player.team,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: player.bgcolor.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${player.ppg} PPG',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        color: player.bgcolor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => _removeFavorite(player),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(60),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppTheme.accentOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Player player) {
    if (player.image.startsWith('http')) {
      return Image.network(
        player.image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.sports_basketball,
          color: Colors.white.withAlpha(180),
          size: 36,
        ),
      );
    }
    return Image.asset(
      player.image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Icon(
        Icons.sports_basketball,
        color: Colors.white.withAlpha(180),
        size: 36,
      ),
    );
  }
}

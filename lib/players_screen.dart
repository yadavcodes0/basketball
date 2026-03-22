import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../player_card.dart';
import '../services/basketball_api_service.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/player_card_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/popular_player_chip.dart';
import '../data/player_data.dart';
import 'player_card_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  final TextEditingController _searchController = TextEditingController();
  List<Player> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 800), () async {
      final results = await BasketballApiService.searchPlayers(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);
    final isWide = !Responsive.isMobile(context);
    final titleSize = Responsive.value(context, mobile: 28.0, tablet: 34.0, desktop: 38.0);
    final sectionSize = Responsive.value(context, mobile: 18.0, tablet: 20.0, desktop: 22.0);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.contentMaxWidth(context),
              ),
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(pad, 24, pad, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('🏀', style: TextStyle(fontSize: isWide ? 40 : 32)),
                              const SizedBox(width: 10),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [AppTheme.accentOrange, AppTheme.accentOrangeLight],
                                ).createShader(bounds),
                                child: Text(
                                  'Hoops Search',
                                  style: GoogleFonts.montserrat(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Find any basketball player',
                            style: GoogleFonts.montserrat(
                              fontSize: isWide ? 16 : 14,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Search bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(pad, 20, pad, 0),
                      child: SearchBarWidget(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        onClear: () => _onSearchChanged(''),
                      ),
                    ),
                  ),
                  // Search results or main content
                  if (_searchController.text.isNotEmpty) ...[
                    _buildSearchResults(),
                  ] else ...[
                    // Popular Players
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(pad, 28, pad, 12),
                        child: Text(
                          'Popular Players',
                          style: GoogleFonts.montserrat(
                            fontSize: sectionSize,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: isWide ? 130 : 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: pad),
                          itemCount: fallbackPlayers.length,
                          itemBuilder: (context, index) {
                            final player = fallbackPlayers[index];
                            return PopularPlayerChip(
                              player: player,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlayerCardScreen(player: player),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    // Top Players
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(pad, 20, pad, 8),
                        child: Row(
                          children: [
                            Text(
                              'Top Players',
                              style: GoogleFonts.montserrat(
                                fontSize: sectionSize,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.sports_basketball_rounded,
                              color: AppTheme.accentOrange.withAlpha(100),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildTopPlayers(),
                  ],
                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildShimmerList(),
        ),
      );
    }
    if (_searchResults.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 60,
                color: AppTheme.textMuted.withAlpha(100),
              ),
              const SizedBox(height: 16),
              Text(
                'No players found',
                style: GoogleFonts.montserrat(
                  color: AppTheme.textMuted,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try a different search term',
                style: GoogleFonts.montserrat(
                  color: AppTheme.textMuted.withAlpha(150),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return PlayerCardWidget(player: _searchResults[index]);
        },
        childCount: _searchResults.length,
      ),
    );
  }

  Widget _buildTopPlayers() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return PlayerCardWidget(player: fallbackPlayers[index]);
        },
        childCount: fallbackPlayers.length,
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardBackground,
      highlightColor: AppTheme.cardBackgroundLight,
      child: Column(
        children: List.generate(
          4,
          (index) => Container(
            height: 90,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/forecast_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer_loading.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: _buildBody(context, provider),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider provider) {
    switch (provider.state) {
      case WeatherState.initial:
      case WeatherState.loading:
        return _buildLoadingState(context);
      case WeatherState.loaded:
        return _buildLoadedState(context, provider);
      case WeatherState.error:
        return _buildErrorState(context, provider);
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F1624), Color(0xFF1A1040)],
        ),
      ),
      child: const ShimmerLoading(),
    );
  }

  Widget _buildErrorState(BuildContext context, WeatherProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF0F1624), const Color(0xFF1A1040)]
              : [const Color(0xFFF0F2FF), const Color(0xFFE8EAFC)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage.isNotEmpty
                      ? provider.errorMessage
                      : 'Something went wrong. Please try again.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchWeatherByLocation(),
                      icon: const Icon(Icons.my_location_rounded, size: 18),
                      label: const Text('Use Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: const Text('Search City'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white70 : Colors.black54,
                        side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, WeatherProvider provider) {
    final weather = provider.weather!;
    final forecast = provider.forecast;
    final cityImage = provider.cityImage;
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    final gradient = AppColors.getWeatherGradient(
      weather.condition,
      isNight: weather.isNight,
    );

    return Stack(
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradient[0],
                gradient.length > 1 ? gradient[1] : gradient[0],
                isDark ? const Color(0xFF0F1624) : const Color(0xFFF0F2FF),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        // City background image
        if (cityImage != null)
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: CachedNetworkImage(
                imageUrl: cityImage.regularUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        // Animated weather particles
        AnimatedWeatherBackground(
          condition: weather.condition,
          isNight: weather.isNight,
          child: const SizedBox.expand(),
        ),
        // Main content
        SafeArea(
          child: RefreshIndicator(
            onRefresh: () => provider.refreshWeather(),
            color: Colors.white,
            backgroundColor: gradient[0],
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Top bar
                  _buildTopBar(context, provider, themeProvider, isDark),
                  const SizedBox(height: 20),
                  // City & Date
                  _buildCityHeader(context, weather)
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.1, duration: 500.ms),
                  const SizedBox(height: 30),
                  // Main weather display
                  WeatherCard(
                    weather: weather,
                    unitSymbol: provider.unitSymbol,
                  ).animate()
                      .fadeIn(delay: 100.ms, duration: 600.ms)
                      .scale(begin: const Offset(0.9, 0.9), delay: 100.ms, duration: 600.ms, curve: Curves.easeOut),
                  const SizedBox(height: 30),
                  // Weather details grid
                  WeatherDetailRow(
                    weather: weather,
                    windUnit: provider.windUnit,
                  ).animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms)
                      .slideY(begin: 0.1, delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: 28),
                  // Hourly forecast
                  if (forecast != null)
                    HourlyForecast(
                      items: forecast.hourlyForecasts,
                      unitSymbol: provider.unitSymbol,
                    ).animate()
                        .fadeIn(delay: 300.ms, duration: 500.ms)
                        .slideY(begin: 0.1, delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: 28),
                  // Daily forecast
                  if (forecast != null)
                    ForecastCard(
                      dailyForecasts: forecast.dailyForecasts,
                      unitSymbol: provider.unitSymbol,
                    ).animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms)
                        .slideY(begin: 0.1, delay: 400.ms, duration: 500.ms),
                  const SizedBox(height: 20),
                  // Photo credit
                  if (cityImage != null)
                    Text(
                      'Photo by ${cityImage.photographerName} on Unsplash',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 10,
                      ),
                    ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, WeatherProvider provider, ThemeProvider themeProvider, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Location button
        GlassCard(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.zero,
          borderRadius: 14,
          onTap: () => provider.fetchWeatherByLocation(),
          child: const Icon(
            Icons.my_location_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        // Actions row
        Row(
          children: [
            // Unit toggle
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: EdgeInsets.zero,
              borderRadius: 14,
              onTap: () => provider.toggleUnits(),
              child: Text(
                provider.isCelsius ? '°C' : '°F',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Theme toggle
            GlassCard(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.zero,
              borderRadius: 14,
              onTap: () => themeProvider.toggleTheme(),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            // Search
            GlassCard(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.zero,
              borderRadius: 14,
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SearchScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        )),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCityHeader(BuildContext context, weather) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d').format(now);
    final timeStr = DateFormat('h:mm a').format(now);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 18,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
            Text(
              '${weather.cityName}, ${weather.country}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$dateStr  •  $timeStr',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

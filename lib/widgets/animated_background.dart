import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedWeatherBackground extends StatefulWidget {
  final String condition;
  final bool isNight;
  final Widget child;

  const AnimatedWeatherBackground({
    super.key,
    required this.condition,
    required this.isNight,
    required this.child,
  });

  @override
  State<AnimatedWeatherBackground> createState() => _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _glowController;
  late List<WeatherParticle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _particles = _generateParticles();
  }

  List<WeatherParticle> _generateParticles() {
    final type = _getParticleType();
    final count = type == ParticleType.rain
        ? 60
        : type == ParticleType.snow
            ? 40
            : type == ParticleType.stars
                ? 30
                : 15;

    return List.generate(count, (index) => WeatherParticle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: _random.nextDouble() * 3 + 1,
      speed: _random.nextDouble() * 0.5 + 0.3,
      opacity: _random.nextDouble() * 0.6 + 0.2,
      wobble: _random.nextDouble() * 2 * pi,
    ));
  }

  ParticleType _getParticleType() {
    final condition = widget.condition.toLowerCase();
    if (condition.contains('rain') || condition.contains('drizzle') || condition.contains('shower')) {
      return ParticleType.rain;
    } else if (condition.contains('snow')) {
      return ParticleType.snow;
    } else if (condition.contains('thunder')) {
      return ParticleType.rain;
    } else if (widget.isNight) {
      return ParticleType.stars;
    } else if (condition.contains('cloud')) {
      return ParticleType.clouds;
    }
    return ParticleType.sun;
  }

  @override
  void didUpdateWidget(AnimatedWeatherBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.condition != widget.condition || oldWidget.isNight != widget.isNight) {
      _particles = _generateParticles();
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: WeatherParticlePainter(
                particles: _particles,
                progress: _particleController.value,
                type: _getParticleType(),
                isNight: widget.isNight,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Glow effect
        AnimatedBuilder(
          animation: _glowController,
          builder: (context, child) {
            final particleType = _getParticleType();
            if (particleType == ParticleType.sun) {
              return Positioned(
                top: -80,
                right: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(
                          alpha: 0.15 + _glowController.value * 0.1,
                        ),
                        blurRadius: 80 + _glowController.value * 30,
                        spreadRadius: 20 + _glowController.value * 10,
                      ),
                    ],
                  ),
                ),
              );
            } else if (widget.isNight) {
              return Positioned(
                top: -60,
                left: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200.withValues(
                          alpha: 0.08 + _glowController.value * 0.05,
                        ),
                        blurRadius: 60 + _glowController.value * 20,
                        spreadRadius: 10 + _glowController.value * 5,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // Child content
        widget.child,
      ],
    );
  }
}

enum ParticleType { rain, snow, sun, clouds, stars }

class WeatherParticle {
  double x, y, size, speed, opacity, wobble;

  WeatherParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.wobble,
  });
}

class WeatherParticlePainter extends CustomPainter {
  final List<WeatherParticle> particles;
  final double progress;
  final ParticleType type;
  final bool isNight;

  WeatherParticlePainter({
    required this.particles,
    required this.progress,
    required this.type,
    required this.isNight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final adjustedProgress = (progress + particle.y) % 1.0;

      switch (type) {
        case ParticleType.rain:
          _drawRainDrop(canvas, size, particle, adjustedProgress);
          break;
        case ParticleType.snow:
          _drawSnowflake(canvas, size, particle, adjustedProgress);
          break;
        case ParticleType.stars:
          _drawStar(canvas, size, particle, adjustedProgress);
          break;
        case ParticleType.sun:
          _drawSunMote(canvas, size, particle, adjustedProgress);
          break;
        case ParticleType.clouds:
          _drawCloudPuff(canvas, size, particle, adjustedProgress);
          break;
      }
    }
  }

  void _drawRainDrop(Canvas canvas, Size size, WeatherParticle particle, double progress) {
    final x = particle.x * size.width;
    final y = progress * size.height;
    final paint = Paint()
      ..color = Colors.blue.shade200.withValues(alpha: particle.opacity * 0.5)
      ..strokeWidth = particle.size * 0.6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(x, y),
      Offset(x - 2, y + 12 + particle.size * 3),
      paint,
    );
  }

  void _drawSnowflake(Canvas canvas, Size size, WeatherParticle particle, double progress) {
    final wobbleOffset = sin(progress * 2 * pi + particle.wobble) * 15;
    final x = particle.x * size.width + wobbleOffset;
    final y = progress * size.height;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: particle.opacity * 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), particle.size * 1.5, paint);
  }

  void _drawStar(Canvas canvas, Size size, WeatherParticle particle, double progress) {
    final x = particle.x * size.width;
    final y = particle.y * size.height;
    final twinkle = (sin(progress * 2 * pi + particle.wobble) + 1) / 2;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: twinkle * particle.opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), particle.size * 0.8, paint);
  }

  void _drawSunMote(Canvas canvas, Size size, WeatherParticle particle, double progress) {
    final drift = sin(progress * 2 * pi + particle.wobble) * 10;
    final x = particle.x * size.width + drift;
    final floatY = sin(progress * pi + particle.wobble) * 20;
    final y = particle.y * size.height + floatY;
    final paint = Paint()
      ..color = Colors.amber.withValues(alpha: particle.opacity * 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), particle.size * 2.5, paint);
  }

  void _drawCloudPuff(Canvas canvas, Size size, WeatherParticle particle, double progress) {
    final drift = progress * size.width * 0.1 + particle.x * size.width;
    final x = drift % size.width;
    final y = particle.y * size.height * 0.5;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: particle.opacity * 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), particle.size * 12, paint);
  }

  @override
  bool shouldRepaint(covariant WeatherParticlePainter oldDelegate) => true;
}

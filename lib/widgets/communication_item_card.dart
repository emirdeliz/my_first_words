import 'package:flutter/material.dart';
import '../models/communication_item.dart';
import '../models/theme_model.dart';

class CommunicationItemCard extends StatefulWidget {
  final CommunicationItem item;
  final AppTheme theme;
  final VoidCallback onTap;

  const CommunicationItemCard({
    super.key,
    required this.item,
    required this.theme,
    required this.onTap,
  });

  @override
  State<CommunicationItemCard> createState() => _CommunicationItemCardState();
}

class _CommunicationItemCardState extends State<CommunicationItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _shadowAnimation = Tween<double>(
      begin: 4.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _animationController.forward();
  }

  void _onTapUp() {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapCancel(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: _shadowAnimation.value,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.08),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ícone/Emoji grande com brilho divertido
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _pastelVariant(
                                  widget.theme.getItemColor(widget.item.type),
                                  widget.item.icon,
                                  saturation: 0.35,
                                  lightness: 0.90,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.20),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            _buildIconOrEmoji(widget.item.icon, widget.item.type, widget.theme.getItemColor(widget.item.type)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Texto com estilo melhorado
                        Text(
                          widget.item.text,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.theme.text,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Indicador de categoria
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getCategoryDisplayName(widget.item.type),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.theme.getItemColor(widget.item.type),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategoryDisplayName(String type) {
    switch (type) {
      case 'basic':
        return 'Necessidades';
      case 'emotions':
        return 'Emoções';
      case 'activities':
        return 'Atividades';
      case 'social':
        return 'Social';
      default:
        return type;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'sentiment_satisfied':
        return Icons.sentiment_satisfied;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'people':
        return Icons.people;
      case 'local_drink':
        return Icons.local_drink;
      case 'wc':
        return Icons.wc;
      case 'bedtime':
        return Icons.bedtime;
      case 'healing':
        return Icons.healing;
      case 'help':
        return Icons.help;
      case 'sentiment_dissatisfied':
        return Icons.sentiment_dissatisfied;
      case 'mood_bad':
        return Icons.mood_bad;
      case 'sentiment_very_dissatisfied':
        return Icons.sentiment_very_dissatisfied;
      case 'sentiment_very_satisfied':
        return Icons.sentiment_very_satisfied;
      case 'sentiment_neutral':
        return Icons.sentiment_neutral;
      case 'book':
        return Icons.book;
      case 'brush':
        return Icons.brush;
      case 'waving_hand':
        return Icons.waving_hand;
      case 'favorite':
        return Icons.favorite;
      case 'thumb_up':
        return Icons.thumb_up;
      case 'thumb_down':
        return Icons.thumb_down;
      case 'toys':
        return Icons.toys;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'pan_tool':
        return Icons.pan_tool;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'check_circle':
        return Icons.check_circle;
      case 'cancel':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  // Constrói apenas ícone Material (sem emojis). Se vier emoji, cai no ícone da categoria
  Widget _buildIconOrEmoji(String iconName, String type, Color color) {
    final String effectiveIcon = iconName.startsWith('emoji:') ? _defaultIconNameForType(type) : iconName;
    return Icon(
      _getIconData(effectiveIcon),
      size: 36,
      color: _pastelVariant(color, effectiveIcon, saturation: 0.45, lightness: 0.72),
    );
  }

  String _getBadgeEmoji(String type) {
    switch (type) {
      case 'basic':
        return '';
      case 'emotions':
        return '';
      case 'activities':
        return '';
      case 'social':
        return '';
      default:
        return '';
    }
  }

  String _defaultIconNameForType(String type) {
    switch (type) {
      case 'basic':
        return 'restaurant';
      case 'emotions':
        return 'sentiment_satisfied';
      case 'activities':
        return 'sports_esports';
      case 'social':
        return 'people';
      default:
        return 'help';
    }
  }

  Color _toPastel(Color base) {
    final hsl = HSLColor.fromColor(base);
    final hslPastel = hsl
        .withSaturation((hsl.saturation * 0.35).clamp(0.0, 1.0))
        .withLightness((hsl.lightness * 0.85 + 0.15).clamp(0.0, 1.0));
    return hslPastel.toColor();
  }

  // Gera uma variação pastel determinística a partir de uma cor base e uma seed (ex.: nome do ícone)
  Color _pastelVariant(Color base, String seed, {double saturation = 0.35, double lightness = 0.85, double hueDeltaDegrees = 18}) {
    final hsl = HSLColor.fromColor(base);
    final int hash = seed.codeUnits.fold(0, (acc, c) => acc + c);
    final int deltaIndex = (hash % 5) - 2; // -2..2
    final double newHue = (hsl.hue + deltaIndex * hueDeltaDegrees) % 360;
    final HSLColor shifted = hsl
        .withHue(newHue)
        .withSaturation((hsl.saturation * saturation).clamp(0.0, 1.0))
        .withLightness(lightness.clamp(0.0, 1.0));
    return shifted.toColor();
  }
}

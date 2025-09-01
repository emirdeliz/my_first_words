import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/communication_item.dart';
import '../models/theme_model.dart';
import '../providers/language_provider.dart';

class CommunicationItemCard extends StatefulWidget {
  final CommunicationItem item;
  final AppTheme theme;
  final VoidCallback onTap;
  final LanguageProvider languageProvider;

  const CommunicationItemCard({
    super.key,
    required this.item,
    required this.theme,
    required this.onTap,
    required this.languageProvider,
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
                        // Ícone isométrico sem background
                        _buildFunImage(widget.item.icon, widget.item.type, widget.theme.getItemColor(widget.item.type)),
                        const SizedBox(height: 8),
                        // Texto com estilo melhorado
                        Text(
                          widget.item.text,
                          style: TextStyle(
                            fontSize: 15,
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
                            color: _vibrantVariant(widget.theme.getItemColor(widget.item.type), widget.item.type).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _vibrantVariant(widget.theme.getItemColor(widget.item.type), widget.item.type).withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getCategoryDisplayName(widget.item.type),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _vibrantVariant(widget.theme.getItemColor(widget.item.type), widget.item.type),
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
        return widget.languageProvider.getTranslation('categories.basicNeeds');
      case 'emotions':
        return widget.languageProvider.getTranslation('categories.emotions');
      case 'activities':
        return widget.languageProvider.getTranslation('categories.activities');
      case 'social':
        return widget.languageProvider.getTranslation('categories.social');
      default:
        return type;
    }
  }

  // Método _getIconData removido - agora usa apenas imagens PNG personalizadas

  // Constrói imagem divertida baseada no tipo e ícone
  Widget _buildFunImage(String iconName, String type, Color color) {
    final String imageName = _getImageName(iconName, type);
    
    return _buildImageOrIcon(imageName, color);
  }
  
  Widget _buildImageOrIcon(String imageName, Color color) {
    return Image.asset(
      'assets/images/fun/$imageName.png',
      width: 48,
      height: 48,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              imageName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
  

  
  String _getImageName(String iconName, String type) {
    // Mapeamento de ícones para nomes de imagem divertidos
    switch (iconName) {
      // Necessidades básicas
      case 'restaurant':
        return 'food';
      case 'local_drink':
        return 'drink';
      case 'wc':
        return 'bathroom';
      case 'bedtime':
        return 'sleep';
      case 'healing':
        return 'medicine';
      case 'help':
        return 'help';
      
      // Emoções
      case 'sentiment_satisfied':
        return 'happy';
      case 'sentiment_dissatisfied':
        return 'sad';
      case 'mood_bad':
        return 'angry';
      case 'sentiment_very_dissatisfied':
        return 'scared';
      case 'sentiment_very_satisfied':
        return 'excited';
      case 'sentiment_neutral':
        return 'tired';
      
      // Atividades
      case 'sports_esports':
        return 'play';
      case 'book':
        return 'read';
      case 'brush':
        return 'draw';
      case 'toys':
        return 'toys';
      
      // Social
      case 'waving_hand':
        return 'hello';
      case 'favorite':
        return 'love';
      case 'thumb_up':
        return 'yes';
      case 'thumb_down':
        return 'no';
      case 'pan_tool':
        return 'da';
      case 'add_circle':
        return 'more';
      
      default:
        return iconName;
    }
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
  
  // Gera uma variação vibrante determinística a partir de uma cor base e uma seed
  Color _vibrantVariant(Color base, String seed, {double saturation = 0.85, double lightness = 0.65, double hueDeltaDegrees = 25}) {
    final hsl = HSLColor.fromColor(base);
    final int hash = seed.codeUnits.fold(0, (acc, c) => acc + c);
    final int deltaIndex = (hash % 7) - 3; // -3..3
    final double newHue = (hsl.hue + deltaIndex * hueDeltaDegrees) % 360;
    final HSLColor shifted = hsl
        .withHue(newHue)
        .withSaturation(saturation.clamp(0.0, 1.0))
        .withLightness(lightness.clamp(0.0, 1.0));
    return shifted.toColor();
  }
}

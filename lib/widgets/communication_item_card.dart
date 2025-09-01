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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.1),
                          widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ícone com efeito de brilho
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.2),
                            boxShadow: [
                              BoxShadow(
                                color: widget.theme.getItemColor(widget.item.type).withValues(alpha: 0.3),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            _getIconData(widget.item.icon),
                            size: 32,
                            color: widget.theme.getItemColor(widget.item.type),
                          ),
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
}

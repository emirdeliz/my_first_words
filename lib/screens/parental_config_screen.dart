import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parental_config_provider.dart';
import '../providers/language_provider.dart';
import '../models/parental_config_model.dart';

class ParentalConfigScreen extends StatefulWidget {
  const ParentalConfigScreen({super.key});

  @override
  State<ParentalConfigScreen> createState() => _ParentalConfigScreenState();
}

class _ParentalConfigScreenState extends State<ParentalConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração Parental'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<ParentalConfigProvider, LanguageProvider>(
        builder: (context, parentalProvider, languageProvider, child) {
          final config = parentalProvider.config;
          final translation = languageProvider.getTranslation;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.family_restroom,
                              size: 28,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Configuração Parental',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Configure quais áudios estarão disponíveis para a criança no app principal.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Ações globais
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => parentalProvider.enableAllItems(),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Habilitar Todos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => parentalProvider.disableAllItems(),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Desabilitar Todos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Categorias
                Text(
                  'Categorias',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8, // Ajustado para evitar overflow
                    ),
                    itemCount: ParentalConfigProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = ParentalConfigProvider.categories[index];
                      final categoryId = category['id'] as String;
                      final categoryName = category['name'] as String;
                      final iconName = category['icon'] as String;
                      final color = Color(category['color'] as int);
                      final stats = parentalProvider.getCategoryStats(categoryId);

                      return Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () {
                            // Mostrar o modal
                            showDialog(
                              context: context,
                              builder: (context) => CategoryConfigModal(
                                categoryId: categoryId,
                                categoryName: _getCategoryDisplayName(categoryName, translation),
                                onToggleItem: parentalProvider.toggleAudioItem,
                                onEnableAll: () {
                                  parentalProvider.enableAllInCategory(categoryId);
                                  Navigator.of(context).pop();
                                },
                                onDisableAll: () {
                                  parentalProvider.disableAllInCategory(categoryId);
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getIconData(iconName),
                                  size: 48,
                                  color: color,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _getCategoryDisplayName(categoryName, translation),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    stats,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCategoryDisplayName(String categoryKey, Function translation) {
    switch (categoryKey) {
      case 'basicNeeds':
        return 'Necessidades Básicas';
      case 'emotions':
        return 'Emoções';
      case 'activities':
        return 'Atividades';
      case 'social':
        return 'Social';
      default:
        return categoryKey;
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
      default:
        return Icons.help;
    }
  }
}

// Modal para configurar itens de uma categoria
class CategoryConfigModal extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final Function(String) onToggleItem;
  final VoidCallback onEnableAll;
  final VoidCallback onDisableAll;

  const CategoryConfigModal({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.onToggleItem,
    required this.onEnableAll,
    required this.onDisableAll,
  });

  @override
  State<CategoryConfigModal> createState() => _CategoryConfigModalState();
}

class _CategoryConfigModalState extends State<CategoryConfigModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Consumer<ParentalConfigProvider>(
          builder: (context, parentalProvider, child) {
            final items = parentalProvider.config.enabledAudioItems
                .where((item) => item.categoryId == widget.categoryId)
                .toList();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho do modal
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Configurar ${widget.categoryName}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Ações da categoria
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onEnableAll();
                          setState(() {}); // Força atualização da UI
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Habilitar Todos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onDisableAll();
                          setState(() {}); // Força atualização da UI
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Desabilitar Todos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Lista de itens
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            _getIconData(item.icon),
                            color: item.isEnabled 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey,
                          ),
                          title: Text(
                            item.text,
                            style: TextStyle(
                              color: item.isEnabled 
                                  ? Theme.of(context).colorScheme.onSurface 
                                  : Colors.grey,
                            ),
                          ),
                          trailing: Switch(
                            value: item.isEnabled,
                            onChanged: (value) {
                              widget.onToggleItem(item.id);
                              setState(() {}); // Força atualização da UI
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
      default:
        return Icons.help;
    }
  }
}

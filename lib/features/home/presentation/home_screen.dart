import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/theme_provider.dart';

/// Home screen demonstrating the Tree App theme and features
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree App'),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              themeModeNotifier.isDarkMode(context)
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => themeModeNotifier.toggleTheme(),
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLightGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.park,
                            size: 32,
                            color: AppColors.primaryForestGreen,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to Tree App',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your nature companion',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Color palette section
            Text(
              'Color Palette',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ColorChip(
                  color: AppColors.primaryForestGreen,
                  label: 'Primary',
                ),
                _ColorChip(
                  color: AppColors.secondaryLightGreen,
                  label: 'Secondary',
                ),
                _ColorChip(
                  color: AppColors.accentGoldenYellow,
                  label: 'Accent',
                ),
                _ColorChip(
                  color: AppColors.backgroundWarmOffWhite,
                  label: 'Background',
                  textColor: AppColors.textPrimaryLight,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Typography section
            Text(
              'Typography',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Headline (Poppins)',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Body text uses Inter font for excellent readability. This font is perfect for long-form content and user interfaces.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Title Medium',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Secondary body text for less important content.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons section
            Text(
              'Buttons',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Theme mode indicator
            Text(
              'Current Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : themeMode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.brightness_auto,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  themeMode == ThemeMode.dark
                      ? 'Dark Mode'
                      : themeMode == ThemeMode.light
                          ? 'Light Mode'
                          : 'System Mode',
                ),
                subtitle: const Text('Tap the icon in the app bar to toggle'),
                trailing: Switch(
                  value: themeModeNotifier.isDarkMode(context),
                  onChanged: (_) => themeModeNotifier.toggleTheme(),
                  activeColor: AppColors.secondaryLightGreen,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Input field demo
            Text(
              'Input Field',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter text',
                hintText: 'Type something...',
                prefixIcon: Icon(Icons.edit),
              ),
            ),

            const SizedBox(height: 24),

            // Chips section
            Text(
              'Chips',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.eco, size: 18),
                  label: const Text('Nature'),
                ),
                Chip(
                  avatar: const Icon(Icons.forest, size: 18),
                  label: const Text('Forest'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Add Tag'),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Action',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Helper widget for displaying color chips
class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.color,
    required this.label,
    this.textColor = Colors.white,
  });

  final Color color;
  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

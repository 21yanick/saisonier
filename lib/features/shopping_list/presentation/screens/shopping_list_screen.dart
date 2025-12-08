import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/shopping_list/presentation/state/shopping_list_controller.dart';
import 'package:saisonier/features/shopping_list/presentation/widgets/shopping_item_tile.dart';
import 'package:saisonier/features/shopping_list/presentation/widgets/generate_dialog.dart';
import 'package:saisonier/features/profile/presentation/widgets/bring_auth_dialog.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  final _addController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final itemsAsync = ref.watch(shoppingItemsProvider);

    // Trigger initial sync
    ref.watch(nativeShoppingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einkaufsliste'),
        automaticallyImplyLeading: false, // Kein Back-Button als Tab
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'remove_checked',
                child: Text('Abgehakte entfernen'),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Alles löschen'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return _buildLoginPrompt(context);
          }
          return _buildContent(context, itemsAsync);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Deine Einkaufsliste',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Melde dich an, um deine Einkaufsliste zu verwalten.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/profile'),
              icon: const Icon(Icons.login),
              label: const Text('Anmelden'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AsyncValue<List<ShoppingItem>> itemsAsync) {
    return itemsAsync.when(
      data: (items) {
        return Column(
          children: [
            // Generate button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _showGenerateDialog,
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Aus Wochenplan generieren'),
                ),
              ),
            ),

            // Items list
            Expanded(
              child: items.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: items.length + 1, // +1 for add field
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return _buildAddField();
                        }
                        final item = items[index];
                        return ShoppingItemTile(
                          item: item,
                          onToggle: () => _toggleItem(item.id, !item.isChecked),
                          onDelete: () => _removeItem(item.id),
                        );
                      },
                    ),
            ),

            // Bottom actions
            _buildBottomActions(items),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Keine Einträge',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Generiere aus dem Wochenplan oder füge manuell hinzu.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        _buildAddField(),
      ],
    );
  }

  Widget _buildAddField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _addController,
              decoration: InputDecoration(
                hintText: 'Manuell hinzufügen...',
                prefixIcon: const Icon(Icons.add),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _addManualItem(),
            ),
          ),
          if (_addController.text.isNotEmpty || _isAdding) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: _isAdding ? null : _addManualItem,
              icon: _isAdding
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActions(List<ShoppingItem> items) {
    final hasUnchecked = items.any((item) => !item.isChecked);

    return Padding(
      // 90px bottom für die Pills (30px position + 50px höhe + 10px abstand)
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: hasUnchecked ? _exportToBring : null,
              icon: const Icon(Icons.send),
              label: const Text('An Bring senden'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: hasUnchecked ? () => _shareAsText(items) : null,
              icon: const Icon(Icons.share),
              label: const Text('Teilen'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'remove_checked':
        await ref.read(nativeShoppingControllerProvider.notifier).removeChecked();
        break;
      case 'clear_all':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Alles löschen?'),
            content: const Text('Alle Einträge werden gelöscht.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Abbrechen'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Löschen'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await ref.read(nativeShoppingControllerProvider.notifier).clearAll();
        }
        break;
    }
  }

  void _showGenerateDialog() async {
    final replace = await showDialog<bool>(
      context: context,
      builder: (context) => const GenerateDialog(),
    );

    if (replace == null) return;

    if (!mounted) return;

    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generiere Einkaufsliste...')),
    );

    final count = await ref
        .read(nativeShoppingControllerProvider.notifier)
        .generateFromWeekplan(replace: replace);

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(count > 0
            ? '$count Zutaten ${replace ? 'generiert' : 'hinzugefügt'}'
            : 'Keine Rezepte im Wochenplan gefunden'),
      ),
    );
  }

  void _toggleItem(String id, bool isChecked) {
    ref.read(nativeShoppingControllerProvider.notifier).toggleItem(id, isChecked);
  }

  void _removeItem(String id) {
    ref.read(nativeShoppingControllerProvider.notifier).removeItem(id);
  }

  void _addManualItem() async {
    final text = _addController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isAdding = true);

    await ref.read(nativeShoppingControllerProvider.notifier).addManualItem(text);

    _addController.clear();
    setState(() => _isAdding = false);
  }

  void _exportToBring() async {
    // Check Bring connection
    final isConnected = await ref.read(shoppingListControllerProvider.future);

    if (!isConnected) {
      if (!mounted) return;
      final success = await showDialog<bool>(
        context: context,
        builder: (context) => const BringAuthDialog(),
      );
      if (success != true) return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sende zu Bring...')),
    );

    final count = await ref.read(nativeShoppingControllerProvider.notifier).exportToBring();

    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$count Zutaten zu Bring! hinzugefügt')),
    );
  }

  void _shareAsText(List<ShoppingItem> items) {
    final unchecked = items.where((item) => !item.isChecked).toList();
    if (unchecked.isEmpty) return;

    final text = unchecked.map((item) {
      final parts = <String>[];
      final amount = item.amount;
      // Only show amount if present and > 0
      if (amount != null && amount > 0) {
        final amountStr = amount == amount.roundToDouble()
            ? amount.toInt().toString()
            : amount.toStringAsFixed(1);
        parts.add(amountStr);

        // Only show unit if we have an amount
        final unit = item.unit;
        if (unit != null && unit.isNotEmpty) {
          parts.add(unit);
        }
      }
      parts.add(item.item);
      return '- ${parts.join(' ')}';
    }).join('\n');

    // Copy to clipboard (simple sharing)
    Clipboard.setData(ClipboardData(text: 'Einkaufsliste:\n$text'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('In Zwischenablage kopiert')),
    );
  }
}

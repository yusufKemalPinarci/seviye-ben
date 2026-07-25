import 'package:flutter/material.dart';

import '../../models/stat_type.dart';

class HabitFormSheet extends StatefulWidget {
  const HabitFormSheet({
    super.key,
    this.initialTitle = '',
    this.initialStat = StatType.strength,
    this.isEditing = false,
  });

  final String initialTitle;
  final StatType initialStat;
  final bool isEditing;

  @override
  State<HabitFormSheet> createState() => _HabitFormSheetState();
}

/// Eski import uyumluluğu.
typedef AddHabitSheet = HabitFormSheet;

class _HabitFormSheetState extends State<HabitFormSheet> {
  late final TextEditingController _controller;
  late StatType _stat;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
    _stat = widget.initialStat;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.isEditing ? 'Alışkanlığı düzenle' : 'Yeni alışkanlık',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Ne yapacaksın?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<StatType>(
            initialValue: _stat,
            decoration: const InputDecoration(
              labelText: 'İstatistik',
              border: OutlineInputBorder(),
            ),
            items: StatType.values
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.labelTr),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _stat = v);
              }
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              final title = _controller.text.trim();
              if (title.isEmpty) {
                return;
              }
              Navigator.pop(context, (title: title, stat: _stat));
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

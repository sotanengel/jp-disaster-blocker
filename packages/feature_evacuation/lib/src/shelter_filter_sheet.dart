import 'package:flutter/material.dart';

import 'disaster_type.dart';

class ShelterFilterSheet extends StatefulWidget {
  const ShelterFilterSheet({required this.selected, super.key});

  final List<DisasterType> selected;

  @override
  State<ShelterFilterSheet> createState() => _ShelterFilterSheetState();
}

class _ShelterFilterSheetState extends State<ShelterFilterSheet> {
  late List<DisasterType> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.of(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '災害種別フィルタ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...DisasterType.values.map(
              (type) => CheckboxListTile(
                title: Text(type.label),
                value: _selected.contains(type),
                onChanged: (checked) => setState(() {
                  if (checked ?? false) {
                    _selected.add(type);
                  } else {
                    _selected.remove(type);
                  }
                }),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => setState(() => _selected.clear()),
                  child: const Text('クリア'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: const Text('適用'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

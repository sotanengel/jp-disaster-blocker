// ignore_for_file: public_member_api_docs

import 'package:feature_checklist/src/checklist_item.dart';
import 'package:feature_checklist/src/checklist_repository.dart';
import 'package:feature_checklist/src/checklist_scenario.dart';
import 'package:flutter/material.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({
    required this.scenario,
    super.key,
    this.repository,
  });

  final ChecklistScenario scenario;
  final ChecklistRepository? repository;

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  late final List<ChecklistItem> _items;
  final Set<String> _checked = {};

  @override
  void initState() {
    super.initState();
    final repo = widget.repository ?? StaticChecklistRepository();
    _items = repo.itemsFor(widget.scenario);
  }

  void _toggle(String id) {
    setState(() {
      if (_checked.contains(id)) {
        _checked.remove(id);
      } else {
        _checked.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkedCount = _checked.length;
    final totalCount = _items.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenario.label),
        actions: [
          if (checkedCount > 0)
            TextButton(
              onPressed: () => setState(_checked.clear),
              child: const Text('リセット'),
            ),
        ],
      ),
      body: Column(
        children: [
          _ProgressHeader(checked: checkedCount, total: totalCount),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isChecked = _checked.contains(item.id);
                return CheckboxListTile(
                  value: isChecked,
                  onChanged: (_) => _toggle(item.id),
                  title: Text(
                    item.title,
                    style: isChecked
                        ? TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Theme.of(context).disabledColor,
                          )
                        : null,
                  ),
                  subtitle: item.detail != null ? Text(item.detail!) : null,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.checked, required this.total});

  final int checked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : checked / total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$checked / $total 完了',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }
}

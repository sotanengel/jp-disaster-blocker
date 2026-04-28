import 'package:feature_checklist/feature_checklist.dart';
import 'package:flutter/material.dart';

/// シナリオ選択から [ChecklistPage] へ遷移する（LLM 非依存の防災チェックリスト）。
class ChecklistHomePage extends StatelessWidget {
  const ChecklistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('状況別チェックリスト')),
      body: ListView(
        children: [
          for (final s in ChecklistScenario.values)
            ListTile(
              title: Text(s.label),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => ChecklistPage(scenario: s),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

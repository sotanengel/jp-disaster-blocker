import 'package:feature_evacuation/feature_evacuation.dart';
import 'package:feature_map/feature_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'checklist_home_page.dart';
import 'providers.dart';
import 'route_page.dart';

/// 既存 feature を横断結線するシェル（feature 同士は直接依存しない）。
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: '地図',
          ),
          NavigationDestination(
            icon: Icon(Icons.place_outlined),
            selectedIcon: Icon(Icons.place),
            label: '避難所',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'チェック',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_walk_outlined),
            selectedIcon: Icon(Icons.directions_walk),
            label: 'ルート',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_index) {
      case 0:
        return MapPage(
          initialCenter: const LatLng(kDefaultLat, kDefaultLng),
          initialZoom: 13,
        );
      case 1:
        final repoAsync = ref.watch(shelterRepositoryProvider);
        final locAsync = ref.watch(effectiveLocationProvider);
        return repoAsync.when(
          data: (repo) => locAsync.when(
            data: (pos) => ShelterListPage(
              repository: repo,
              currentLat: pos.lat,
              currentLng: pos.lng,
            ),
            loading: () => const _CenteredProgress(message: '位置を取得中…'),
            error: (e, _) => _CenteredMessage(text: '位置エラー: $e'),
          ),
          loading: () => const _CenteredProgress(message: 'データベースを開いています…'),
          error: (e, _) => _CenteredMessage(text: 'DB エラー: $e'),
        );
      case 2:
        return const ChecklistHomePage();
      case 3:
        return ref
            .watch(routingServiceProvider)
            .when(
              data: (_) => const RoutePage(),
              loading: () => const _CenteredProgress(message: 'ルーティング初期化中…'),
              error: (e, _) => _CenteredMessage(text: '初期化エラー: $e'),
            );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _CenteredProgress extends StatelessWidget {
  const _CenteredProgress({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

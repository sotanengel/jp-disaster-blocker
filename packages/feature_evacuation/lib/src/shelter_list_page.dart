import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'disaster_type.dart';
import 'shelter.dart';
import 'shelter_filter_sheet.dart';
import 'shelter_repository.dart';

class ShelterListPage extends StatefulWidget {
  const ShelterListPage({
    required this.repository,
    required this.currentLat,
    required this.currentLng,
    super.key,
  });

  final ShelterRepository repository;
  final double currentLat;
  final double currentLng;

  @override
  State<ShelterListPage> createState() => _ShelterListPageState();
}

class _ShelterListPageState extends State<ShelterListPage> {
  List<DisasterType> _activeFilters = [];
  List<Shelter>? _shelters;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await widget.repository.findNearby(
      lat: widget.currentLat,
      lng: widget.currentLng,
      radiusKm: 10,
      filterTypes: _activeFilters,
    );

    if (!mounted) return;

    switch (result) {
      case Ok(:final value):
        setState(() {
          _shelters = value;
          _loading = false;
        });
      case Err(:final error):
        setState(() {
          _error = error.message;
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('近くの避難所'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _activeFilters.isNotEmpty,
              label: Text(_activeFilters.length.toString()),
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(onPressed: _load, child: const Text('再試行')),
          ],
        ),
      );
    }
    final shelters = _shelters ?? [];
    if (shelters.isEmpty) {
      return const Center(child: Text('この範囲に避難所が見つかりません'));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: shelters.length,
        itemBuilder: (ctx, i) => _ShelterTile(shelter: shelters[i]),
      ),
    );
  }

  void _showFilterSheet() async {
    final selected = await showModalBottomSheet<List<DisasterType>>(
      context: context,
      builder: (_) => ShelterFilterSheet(selected: _activeFilters),
    );
    if (selected != null) {
      setState(() => _activeFilters = selected);
      await _load();
    }
  }
}

class _ShelterTile extends StatelessWidget {
  const _ShelterTile({required this.shelter});

  final Shelter shelter;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: Text(shelter.name),
      subtitle: Text(
        shelter.distanceKm != null
            ? '${shelter.distanceKm!.toStringAsFixed(1)} km'
            : shelter.address ?? '',
      ),
      trailing: Wrap(
        spacing: 4,
        children: shelter.disasterTypes
            .take(2)
            .map((t) => Chip(
                  label: Text(t.label, style: const TextStyle(fontSize: 10)),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ))
            .toList(),
      ),
    );
  }
}

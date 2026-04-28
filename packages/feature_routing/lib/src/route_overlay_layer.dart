import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

// ignore_for_file: public_member_api_docs

class RouteOverlayLayer extends StatelessWidget {
  const RouteOverlayLayer({
    required this.paths,
    required this.selectedProfile,
    super.key,
  });

  final List<RoutePath> paths;
  final RouteProfile selectedProfile;

  static const _selectedColor = Color(0xFF1565C0);
  static const _unselectedColor = Color(0x881565C0);

  @override
  Widget build(BuildContext context) {
    if (paths.isEmpty) return const SizedBox.shrink();
    return CustomPaint(
      painter: _RoutesPainter(
        paths: paths,
        selectedProfile: selectedProfile,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _RoutesPainter extends CustomPainter {
  const _RoutesPainter({
    required this.paths,
    required this.selectedProfile,
  });

  final List<RoutePath> paths;
  final RouteProfile selectedProfile;

  @override
  void paint(Canvas canvas, Size size) {
    for (final path in paths) {
      if (path.profile == selectedProfile) continue;
      _drawPath(canvas, size, path, isSelected: false);
    }
    for (final path in paths) {
      if (path.profile != selectedProfile) continue;
      _drawPath(canvas, size, path, isSelected: true);
    }
  }

  void _drawPath(
    Canvas canvas,
    Size size,
    RoutePath path, {
    required bool isSelected,
  }) {
    if (path.points.length < 2) return;

    final paint = Paint()
      ..color = isSelected
          ? RouteOverlayLayer._selectedColor
          : RouteOverlayLayer._unselectedColor
      ..strokeWidth = isSelected ? 4.0 : 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final offsets = path.points.map((p) => _project(p, size)).toList();
    final linePath = ui.Path()
      ..moveTo(offsets.first.dx, offsets.first.dy);
    for (final offset in offsets.skip(1)) {
      linePath.lineTo(offset.dx, offset.dy);
    }
    canvas.drawPath(linePath, paint);
  }

  // Equirectangular projection relative to bounding box of all points.
  Offset _project(RoutePoint point, Size size) {
    final allPoints = paths.expand((p) => p.points);
    final allLats = allPoints.map((p) => p.latitude).toList();
    final allLngs = allPoints.map((p) => p.longitude).toList();
    final minLat = allLats.reduce((a, b) => a < b ? a : b);
    final maxLat = allLats.reduce((a, b) => a > b ? a : b);
    final minLng = allLngs.reduce((a, b) => a < b ? a : b);
    final maxLng = allLngs.reduce((a, b) => a > b ? a : b);
    final latRange = maxLat - minLat;
    final lngRange = maxLng - minLng;
    final padding = size.width * 0.1;
    if (latRange == 0 || lngRange == 0) {
      return Offset(size.width / 2, size.height / 2);
    }
    final x = padding +
        (point.longitude - minLng) / lngRange * (size.width - 2 * padding);
    final y = padding +
        (maxLat - point.latitude) / latRange * (size.height - 2 * padding);
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(_RoutesPainter oldDelegate) =>
      oldDelegate.paths != paths ||
      oldDelegate.selectedProfile != selectedProfile;
}

import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.body,
    super.key,
    this.leading,
    this.onTap,
  });

  final String title;
  final String body;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leading,
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(body),
        onTap: onTap,
      ),
    );
  }
}

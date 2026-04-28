// ignore_for_file: public_member_api_docs

class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.title,
    this.detail,
  });

  final String id;
  final String title;
  final String? detail;
}

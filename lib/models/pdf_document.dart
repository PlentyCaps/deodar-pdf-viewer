class PdfDocument {
  final String path;
  final String name;
  final DateTime openedAt;
  int lastPage;

  PdfDocument({
    required this.path,
    required this.name,
    required this.openedAt,
    this.lastPage = 0,
  });
}

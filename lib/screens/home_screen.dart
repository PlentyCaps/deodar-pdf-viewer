import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'pdf_viewer_screen.dart';
import '../models/pdf_document.dart';
import '../theme/deodar_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<PdfDocument> _recentFiles = [];

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final name = result.files.single.name;
      final doc = PdfDocument(path: path, name: name, openedAt: DateTime.now());

      setState(() {
        _recentFiles.removeWhere((f) => f.path == path);
        _recentFiles.insert(0, doc);
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PdfViewerScreen(document: doc)),
        );
      }
    }
  }

  void _openRecent(PdfDocument doc) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PdfViewerScreen(document: doc)),
    );
  }

  void _removeRecent(PdfDocument doc) {
    setState(() => _recentFiles.remove(doc));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DeodarTreeMark(size: 22),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Deodar ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: DeodarColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: 'PDF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: DeodarColors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _recentFiles.isEmpty ? _buildEmpty() : _buildRecentList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickPdf,
        icon: const Icon(Icons.add),
        label: const Text('Open PDF'),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _DeodarTreeMark(size: 72),
          const SizedBox(height: 24),
          const Text(
            'No PDFs opened yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: DeodarColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the button below to open a file',
            style: TextStyle(
              fontSize: 13,
              color: DeodarColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'RECENT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: DeodarColors.green,
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: _recentFiles.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final doc = _recentFiles[index];
              return Dismissible(
                key: Key(doc.path),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: DeodarColors.accentSurface,
                  child: const Icon(
                    Icons.delete_outline,
                    color: DeodarColors.accentDark,
                  ),
                ),
                onDismissed: (_) => _removeRecent(doc),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: DeodarSpacing.md,
                    vertical: 6,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: DeodarColors.greenSurface,
                      borderRadius: DeodarRadius.smBR,
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: DeodarColors.green,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    doc.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: DeodarColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    _formatDate(doc.openedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: DeodarColors.textSecondary,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: DeodarColors.textDisabled,
                    size: 20,
                  ),
                  onTap: () => _openRecent(doc),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ── Deodar tree mark widget ────────────────────────────────────────────────────

class _DeodarTreeMark extends StatelessWidget {
  final double size;
  const _DeodarTreeMark({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.86, size),
      painter: _TreePainter(),
    );
  }
}

class _TreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final topPaint = Paint()..color = DeodarColors.green;
    final midPaint = Paint()..color = DeodarColors.greenMid;
    final trunkPaint = Paint()..color = DeodarColors.greenDark;

    // Top crown
    final top = Path()
      ..moveTo(w * 0.5, h * 0.04)
      ..lineTo(w * 0.17, h * 0.32)
      ..lineTo(w * 0.83, h * 0.32)
      ..close();
    canvas.drawPath(top, topPaint);

    // Middle crown
    final mid = Path()
      ..moveTo(w * 0.5, h * 0.16)
      ..lineTo(w * 0.0, h * 0.54)
      ..lineTo(w * 1.0, h * 0.54)
      ..close();
    canvas.drawPath(mid, midPaint);

    // Bottom crown
    final bot = Path()
      ..moveTo(w * 0.5, h * 0.34)
      ..lineTo(-w * 0.06, h * 0.76)
      ..lineTo(w * 1.06, h * 0.76)
      ..close();
    canvas.drawPath(bot, topPaint);

    // Trunk
    final trunkRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.41, h * 0.76, w * 0.18, h * 0.18),
      const Radius.circular(1),
    );
    canvas.drawRRect(trunkRect, trunkPaint);

    // Ground line
    final groundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.94, w * 0.64, h * 0.04),
      const Radius.circular(1),
    );
    canvas.drawRRect(groundRect, trunkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

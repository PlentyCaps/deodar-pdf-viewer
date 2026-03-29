import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import '../models/pdf_document.dart';
import '../theme/deodar_theme.dart';
import '../widgets/ai_panel.dart';

class PdfViewerScreen extends StatefulWidget {
  final PdfDocument document;

  const PdfViewerScreen({super.key, required this.document});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFViewController? _controller;
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isLoading = true;
  bool _showControls = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.document.lastPage;
  }

  void _onPageChanged(int? page, int? total) {
    if (page == null || total == null) return;
    setState(() {
      _currentPage = page;
      _totalPages = total;
    });
    widget.document.lastPage = page;
  }

  void _onRender(int? pages) {
    if (pages == null) return;
    setState(() {
      _totalPages = pages;
      _isLoading = false;
    });
  }

  void _onError(dynamic error) {
    setState(() {
      _error = error.toString();
      _isLoading = false;
    });
  }

  Future<void> _goToPage(int page) async {
    await _controller?.setPage(page);
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  Future<void> _showPagePicker() async {
    final textController =
        TextEditingController(text: '${_currentPage + 1}');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Go to page'),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(hintText: '1 – $_totalPages'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final p = int.tryParse(textController.text);
              if (p != null && p >= 1 && p <= _totalPages) {
                Navigator.pop(ctx, p - 1);
              }
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
    if (result != null) _goToPage(result);
  }

  Future<void> _share() async {
    await Share.shareXFiles(
      [XFile(widget.document.path)],
      subject: widget.document.name,
    );
  }

  void _openAiPanel() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: const AiPanel(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // ── PDF ───────────────────────────────────────────────────────────
            PDFView(
              filePath: widget.document.path,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              defaultPage: _currentPage,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              onRender: _onRender,
              onError: _onError,
              onPageError: (page, e) => _onError(e),
              onViewCreated: (controller) {
                setState(() => _controller = controller);
              },
              onPageChanged: _onPageChanged,
            ),

            // ── Loading ───────────────────────────────────────────────────────
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: DeodarColors.greenLight,
                  strokeWidth: 2,
                ),
              ),

            // ── Error ─────────────────────────────────────────────────────────
            if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(DeodarSpacing.xl),
                  child: Container(
                    padding: const EdgeInsets.all(DeodarSpacing.lg),
                    decoration: BoxDecoration(
                      color: DeodarColors.greenDark.withValues(alpha: 0.92),
                      borderRadius: DeodarRadius.mdBR,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: DeodarColors.accent,
                          size: 40,
                        ),
                        const SizedBox(height: DeodarSpacing.sm),
                        const Text(
                          'Failed to load PDF',
                          style: TextStyle(
                            color: DeodarColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: DeodarColors.greenLight,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ── Top bar ───────────────────────────────────────────────────────
            AnimatedSlide(
              offset: _showControls ? Offset.zero : const Offset(0, -1),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(
                    DeodarSpacing.sm,
                    DeodarSpacing.sm,
                    DeodarSpacing.sm,
                    0,
                  ),
                  decoration: BoxDecoration(
                    color: DeodarColors.greenDark.withValues(alpha: 0.92),
                    borderRadius: DeodarRadius.smBR,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: DeodarColors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.document.name,
                          style: const TextStyle(
                            color: DeodarColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_totalPages > 0)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '${_currentPage + 1} / $_totalPages',
                            style: TextStyle(
                              color: DeodarColors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.auto_awesome,
                            color: DeodarColors.greenLight, size: 20),
                        onPressed: _openAiPanel,
                        tooltip: 'AI',
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined,
                            color: DeodarColors.white, size: 20),
                        onPressed: _share,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom controls ───────────────────────────────────────────────
            AnimatedSlide(
              offset: _showControls ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(DeodarSpacing.sm),
                    padding: const EdgeInsets.symmetric(
                      horizontal: DeodarSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: DeodarColors.greenDark.withValues(alpha: 0.92),
                      borderRadius: DeodarRadius.smBR,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left,
                              color: DeodarColors.white, size: 24),
                          onPressed: _currentPage > 0
                              ? () => _goToPage(_currentPage - 1)
                              : null,
                        ),
                        GestureDetector(
                          onTap: _totalPages > 0 ? _showPagePicker : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: DeodarSpacing.sm,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: DeodarColors.green.withValues(alpha: 0.3),
                              borderRadius: DeodarRadius.smBR,
                            ),
                            child: Text(
                              _totalPages > 0
                                  ? '${_currentPage + 1} of $_totalPages'
                                  : '—',
                              style: const TextStyle(
                                color: DeodarColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right,
                              color: DeodarColors.white, size: 24),
                          onPressed: _currentPage < _totalPages - 1
                              ? () => _goToPage(_currentPage + 1)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

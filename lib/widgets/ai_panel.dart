import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/deodar_theme.dart';

class _AiMessage {
  final String text;
  final bool isUser;
  _AiMessage({required this.text, required this.isUser});
}

class AiPanel extends StatefulWidget {
  const AiPanel({super.key});

  @override
  State<AiPanel> createState() => _AiPanelState();
}

class _AiPanelState extends State<AiPanel> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_AiMessage> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _textController.clear();
    setState(() {
      _messages.add(_AiMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8888/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': text,
          'context': 'quick_response',
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final reply = (data['text'] ?? data['response'] ?? data['message'] ?? data['content'] ?? '').toString();
        setState(() {
          _messages.add(_AiMessage(text: reply.isNotEmpty ? reply : 'No response', isUser: false));
        });
      } else {
        // Show the actual error from the router (e.g. "No providers configured")
        String errMsg = 'Error ${response.statusCode}';
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          errMsg = data['error']?.toString() ?? errMsg;
        } catch (_) {}
        setState(() {
          _messages.add(_AiMessage(text: errMsg, isUser: false));
        });
      }
    } catch (e) {
      final detail = e.toString().contains('Connection refused')
          ? 'Connection refused — is the AI Router app running?'
          : e.toString().contains('timed out')
              ? 'Request timed out — router may be busy or stopped'
              : 'Error: $e';
      setState(() {
        _messages.add(_AiMessage(
          text: detail,
          isUser: false,
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: DeodarColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(DeodarRadius.lg)),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(
              DeodarSpacing.md,
              DeodarSpacing.sm,
              DeodarSpacing.sm,
              DeodarSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: DeodarColors.greenDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(DeodarRadius.lg)),
            ),
            child: Column(
              children: [
                // drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: DeodarColors.white.withValues(alpha: 0.3),
                      borderRadius: DeodarRadius.smBR,
                    ),
                  ),
                ),
                const SizedBox(height: DeodarSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: DeodarColors.greenLight, size: 18),
                    const SizedBox(width: DeodarSpacing.sm),
                    const Text(
                      'Deodar AI',
                      style: TextStyle(
                        color: DeodarColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: DeodarColors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Messages ─────────────────────────────────────────────────────
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            color: DeodarColors.textDisabled, size: 36),
                        SizedBox(height: DeodarSpacing.sm),
                        Text(
                          'Ask anything about this document',
                          style: TextStyle(
                              color: DeodarColors.textDisabled, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(DeodarSpacing.md),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _MessageBubble(message: _messages[i]),
                  ),
          ),

          // ── Thinking indicator ───────────────────────────────────────────
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: DeodarSpacing.md, vertical: DeodarSpacing.xs),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: DeodarColors.green),
                  ),
                  SizedBox(width: DeodarSpacing.sm),
                  Text('Thinking…',
                      style: TextStyle(
                          color: DeodarColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),

          // ── Input ────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              DeodarSpacing.md,
              DeodarSpacing.sm,
              DeodarSpacing.md,
              DeodarSpacing.md + bottomInset,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: const TextStyle(fontSize: 14),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(
                      hintText: 'Ask a question…',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: DeodarSpacing.md, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: DeodarSpacing.sm),
                SizedBox(
                  width: 44,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _send,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                          borderRadius: DeodarRadius.smBR),
                    ),
                    child: const Icon(Icons.send, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _AiMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: DeodarSpacing.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: DeodarSpacing.md, vertical: DeodarSpacing.sm),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser
              ? DeodarColors.green
              : DeodarColors.surfaceGrey,
          borderRadius: DeodarRadius.mdBR,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser
                ? DeodarColors.white
                : DeodarColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

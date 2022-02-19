class ChatHistorySyntaxError extends Error {
  final String line;
  final int lineNumber;

  final String comment;

  ChatHistorySyntaxError({
    required this.line,
    required this.lineNumber,
    required this.comment,
  });

  @override
  String toString() {
    return 'on line $lineNumber ($line), $comment';
  }
}

class ImportedBankMessage {
  final String id;
  final String sender;
  final String body;
  final DateTime receivedAt;
  final bool needsReview;

  const ImportedBankMessage({
    required this.id,
    required this.sender,
    required this.body,
    required this.receivedAt,
    this.needsReview = false,
  });
}

class BankMessageInbox {
  final bool enabled;
  final List<ImportedBankMessage> messages;

  const BankMessageInbox({required this.enabled, required this.messages});
}

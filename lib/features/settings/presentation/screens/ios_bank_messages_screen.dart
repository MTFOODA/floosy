import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../domain/entities/imported_bank_message.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../transactions/presentation/cubit/sms_cubit.dart';

class IosBankMessagesScreen extends StatefulWidget {
  const IosBankMessagesScreen({super.key});
  @override
  State<IosBankMessagesScreen> createState() => _IosBankMessagesScreenState();
}

class _IosBankMessagesScreenState extends State<IosBankMessagesScreen> {
  BankMessageInbox? _inbox;
  bool _busy = false;
  bool _failed = false;
  bool _processingFailed = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh({bool process = false}) async {
    if (_busy) return;
    final sms = context.read<SmsCubit>();
    final owner = context.read<AuthCubit>().state.userId;
    setState(() {
      _busy = true;
      _failed = false;
      _processingFailed = false;
    });
    try {
      final result = process ? await sms.scanNow() : null;
      final inbox = await sms.importedMessages();
      if (!mounted || context.read<AuthCubit>().state.userId != owner) return;
      setState(() {
        _inbox = inbox;
        _processingFailed = (result?.errors ?? 0) > 0;
      });
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _change(Future<void> Function(SmsCubit) action) async {
    if (_busy) return;
    final sms = context.read<SmsCubit>();
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await action(sms);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
      return;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (mounted) await _refresh(process: true);
  }

  Future<void> _pasteMessage() async {
    final message =
        await showDialog<({String sender, String body, DateTime receivedAt})>(
            context: context, builder: (_) => const _BankMessageDialog());
    if (message != null && mounted) {
      await _change((sms) => sms.addImportedMessage(
          message.sender, message.body, message.receivedAt));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final inbox = _inbox;
    return Scaffold(
      appBar: AppBar(title: Text(l['iosSmsTitle']), actions: [
        IconButton(
            tooltip: l['iosSmsProcess'],
            onPressed: _busy ? null : () => _refresh(process: true),
            icon: const Icon(Icons.sync)),
      ]),
      body: RefreshIndicator(
          onRefresh: () => _refresh(process: true),
          child: ListView(padding: const EdgeInsets.all(20), children: [
            if (_busy) const LinearProgressIndicator(),
            if (_processingFailed)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(l['iosSmsProcessingError'])),
            if (_failed)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(l['iosSmsUnavailable'],
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error))),
            SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l['iosSmsEnable']),
                subtitle: Text(l['iosSmsPrivacy']),
                value: inbox?.enabled ?? false,
                onChanged: _busy || inbox == null
                    ? null
                    : (value) => _change((sms) => sms.setImportEnabled(value))),
            const Divider(),
            Text(l['iosSmsSetup'],
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SelectableText(l['iosSmsSteps']),
            const SizedBox(height: 12),
            Text(l['iosSmsLimits']),
            const SizedBox(height: 20),
            FilledButton.icon(
                onPressed:
                    _busy || inbox?.enabled != true ? null : _pasteMessage,
                icon: const Icon(Icons.paste),
                label: Text(l['iosSmsPaste'])),
            const SizedBox(height: 24),
            Text(l['iosSmsQueue'],
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (inbox != null && inbox.messages.isEmpty) Text(l['iosSmsEmpty']),
            for (final message in inbox?.messages ?? <ImportedBankMessage>[])
              Card(
                  child: ExpansionTile(
                      title: Text(message.sender),
                      subtitle: Text(message.needsReview
                          ? l['iosSmsReview']
                          : l['iosSmsPending']),
                      childrenPadding: const EdgeInsets.all(16),
                      children: [
                    SelectableText(message.body),
                    const SizedBox(height: 8),
                    Text(DateFormat.yMd(l.locale.languageCode)
                        .add_Hm()
                        .format(message.receivedAt)),
                    Wrap(spacing: 12, children: [
                      TextButton.icon(
                          onPressed: _busy
                              ? null
                              : () => _change((sms) =>
                                  sms.retryImportedMessage(message.id)),
                          icon: const Icon(Icons.refresh),
                          label: Text(l['iosSmsRetry'])),
                      TextButton.icon(
                          onPressed: _busy
                              ? null
                              : () => _change((sms) =>
                                  sms.discardImportedMessage(message.id)),
                          icon: const Icon(Icons.delete_outline),
                          label: Text(l['iosSmsRemove'])),
                    ]),
                  ])),
            const SizedBox(height: 32),
          ])),
    );
  }
}

class _BankMessageDialog extends StatefulWidget {
  const _BankMessageDialog();
  @override
  State<_BankMessageDialog> createState() => _BankMessageDialogState();
}

class _BankMessageDialogState extends State<_BankMessageDialog> {
  final _sender = TextEditingController();
  final _body = TextEditingController();
  final _form = GlobalKey<FormState>();
  DateTime _receivedAt = DateTime.now();
  @override
  void dispose() {
    _sender.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _receivedAt,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (date == null || !mounted) return;
    final time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(_receivedAt));
    if (time != null && mounted) {
      setState(() => _receivedAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return AlertDialog(
      title: Text(l['iosSmsPaste']),
      content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Form(
                key: _form,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(l['iosSmsPasteHelp']),
                  const SizedBox(height: 12),
                  TextFormField(
                      controller: _sender,
                      maxLength: 128,
                      decoration: InputDecoration(labelText: l['iosSmsSender']),
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? l['iosSmsRequired']
                          : null),
                  TextFormField(
                      controller: _body,
                      maxLength: 16000,
                      minLines: 4,
                      maxLines: 8,
                      decoration: InputDecoration(labelText: l['iosSmsBody']),
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? l['iosSmsRequired']
                          : null),
                  TextButton.icon(
                      icon: const Icon(Icons.event),
                      onPressed: _pickDate,
                      label: Text(
                          '${l['iosSmsReceivedAt']}: ${DateFormat.yMd(l.locale.languageCode).add_Hm().format(_receivedAt)}')),
                ])),
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text(l['cancel'])),
        FilledButton(
            onPressed: () {
              if (_form.currentState!.validate()) {
                Navigator.pop(context, (
                  sender: _sender.text.trim(),
                  body: _body.text.trim(),
                  receivedAt: _receivedAt
                ));
              }
            },
            child: Text(l['iosSmsImport'])),
      ],
    );
  }
}

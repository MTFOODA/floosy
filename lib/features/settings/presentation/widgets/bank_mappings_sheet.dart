import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/common/bank_logo.dart';
import '../../../../domain/entities/bank_directory.dart';
import '../cubit/bank_mappings_cubit.dart';

class BankMappingsSheet extends StatefulWidget {
  final String userId;
  final BankMappingsCubit store;
  const BankMappingsSheet({
    super.key,
    required this.userId,
    required this.store,
  });
  @override
  State<BankMappingsSheet> createState() => _BankMappingsSheetState();
}

class _BankMappingsSheetState extends State<BankMappingsSheet> {
  List<String>? _unknown;
  List<String> _rejected = [];
  String? _error;
  bool _working = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    try {
      final unknown = await widget.store.getUnknownSenders(widget.userId);
      final rejected = await widget.store.getRejectedSenders(widget.userId);
      if (mounted) {
        setState(() {
          _unknown = unknown;
          _rejected = rejected;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.s(context)['saveFailed']);
      }
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_working) return;
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      await action();
      await _reload();
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.s(context)['saveFailed']);
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l['bankMappings'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(l['unknownBankSenders']),
              const SizedBox(height: 8),
              Text(
                l['rejectSenderHint'],
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (_working) const LinearProgressIndicator(),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              Expanded(
                child: _unknown == null
                    ? Center(
                        child: _error == null
                            ? const CircularProgressIndicator()
                            : TextButton(
                                onPressed: _reload,
                                child: Text(l['retry']),
                              ),
                      )
                    : ListView(
                        children: [
                          if (_unknown!.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(l['noUnknownSenders']),
                            ),
                          for (final sender in _unknown!)
                            _MappingRow(
                              key: ValueKey(sender),
                              sender: sender,
                              enabled: !_working,
                              onSave: (name) => _run(
                                () => widget.store.setMapping(
                                  widget.userId,
                                  sender,
                                  name,
                                ),
                              ),
                              onReject: () => _run(
                                () => widget.store.rejectSender(
                                  widget.userId,
                                  sender,
                                ),
                              ),
                            ),
                          if (_rejected.isNotEmpty)
                            ExpansionTile(
                              title: Text(l['rejectedSenders']),
                              children: [
                                for (final sender in _rejected)
                                  ListTile(
                                    title: Text(sender),
                                    trailing: TextButton(
                                      onPressed: _working
                                          ? null
                                          : () => _run(
                                              () => widget.store.restoreSender(
                                                widget.userId,
                                                sender,
                                              ),
                                            ),
                                      child: Text(l['restoreSender']),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MappingRow extends StatefulWidget {
  final String sender;
  final bool enabled;
  final Future<void> Function(String) onSave;
  final VoidCallback onReject;
  const _MappingRow({
    super.key,
    required this.sender,
    required this.enabled,
    required this.onSave,
    required this.onReject,
  });
  @override
  State<_MappingRow> createState() => _MappingRowState();
}

class _MappingRowState extends State<_MappingRow> {
  String _name = '';
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.sender,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Autocomplete<KnownBank>(
                  displayStringForOption: (bank) =>
                      l.isArabic ? bank.nameAr : bank.name,
                  optionsBuilder: (value) {
                    final query = value.text.trim().toLowerCase();
                    return BankCatalog.all.where(
                      (bank) =>
                          query.isEmpty ||
                          [
                            bank.code,
                            bank.name,
                            bank.nameAr,
                            ...bank.aliases,
                          ].any((name) => name.toLowerCase().contains(query)),
                    );
                  },
                  onSelected: (bank) => setState(() => _name = bank.name),
                  fieldViewBuilder: (context, controller, focus, submit) =>
                      TextField(
                        controller: controller,
                        focusNode: focus,
                        enabled: widget.enabled,
                        onChanged: (value) => setState(() => _name = value),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: l['enterBankName'],
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8),
                            child: BankLogo(bankName: _name, size: 24),
                          ),
                        ),
                      ),
                  optionsViewBuilder: (context, select, options) => Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 260,
                        height: 220,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            for (final bank in options)
                              ListTile(
                                dense: true,
                                leading: BankLogo(bankName: bank.name),
                                title: Text(
                                  l.isArabic ? bank.nameAr : bank.name,
                                ),
                                onTap: () => select(bank),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                tooltip: l['saveChanges'],
                onPressed: widget.enabled && _name.trim().isNotEmpty
                    ? () => widget.onSave(
                        BankCatalog.byIdentity(_name)?.name ?? _name.trim(),
                      )
                    : null,
                icon: const Icon(Icons.check_rounded, color: Colors.green),
              ),
              IconButton(
                tooltip: l['rejectSender'],
                onPressed: widget.enabled ? widget.onReject : null,
                icon: const Icon(Icons.close_rounded, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

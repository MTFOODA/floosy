import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_runtime.dart';

class AppScope extends StatefulWidget {
  final AppRuntime runtime;
  final Widget child;
  final bool ownsRuntime;
  final Future<void> Function()? disposeDependencies;
  const AppScope(
      {super.key,
      required this.runtime,
      required this.child,
      this.ownsRuntime = false,
      this.disposeDependencies});
  @override
  State<AppScope> createState() => _AppScopeState();
}

class _AppScopeState extends State<AppScope> {
  @override
  void dispose() {
    if (widget.ownsRuntime) {
      unawaited(widget.runtime
          .close()
          .then((_) => widget.disposeDependencies?.call()));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final runtime = widget.runtime;
    return RepositoryProvider.value(
      value: runtime.repositories.queries,
      child: MultiBlocProvider(providers: [
        BlocProvider.value(value: runtime.auth),
        BlocProvider.value(value: runtime.locale),
        BlocProvider.value(value: runtime.theme),
        BlocProvider.value(value: runtime.selection),
        BlocProvider.value(value: runtime.lock),
        BlocProvider.value(value: runtime.refresh),
        BlocProvider.value(value: runtime.banks),
        BlocProvider.value(value: runtime.cards),
        BlocProvider.value(value: runtime.finance),
        BlocProvider.value(value: runtime.items),
        BlocProvider.value(value: runtime.profile),
        BlocProvider.value(value: runtime.budgets),
        BlocProvider.value(value: runtime.analytics),
        BlocProvider.value(value: runtime.cash),
        BlocProvider.value(value: runtime.transactions),
        BlocProvider.value(value: runtime.sms),
        BlocProvider.value(value: runtime.mappings),
        BlocProvider.value(value: runtime.filter),
        BlocProvider.value(value: runtime.chat),
      ], child: widget.child),
    );
  }
}

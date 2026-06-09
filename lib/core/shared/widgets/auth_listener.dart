import 'package:apex_restaurant/core/helpers/helper_methods.dart';
import 'package:apex_restaurant/core/shared/contracts/errorable_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocErrorListener<B extends StateStreamable<S>, S extends ErrorableState>
    extends StatelessWidget {
  final Widget child;

  /// Optional — override the default fire condition.
  final bool Function(S prev, S curr)? listenWhen;

  /// Optional — override what happens on error instead of the default handler.
  final void Function(BuildContext context, S state)? onError;

  const BlocErrorListener({
    super.key,
    required this.child,
    this.listenWhen,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen:
          listenWhen ??
          (prev, curr) =>
              curr.hasError &&
              curr.apiResponse != null &&
              !prev.hasError, // only fire on the transition into error
      listener: (context, state) {
        if (onError != null) {
          onError!(context, state);
        } else {
          HelperMethods.checkErroAndShowMessage(state.apiResponse!, context);
        }
      },
      child: child,
    );
  }
}

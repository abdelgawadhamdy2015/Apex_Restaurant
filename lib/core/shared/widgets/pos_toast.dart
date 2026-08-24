import 'dart:async';

import '../../../featchers/pos/presentation/bloc/pos_bloc.dart';
import '../../../featchers/pos/presentation/bloc/pos_event.dart';
import '../../../featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosToast extends StatefulWidget {
  const PosToast({super.key});

  @override
  State<PosToast> createState() => _PosToastState();
}

class _PosToastState extends State<PosToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _dismissTimer?.cancel();
    super.dispose();
  }

  void _show() {
    _controller.forward();
    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(seconds: 3), _hide);
  }

  void _hide() {
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) context.read<PosBloc>().add(const DismissToastEvent());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PosBloc, PosState>(
      listenWhen: (prev, curr) =>
          curr.toastMessage != null && curr.toastMessage != prev.toastMessage,
      listener: (context, state) {
        if (state.toastMessage != null) _show();
      },
      child: BlocBuilder<PosBloc, PosState>(
        buildWhen: (prev, curr) => curr.toastMessage != prev.toastMessage,
        builder: (context, state) {
          if (state.toastMessage == null) return const SizedBox.shrink();
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ToastCard(message: state.toastMessage!),
            ),
          );
        },
      ),
    );
  }
}

class ToastCard extends StatelessWidget {
  final String message;
  const ToastCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 16,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

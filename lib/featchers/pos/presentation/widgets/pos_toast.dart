import 'dart:async';

import 'package:apex_restaurant/core/theme/app_theme.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_bloc.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_event.dart';
import 'package:apex_restaurant/featchers/pos/presentation/bloc/pos_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
        if (mounted) {
          context.read<PosBloc>().add(const DismissToastEvent());
        }
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
          return Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _ToastCard(message: state.toastMessage!),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  final String message;
  const _ToastCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 16, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

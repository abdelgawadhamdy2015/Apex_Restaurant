import '../../../../../core/helpers/restaurant_constants.dart';
import '../../../../../core/shared/widgets/date_text_field.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TakeawaySection extends StatefulWidget {
  const TakeawaySection({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<TakeawaySection> createState() => _TakeawaySectionState();
}

class _TakeawaySectionState extends State<TakeawaySection> {
  @override
  Widget build(BuildContext context) {
    final canEdit = context.select((CartBloc b) => b.state.canEdit);
    return DateTextField(
      type: DateTextFieldType.dateTime,
      controller: widget.controller,
      onTap: () {
        if (canEdit) _pickTakeawayDateTime(context);
      },
    );
  }

  Future<void> _pickTakeawayDateTime(BuildContext context) async {
    final dateTime = await DateTextField.pickDateTime(
      context,
      type: DateTextFieldType.dateTime,
    );
    if (!mounted || dateTime == null) return;

    widget.controller.text = RestaurantConstants.dateTimeFormat.format(
      dateTime,
    );
    context.read<CartBloc>().add(
      UpdateTakeawayDateTimeEvent(takeawayDateTime: dateTime),
    );
  }
}

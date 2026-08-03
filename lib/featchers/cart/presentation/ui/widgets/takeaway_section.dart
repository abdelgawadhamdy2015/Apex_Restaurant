import 'package:apex_restaurant/core/helpers/restaurant_constants.dart';
import 'package:apex_restaurant/core/shared/widgets/date_text_field.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_bloc.dart';
import 'package:apex_restaurant/featchers/cart/presentation/bloc/cart_event.dart';
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
    return DateTextField(
      label: 'Select Date & Time',
      type: DateTextFieldType.dateTime,
      controller: widget.controller,
      onTap: () async {
        final dateTime = await DateTextField.pickDateTime(context);
        if (dateTime != null) {
          widget.controller.text = RestaurantConstants.dateTimeFormat.format(
            dateTime,
          );
          context.read<CartBloc>().add(
            UpdateTakeawayDateTimeEvent(takeawayDateTime: dateTime),
          );
        }
      },
    );
  }
}

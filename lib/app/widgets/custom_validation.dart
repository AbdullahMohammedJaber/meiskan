import 'package:flutter/material.dart';

  


class ValidateWidget extends FormField {
  ValidateWidget({
    super.onSaved,
    super.validator,
    Widget? child,
    super.key,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState state) {
            return   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return Column(
                        children: [child!],
                      );
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Builder(
                        builder: (BuildContext context) => Text(
                          state.errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                ],
              );
          },
        );
}

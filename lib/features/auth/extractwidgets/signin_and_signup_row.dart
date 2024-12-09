import 'package:flutter/material.dart';

Widget signInAndUpRow(BuildContext context, ColorScheme colorScheme,
    String text, String name, String route) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.64),
            ),
      ),
      InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/$route');
        },
        child: Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    ],
  );
}

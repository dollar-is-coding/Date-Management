import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Row rowWidget({
  required text,
  required label,
  required context,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 2,
        child: Container(
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey.shade700),
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ],
  );
}

SnackBar snackBarWidget({required context, required warningText}) {
  return SnackBar(
    content: Row(
      children: [
        SvgPicture.asset(
          'asset/icons/danger.svg',
          fit: BoxFit.scaleDown,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Wrap(
            children: [
              Text(
                warningText,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Color.fromARGB(255, 94, 18, 99),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

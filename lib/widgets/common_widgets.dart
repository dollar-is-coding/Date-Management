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

SnackBar snackBarWidget({
  required context,
  required text,
  required icon,
  required color,
  required textColor,
}) {
  return SnackBar(
    content: Row(
      children: [
        SvgPicture.asset(
          // 'asset/icons/warning_icon.svg',
          icon,
          fit: BoxFit.scaleDown,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            textColor,
            BlendMode.srcIn,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Wrap(
            children: [
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: textColor),
              ),
            ],
          ),
        )
      ],
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );
}

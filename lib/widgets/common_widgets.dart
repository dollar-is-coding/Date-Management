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

Color progressColor({required percentage}) {
  if (percentage <= 20) return Color.fromARGB(255, 245, 34, 45);
  if (percentage <= 30) return Color.fromARGB(255, 250, 141, 24);
  if (percentage < 35) return Color.fromARGB(255, 255, 204, 0);
  if (percentage <= 40) return Color.fromARGB(255, 0, 79, 124);
  return Color.fromARGB(255, 112, 82, 255);
}

Color backgroundProgressColor({required percentage}) {
  if (percentage <= 20) return Color.fromARGB(255, 255, 235, 233);
  if (percentage <= 30) return Color.fromARGB(255, 255, 239, 221);
  if (percentage < 35) return Color.fromARGB(255, 255, 249, 226);
  return Color.fromARGB(255, 210, 225, 255);
}

Widget radioListileCustom({
  required val,
  required groupVal,
  required function,
  required text,
}) {
  return IntrinsicWidth(
    child: Container(
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: groupVal,
            onChanged: function,
            autofocus: val == 1 ? true : false,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(text),
        ],
      ),
    ),
  );
}

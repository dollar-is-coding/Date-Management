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

// SnackBar snackBarWidget({
//   required context,
//   required text,
//   required icon,
//   required color,
//   required textColor,
// }) {
//   return SnackBar(
//     padding: EdgeInsets.all(0),
//     content: ListTile(
//       dense: true,
//       visualDensity: VisualDensity(
//         horizontal: -4,
//         vertical: -2,
//       ),
//       contentPadding: EdgeInsets.all(0),
//       leading: SvgPicture.asset(
//         icon,
//         fit: BoxFit.scaleDown,
//         width: 16,
//         height: 16,
//         colorFilter: ColorFilter.mode(
//           textColor,
//           BlendMode.srcIn,
//         ),
//       ),
//       title: Text(
//         text,
//         style:
//             Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor),
//       ),
//       subtitle: Text(
//         text,
//         style:
//             Theme.of(context).textTheme.bodySmall!.copyWith(color: textColor),
//       ),
//     ),
//     behavior: SnackBarBehavior.floating,
//     backgroundColor: color,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(16),
//     ),
//   );
// }

SnackBar snackBarWidget({
  required BuildContext context,
  required String icon,
  required Color backgroundColor,
  required Color iconColor,
  required String header,
  required String text,
}) {
  return SnackBar(
    backgroundColor: backgroundColor,
    // backgroundColor: Color.fromARGB(255, 246, 75, 60),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    padding: EdgeInsets.all(8),
    clipBehavior: Clip.none,
    content: Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // 'Oops!',
                header,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              ),
              Text(
                // 'Bị lỗi nhiều lắm á nha.',
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          child: SvgPicture.asset(
            'asset/icons/bubble_icon.svg',
            fit: BoxFit.scaleDown,
            width: 40,
            colorFilter: ColorFilter.mode(
              // Color.fromARGB(255, 200, 25, 18),
              iconColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        Positioned(
          top: -32,
          left: 0,
          child: Container(
            width: 44,
            height: 44,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              // color: Color.fromARGB(255, 200, 25, 18),
              color: iconColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: SvgPicture.asset(
              // 'asset/icons/chat_error_icon.svg',
              icon,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        )
      ],
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

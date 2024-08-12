import 'package:flutter/cupertino.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xffc2753e),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .08,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("appbar")],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

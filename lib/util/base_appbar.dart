import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {

  // const BaseAppBar({Key key,
  //   @required this.appBar,
  //   @required this.title,
  //   this.center = false})
  //     : super(key: key);

  final AppBar appBar;
  final String title;
  final bool center;

  const BaseAppBar({Key? key, required this.appBar, required this.title, required this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Image.asset("assets/images/ic_chevron_30_back.png", width: 24, height: 24,),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: center,
      title: Text("$title", style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w700),),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}

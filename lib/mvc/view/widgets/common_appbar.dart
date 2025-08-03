import 'package:todo_app/import_export/import_export.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget { //This allows it to know how much space to reserve for the AppBar at the top
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool centerTitle;

  CommonAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor = Colors.deepPurple,
    this.foregroundColor = Colors.white,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  //tells flutter --> AppBar should take up 56 pixels of height (standard height).
}

import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  ImageTile({
    this.title = '',
    this.subTitle = '',
    this.imageURL = '',
    this.onEdit,
  });

  final String title;
  final String subTitle;
  final String imageURL;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          // 3 : 4
          minWidth: 45,
          minHeight: 60,
          maxWidth: 60,
          maxHeight: 80,
        ),
        child: Image.network(
          imageURL,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEdit,
      ),
    );
  }
}

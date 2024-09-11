import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class EmployeeIcon extends StatelessWidget {
  const EmployeeIcon({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
        ),
        child: FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(image),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

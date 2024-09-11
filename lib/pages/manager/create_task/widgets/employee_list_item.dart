import 'package:flutter/material.dart';
import 'package:gorev_proje_yonetim_uygulamasi/constants/constants.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';
import 'package:transparent_image/transparent_image.dart';

class EmployeeListItem extends StatefulWidget {
  const EmployeeListItem(
      {super.key, required this.employee, required this.onSelected});

  final Employee employee;
  final ValueChanged<Employee> onSelected;

  @override
  State<EmployeeListItem> createState() => _EmployeeListItemState();
}

class _EmployeeListItemState extends State<EmployeeListItem> {
  int waitingTask = 0;
  int inProgressTask = 0;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();

    if (widget.employee.tasks.isNotEmpty) {
      for (var task in widget.employee.tasks) {
        if (task.status == 0) {
          waitingTask++;
        } else {
          inProgressTask++;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onSelected(widget.employee);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        width: screenWidth,
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 167, 255, 170) : white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
              color: grey,
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              clipBehavior: Clip.hardEdge,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.employee.pictureUrl,
                width: 70,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.employee.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Divider(),
                  widget.employee.tasks.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$waitingTask görev bekliyor',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: orange,
                                  ),
                            ),
                            Text(
                              '$inProgressTask görev yapılıyor',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: blue,
                                  ),
                            ),
                          ],
                        )
                      : Text(
                          'Henüz bir görev yok',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: green,
                                  ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

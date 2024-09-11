import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gorev_proje_yonetim_uygulamasi/models/employee.dart';
import 'package:gorev_proje_yonetim_uygulamasi/providers/selected_employees_provider.dart';

class EmployeeMiniIcon extends ConsumerWidget {
  const EmployeeMiniIcon({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Image.network(
                employee.pictureUrl,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
            Positioned(
              top: 0,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(selectedEmployeesProvider.notifier)
                      .deleteEmployee(employee);
                },
                child: const SizedBox(
                  width: 20, // İkonun boyutunu arttırdık
                  height: 20, // İkonun boyutunu arttırdık
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(employee.name),
      ],
    );
  }
}

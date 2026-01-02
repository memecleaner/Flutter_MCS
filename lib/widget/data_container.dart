import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Themes/color.dart';
import '../providers/app_provider.dart';

class dataContainer extends StatelessWidget {
  final String title;
  final String value;
  dataContainer({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          width: MediaQuery.of(context).size.width / 2.3,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: TemaWarna.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(15),

        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: appProvider.font2,
              ),
              Text(
                value,
                style: appProvider.font2,
              )
            ],
          )
        );
      }

    );
  }
}

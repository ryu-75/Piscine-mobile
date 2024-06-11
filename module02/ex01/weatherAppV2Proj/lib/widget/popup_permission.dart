import 'package:flutter/material.dart';
import 'package:weather_app_v2_proj/enum/permission_type.dart';
import 'package:weather_app_v2_proj/utils/permissions.dart';

class PopupPermissions extends StatelessWidget {
  const PopupPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  RequestPermissionManager(PermissionType.whenInUseLocation)
                      .onPermissionDenied(() {
                    // Handle permission denied for location
                    print('Location permission denied');
                  }).onPermissionGranted(() {
                    // Handle permission granted for location
                    print('Location permission granted');
                  }).onPermissionPermanentlyDenied(() {
                    // Handle permission permanently denied for location
                    print('Location permission permanently denied');
                  }).execute();
                },
                child: const Text("Request location Permission")),
          ],
        ),
      ),
    );
  }
}

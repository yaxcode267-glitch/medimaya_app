// Stores
import 'package:medimaya_app/features/dashboard/profile/store/profile_controller.dart';

bool hasPermission(String permission) =>
    ProfileController.instance.hasPermission(permission);

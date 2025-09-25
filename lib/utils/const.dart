
import 'package:elite_admin/utils/preferences/local_preferences.dart';

const String appName = "Creator 07";

///*************************Header************************************///
Map<String, String>? get headers => {
  'Content-Type': "application/json",
  'authorization': "${LocalStorageUtils.userToken}",
};
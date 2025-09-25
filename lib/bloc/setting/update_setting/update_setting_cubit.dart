import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite_admin/utils/apiurls/api.dart';

part 'update_setting_state.dart';

class UpdateSettingCubit extends Cubit<UpdateSettingState> {
  UpdateSettingCubit() : super(UpdateSettingInitial());

  updateSetting({
    required String? id,
    String? currentVersion,
    String? adminUpi,
    String? adminContactNumber,
    String? adminEmail,
    String? developedBy,
    String? authorName,
    String? whatsappContactNumber,
    String? playStoreLink,
    String? aboutUs,
    String? privacyPolicy,
    String? termsAndCondition,
    String? firebaseProjectId,
    String? firebaseClientEmail,
    String? firebasePrivateKey,
    File? logo,
    String? helpSupport,
    File? spashScreenBanner1,
    File? spashScreenBanner2,
    File? spashScreenBanner3,
    String? requiredVersion,
    String? razorpayKey,
    String? phonepayKey,
    String? phonepayPaySaltKey,
    String? cashfreeClientSecretKey,
    String? cashfreeClientId,
    String? secretKey,
    String? paymentType,
    bool? isSongOnSubscription,
  }) async {
    emit(UpdateSettingLoadingState());
    try {
      var uri = Uri.parse(AppUrls.settingUrl);
      var request = MultipartRequest("POST", uri);

      request.headers.addAll(headers);

      if (logo != null) {
        final mimeType = lookupMimeType(logo.path);
        if (mimeType != null) {
          request.files.add(
            await MultipartFile.fromPath(
              "app_logo",
              logo.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${logo.path}");
        }
      }

      if (spashScreenBanner1 != null) {
        final mimeType = lookupMimeType(spashScreenBanner1.path);
        if (mimeType != null) {
          request.files.add(
            await MultipartFile.fromPath(
              "spash_screen_banner_1",
              spashScreenBanner1.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${spashScreenBanner1.path}");
        }
      }

      if (spashScreenBanner2 != null) {
        final mimeType = lookupMimeType(spashScreenBanner2.path);
        if (mimeType != null) {
          request.files.add(
            await MultipartFile.fromPath(
              "spash_screen_banner_2",
              spashScreenBanner2.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${spashScreenBanner2.path}");
        }
      }

      if (spashScreenBanner3 != null) {
        final mimeType = lookupMimeType(spashScreenBanner3.path);
        if (mimeType != null) {
          request.files.add(
            await MultipartFile.fromPath(
              "spash_screen_banner_3",
              spashScreenBanner3.path,
              contentType: MediaType.parse(mimeType),
            ),
          );
        } else {
          log("Unable to determine MIME type for file: ${spashScreenBanner3.path}");
        }
      }

      Map<String, String> fields = {
        if (currentVersion != null) "current_version": currentVersion,
        if (adminUpi != null) "admin_upi": adminUpi,
        if (adminContactNumber != null) "admin_contact_no": adminContactNumber,
        if (adminEmail != null) "admin_email": adminEmail,
        if (developedBy != null) "developed_by": developedBy,
        if (authorName != null) "author_name": authorName,
        if (whatsappContactNumber != null) "whatsapp_contact_number": whatsappContactNumber,
        if (playStoreLink != null) "playStore_link": playStoreLink,
        if (aboutUs != null) "about_us": aboutUs,
        if (termsAndCondition != null) "terms_and_condition": termsAndCondition,
        if (privacyPolicy != null) "privacy_policy": privacyPolicy,
        if (firebaseProjectId != null) "firebase_project_id": firebaseProjectId,
        if (firebasePrivateKey != null) "firebase_private_key": firebasePrivateKey,
        if (firebaseClientEmail != null) "firebase_client_email": firebaseClientEmail,
        if (helpSupport != null) "help_support": helpSupport,
        if (requiredVersion != null) "required_version": requiredVersion,
        if (razorpayKey != null) "razorpay_key": razorpayKey,
        if (secretKey != null) "secret_key": secretKey,
        if (phonepayKey != null) "phonepay_key": phonepayKey,
        if (phonepayPaySaltKey != null) "phonepay_pay_salt_key": phonepayPaySaltKey,
        if (cashfreeClientId != null) "cashfree_client_id": cashfreeClientId,
        if (cashfreeClientSecretKey != null) "cashfree_client_secret_key": cashfreeClientSecretKey,
        if (paymentType != null) "payment_type": paymentType,
        if (isSongOnSubscription != null) "is_song_on_subscription": isSongOnSubscription.toString(),
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateSettingLoadedState());
        } else {
          emit(UpdateSettingErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateSettingErrorState("${result['message']}"));
      }
    } catch (e, s) {
      print("catch error $e, $s");
      emit(UpdateSettingErrorState("$e $s"));
    }
  }
}

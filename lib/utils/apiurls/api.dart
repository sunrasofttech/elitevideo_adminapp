import 'package:elite_admin/utils/preferences/local_preferences.dart';

class AppUrls {
  static const String baseUrl = "https://eliteott.in";

  static const String dashboardUrl = "$baseUrl/api/ott/dashboard";

  static const String userAnaylsisUrl = "$baseUrl/api/ott/user-analytics";

  static const String revenueAnaylsisUrl = "$baseUrl/api/ott/monthly-revenue";

  static const String loginUrl = "$baseUrl/api/ott/admin/login";

  static const String signUpUrl = "$baseUrl/api/ott/admin/signup";

  static const String signUpUserUrl = "$baseUrl/api/ott/user/signup";

  static const String getProfileUrl = "$baseUrl/api/ott/admin/";

  static const String updateProfileUrl = "$baseUrl/api/ott/admin/";

  static const String movieCategoryUrl = "$baseUrl/api/ott/movie-category";

  static const String settingUrl = "$baseUrl/api/ott/admin-setting";

  static const String movieLanguageUrl = "$baseUrl/api/ott/movie-language";

  static const String genreUrl = "$baseUrl/api/ott/genre";

  static const String movieUrl = "$baseUrl/api/ott/movie";

  static const String castCrewUrl = "$baseUrl/api/ott/movie/cast-crew";

  static const String userUrl = "$baseUrl/api/ott/user";

  static const String musicCategoryUrl = "$baseUrl/api/ott/music-category";

  static const String shortFlimUrl = "$baseUrl/api/ott/short-film";

  static const String seriesUrl = "$baseUrl/api/ott/series";

  static const String seasonUrl = "$baseUrl/api/ott/season";

  static const String episodeUrl = "$baseUrl/api/ott/season-episode";

  static const String musicUrl = "$baseUrl/api/ott/music";

  static const String liveTvCategory = "$baseUrl/api/ott/live-tv/category";

  static const String liveTvUrl = "$baseUrl/api/ott/live-tv/channel";

  static const String adsUrl = "$baseUrl/api/ott/ads";

  static const String movieAdsUrl = "$baseUrl/api/ott/movie-ads";

  static const String seasonAdsUrl = "$baseUrl/api/ott/season-episode-ads";

  static const String shortFilmsAds = "$baseUrl/api/ott/shortfilm-ads";

  static const String liveTvAdsUrl = "$baseUrl/api/ott/livetv_channel-ads";

  static const String subscriptionPlanUrl = "$baseUrl/api/ott/subscription-plan";

  static const String subAdminUrl = "$baseUrl/api/ott/admin/subadmins";

  static const String sendNotificationUrl = "$baseUrl/api/ott/notification/send-notification";

  static const String getRentalsUrl = "$baseUrl/api/ott/rental";

  static const String getReportssUrl = "$baseUrl/api/ott/report/get";

  static const String webSeriesCastCrewUrl = "$baseUrl/api/ott/series/cast-crew";

  static const String shortFilmCastCrewUrl = "$baseUrl/api/ott/short-film/cast-crew";

  static const String musicArtistUrl = "$baseUrl/api/ott/music-artist";
}

Map<String, String> get headers => {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${LocalStorageUtils.userToken}',
};

String noImgFound = "asset/image/no-poster-available.jpg";
String noDataImg = "asset/image/no_data.jpg";

enum ContentType { movie, series, shortfilm, live }

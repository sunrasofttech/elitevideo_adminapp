import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/bloc/ads/create_ads/create_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/delete_ads/delete_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_cubit.dart';
import 'package:elite_admin/bloc/ads/update_ads/update_ads_cubit.dart';
import 'package:elite_admin/bloc/auth/delete_admin/delete_admin_cubit.dart';
import 'package:elite_admin/bloc/auth/get_profile/get_profile_cubit.dart';
import 'package:elite_admin/bloc/auth/login/login_cubit.dart';
import 'package:elite_admin/bloc/auth/update_profile/update_profile_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_dashboard/get_dashboard_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_revenue_analysis/get_revenue_anaylsis_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_user_analysis/get_user_analysis_cubit.dart';
import 'package:elite_admin/bloc/livetv/ads/delete_live_tv_ads/delete_live_tv_ads_cubit.dart';
import 'package:elite_admin/bloc/livetv/ads/get_all_live_tv_ads/get_all_live_tv_ads_cubit.dart';
import 'package:elite_admin/bloc/livetv/ads/post_live_tv_ads/post_live_tv_ads_cubit.dart';
import 'package:elite_admin/bloc/livetv/ads/update_live_tv_ads/update_live_tv_ads_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/create_live_category/create_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/delete_live_category/delete_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/get_live_category/get_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/update_live_category/update_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/create_live_tv/createlivetv_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/delete_live_tv/delete_live_tv_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/update_live_tv/update_live_tv_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/create_castcrew/create_castcrew_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/delete_cast_crew/delete_cast_crew_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/get_all_castcrew/get_all_castcrew_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/update_cast_crew/update_cast_crew_cubit.dart';
import 'package:elite_admin/bloc/movie/category/delete_category/delete_category_cubit.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_cubit.dart';
import 'package:elite_admin/bloc/movie/category/post_category/post_category_cubit.dart';
import 'package:elite_admin/bloc/movie/category/update_category/update_category_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/delete_genre/delete_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/post_genre/post_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/update_genre/update_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/language/delete_language/delete_language_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/movie/language/post_language/post_language_cubit.dart';
import 'package:elite_admin/bloc/movie/language/update_language/update_language_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/delete_movie_ads/delete_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/get_all_movie_ads/get_all_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/post_movie_ads/post_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/update_movie_ads/update_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/delete_movie/delete_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/post_movie/post_movie_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/update_movie/update_movie_cubit.dart';
import 'package:elite_admin/bloc/music/artist/delete_artist/delete_artist_cubit.dart';
import 'package:elite_admin/bloc/music/artist/get_artist/get_artist_cubit.dart';
import 'package:elite_admin/bloc/music/artist/post_artist/post_artist_cubit.dart';
import 'package:elite_admin/bloc/music/artist/update_artist/update_artist_cubit.dart';
import 'package:elite_admin/bloc/music/category/delete_music_catrgory/delete_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/category/get_all_music_category/get_all_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/category/post_music_category/post_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/category/update_music_category/update_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/create_music/create_music_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/delete_music/delete_music_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/get_all_music/get_all_music_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/update_music/update_music_cubit.dart';
import 'package:elite_admin/bloc/notification/send_notification/send_notification_cubit.dart';
import 'package:elite_admin/bloc/rental/delete_rentals/delete_rentals_cubit.dart';
import 'package:elite_admin/bloc/rental/get_rentals/get_rentals_cubit.dart';
import 'package:elite_admin/bloc/rental/update_rentals/update_rentals_cubit.dart';
import 'package:elite_admin/bloc/reports/get_reports/get_reports_cubit.dart';
import 'package:elite_admin/bloc/setting/get_setting/get_setting_cubit.dart';
import 'package:elite_admin/bloc/setting/update_setting/update_setting_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/delete_short_film_ads/delete_short_film_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/get_short_film_ads/get_short_flim_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/post_short_flim_ads/post_short_film_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/update_short_film_ads/update_short_film_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/castcrew/create_short_film/create_short_film_castcrew_cubit.dart';
import 'package:elite_admin/bloc/short_film/castcrew/delete_castcrew_shortfilm/delete_castcrew_shortfilm_cubit.dart';
import 'package:elite_admin/bloc/short_film/castcrew/get_all_cast_crew_short_film/get_all_cast_crew_short_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/castcrew/update_castcrew_shortfilm/update_cast_crew_short_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/delete_film/delete_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/post_film/post_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/update/update_film_cubit.dart';
import 'package:elite_admin/bloc/subadmin/create_subadmin/create_subadmin_cubit.dart';
import 'package:elite_admin/bloc/subadmin/get_subadmin/get_subadmin_cubit.dart';
import 'package:elite_admin/bloc/subscription/create_subscription/create_subscription_cubit.dart';
import 'package:elite_admin/bloc/subscription/delete_subscription/delete_subscription_cubit.dart';
import 'package:elite_admin/bloc/subscription/get_subscription/get_subscription_cubit.dart';
import 'package:elite_admin/bloc/subscription/update_subscription/update_subscription_cubit.dart';
import 'package:elite_admin/bloc/tv_show/ads/delete_web_ads/delete_web_ads_cubit.dart';
import 'package:elite_admin/bloc/tv_show/ads/get_web_ads/get_web_ads_cubit.dart';
import 'package:elite_admin/bloc/tv_show/ads/post_web_ads/post_web_ads_cubit.dart';
import 'package:elite_admin/bloc/tv_show/ads/update_web_ads/update_web_ads_cubit.dart';
import 'package:elite_admin/bloc/tv_show/castcrew/create_cast_crew/create_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/tv_show/castcrew/delete_tv_show_castcrew/delete_tv_show_castcrew_cubit.dart';
import 'package:elite_admin/bloc/tv_show/castcrew/get_all_cast_crew/get_all_cast_crew_tv_show_cubit.dart';
import 'package:elite_admin/bloc/tv_show/castcrew/update_cast_crew_tv_show/update_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/delete_episode/delete_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/post_episode/post_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/update_episode/update_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/delete_season/delete_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/post_season/post_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/update_season/update_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/delete_tv_show/delete_tv_show_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/post_tv_show/post_tv_show_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/update_tv_show/update_tv_show_cubit.dart';
import 'package:elite_admin/bloc/users/delete_user/delete_user_cubit.dart';
import 'package:elite_admin/bloc/users/get_all_user/get_all_user_cubit.dart';
import 'package:elite_admin/bloc/users/post_user/post_user_cubit.dart';
import 'package:elite_admin/bloc/users/update_user/update_user_cubit.dart';
import 'package:elite_admin/bloc/web_series/ads/delete_web_ads/delete_web_ads_cubit.dart';
import 'package:elite_admin/bloc/web_series/ads/get_web_ads/get_web_ads_cubit.dart';
import 'package:elite_admin/bloc/web_series/ads/post_web_ads/post_web_ads_cubit.dart';
import 'package:elite_admin/bloc/web_series/ads/update_web_ads/update_web_ads_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/create_cast_crew/create_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/delete_webseries_castcrew/delete_webseries_castcrew_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/get_all_cast_crew/get_all_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/update_cast_crew_webseries/update_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/web_series/episode/delete_episode/delete_episode_cubit.dart';
import 'package:elite_admin/bloc/web_series/episode/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite_admin/bloc/web_series/episode/post_episode/post_episode_cubit.dart';
import 'package:elite_admin/bloc/web_series/episode/update_episode/update_episode_cubit.dart';
import 'package:elite_admin/bloc/web_series/season/delete_season/delete_season_cubit.dart';
import 'package:elite_admin/bloc/web_series/season/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/bloc/web_series/season/post_season/post_season_cubit.dart';
import 'package:elite_admin/bloc/web_series/season/update_season/update_season_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/delete_series/delete_series_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/get_all_series/get_all_series_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/post_series/post_series_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/update_series/update_series_cubit.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  BlocProvider(create: (context) => DeleteCategoryCubit()),
  BlocProvider(create: (context) => GetAllMovieCategoryCubit()),
  BlocProvider(create: (context) => PostCategoryCubit()),
  BlocProvider(create: (context) => UpdateCategoryCubit()),
  BlocProvider(create: (context) => LoginCubit()),
  BlocProvider(create: (context) => GetProfileCubit()),
  BlocProvider(create: (context) => UpdateProfileCubit()),
  BlocProvider(create: (context) => GetSettingCubit()),
  BlocProvider(create: (context) => UpdateSettingCubit()),
  BlocProvider(create: (context) => GetAllLanguageCubit()),
  BlocProvider(create: (context) => PostLanguageCubit()),
  BlocProvider(create: (context) => DeleteLanguageCubit()),
  BlocProvider(create: (context) => UpdateLanguageCubit()),
  BlocProvider(create: (context) => GetAllGenreCubit()),
  BlocProvider(create: (context) => PostGenreCubit()),
  BlocProvider(create: (context) => DeleteGenreCubit()),
  BlocProvider(create: (context) => UpdateGenreCubit()),
  BlocProvider(create: (context) => GetAllMovieCubit()),
  BlocProvider(create: (context) => PostMovieCubit()),
  BlocProvider(create: (context) => DeleteMovieCubit()),
  BlocProvider(create: (context) => UpdateMovieCubit()),
  BlocProvider(create: (context) => GetAllCastcrewCubit()),
  BlocProvider(create: (context) => CreateCastcrewCubit()),
  BlocProvider(create: (context) => DeleteCastCrewCubit()),
  BlocProvider(create: (context) => UpdateCastCrewCubit()),
  BlocProvider(create: (context) => GetAllUserCubit()),
  BlocProvider(create: (context) => PostUserCubit()),
  BlocProvider(create: (context) => DeleteUserCubit()),
  BlocProvider(create: (context) => UpdateUserCubit()),
  BlocProvider(create: (context) => GetAllMusicCategoryCubit()),
  BlocProvider(create: (context) => PostMusicCategoryCubit()),
  BlocProvider(create: (context) => UpdateMusicCategoryCubit()),
  BlocProvider(create: (context) => DeleteMusicCategoryCubit()),
  BlocProvider(create: (context) => GetAllShortFilmCubit()),
  BlocProvider(create: (context) => PostFilmCubit()),
  BlocProvider(create: (context) => UpdateFilmCubit()),
  BlocProvider(create: (context) => DeleteFilmCubit()),
  BlocProvider(create: (context) => GetAllMusicCubit()),
  BlocProvider(create: (context) => CreateMusicCubit()),
  BlocProvider(create: (context) => UpdateMusicCubit()),
  BlocProvider(create: (context) => DeleteMusicCubit()),
  BlocProvider(create: (context) => GetAllSeriesCubit()),
  BlocProvider(create: (context) => PostSeriesCubit()),
  BlocProvider(create: (context) => UpdateSeriesCubit()),
  BlocProvider(create: (context) => DeleteSeriesCubit()),
  BlocProvider(create: (context) => GetAllSeasonCubit()),
  BlocProvider(create: (context) => PostSeasonCubit()),
  BlocProvider(create: (context) => UpdateSeasonCubit()),
  BlocProvider(create: (context) => DeleteSeasonCubit()),
  BlocProvider(create: (context) => GetAllEpisodeCubit()),
  BlocProvider(create: (context) => PostEpisodeCubit()),
  BlocProvider(create: (context) => UpdateEpisodeCubit()),
  BlocProvider(create: (context) => DeleteEpisodeCubit()),
  BlocProvider(create: (context) => GetLiveCategoryCubit()),
  BlocProvider(create: (context) => CreateLiveCategoryCubit()),
  BlocProvider(create: (context) => UpdateLiveCategoryCubit()),
  BlocProvider(create: (context) => DeleteLiveCategoryCubit()),
  BlocProvider(create: (context) => GetLiveTvCubit()),
  BlocProvider(create: (context) => CreatelivetvCubit()),
  BlocProvider(create: (context) => UpdateLiveTvCubit()),
  BlocProvider(create: (context) => DeleteLiveTvCubit()),
  BlocProvider(create: (context) => CreateAdsCubit()),
  BlocProvider(create: (context) => UpdateAdsCubit()),
  BlocProvider(create: (context) => GetAllAdsCubit()),
  BlocProvider(create: (context) => DeleteAdsCubit()),
  BlocProvider(create: (context) => CreateSubadminCubit()),
  BlocProvider(create: (context) => GetSubadminCubit()),
  BlocProvider(create: (context) => GetUserAnalysisCubit()),
  BlocProvider(create: (context) => GetDashboardCubit()),
  BlocProvider(create: (context) => GetAllAdsCubit()),
  BlocProvider(create: (context) => DeleteAdsCubit()),
  BlocProvider(create: (context) => CreateAdsCubit()),
  BlocProvider(create: (context) => UpdateAdsCubit()),
  BlocProvider(create: (context) => GetAllMovieAdsCubit()),
  BlocProvider(create: (context) => PostMovieAdsCubit()),
  BlocProvider(create: (context) => DeleteMovieAdsCubit()),
  BlocProvider(create: (context) => UpdateMovieAdsCubit()),
  BlocProvider(create: (context) => CreateSubscriptionCubit()),
  BlocProvider(create: (context) => GetSubscriptionCubit()),
  BlocProvider(create: (context) => UpdateSubscriptionCubit()),
  BlocProvider(create: (context) => DeleteSubscriptionCubit()),
  BlocProvider(create: (context) => GetSubadminCubit()),
  BlocProvider(create: (context) => DeleteAdminCubit()),
  BlocProvider(create: (context) => UpdateWebAdsCubit()),
  BlocProvider(create: (context) => DeleteWebAdsCubit()),
  BlocProvider(create: (context) => GetWebAdsCubit()),
  BlocProvider(create: (context) => PostWebAdsCubit()),
  BlocProvider(create: (context) => UpdateShortFilmAdsCubit()),
  BlocProvider(create: (context) => DeleteShortFilmAdsCubit()),
  BlocProvider(create: (context) => GetShortFlimAdsCubit()),
  BlocProvider(create: (context) => PostShortFilmAdsCubit()),
  BlocProvider(create: (context) => SendNotificationCubit()),
  BlocProvider(create: (context) => GetRentalsCubit()),
  BlocProvider(create: (context) => GetReportsCubit()),
  BlocProvider(create: (context) => DeleteLiveTvAdsCubit()),
  BlocProvider(create: (context) => GetAllLiveTvAdsCubit()),
  BlocProvider(create: (context) => PostLiveTvAdsCubit()),
  BlocProvider(create: (context) => UpdateLiveTvAdsCubit()),
  BlocProvider(create: (context) => UpdateRentalsCubit()),
  BlocProvider(create: (context) => DeleteRentalsCubit()),
  BlocProvider(create: (context) => GetAllCastCrewWebseriesCubit()),
  BlocProvider(create: (context) => UpdateCastCrewWebseriesCubit()),
  BlocProvider(create: (context) => DeleteWebseriesCastcrewCubit()),
  BlocProvider(create: (context) => CreateCastCrewWebseriesCubit()),
  BlocProvider(create: (context) => GetAllCastCrewShortFilmCubit()),
  BlocProvider(create: (context) => UpdateCastCrewShortFilmCubit()),
  BlocProvider(create: (context) => DeleteCastcrewShortfilmCubit()),
  BlocProvider(create: (context) => CreateShortFilmCastcrewCubit()),

//Tv Show
  BlocProvider(create: (context) => DeleteTvShowWebAdsCubit()),
  BlocProvider(create: (context) => GetTvShowWebAdsCubit()),
  BlocProvider(create: (context) => PostTvShowWebAdsCubit()),
  BlocProvider(create: (context) => UpdateTvShowWebAdsCubit()),
  BlocProvider(create: (context) => CreateCastCrewTvShowCubit()),
  BlocProvider(create: (context) => DeleteTvShowCastcrewCubit()),
  BlocProvider(create: (context) => GetAllCastCrewTvShowCubit()),
  BlocProvider(create: (context) => UpdateCastCrewTvShowCubit()),
  BlocProvider(create: (context) => DeleteTvShowEpisodeCubit()),
  BlocProvider(create: (context) => GetAllTvShowEpisodeCubit()),
  BlocProvider(create: (context) => PostTvShowEpisodeCubit()),
  BlocProvider(create: (context) => UpdateTvShowEpisodeCubit()),
  BlocProvider(create: (context) => DeleteTvShowSeasonCubit()),
  BlocProvider(create: (context) => GetAllTvShowSeasonCubit()),
  BlocProvider(create: (context) => PostTvShowSeasonCubit()),
  BlocProvider(create: (context) => UpdateTvShowSeasonCubit()),
  BlocProvider(create: (context) => DeleteTvShowSeasonCubit()),
  BlocProvider(create: (context) => GetAllTvShowSeasonCubit()),
  BlocProvider(create: (context) => PostTvShowSeasonCubit()),
  BlocProvider(create: (context) => UpdateTvShowSeasonCubit()),
  BlocProvider(create: (context) => DeleteTvShowSeriesCubit()),
  BlocProvider(create: (context) => GetAllTvShowSeriesCubit()),
  BlocProvider(create: (context) => PostTvShowSeriesCubit()),
  BlocProvider(create: (context) => UpdateTvShowSeriesCubit()),
  BlocProvider(create: (context) => GetRevenueAnaylsisCubit()),

  BlocProvider(create: (context) => GetArtistCubit()),
  BlocProvider(create: (context) => PostArtistCubit()),
  BlocProvider(create: (context) => UpdateArtistCubit()),
  BlocProvider(create: (context) => DeleteArtistCubit()),
];

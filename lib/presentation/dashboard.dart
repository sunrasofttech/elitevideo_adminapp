import 'dart:developer';
import 'package:elite_admin/bloc/trailer/get_all_trailer/get_all_trailer_cubit.dart';
import 'package:elite_admin/presentation/trailer/trailer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/bloc/ads/get_all_ads/get_all_ads_cubit.dart';
import 'package:elite_admin/bloc/auth/get_profile/get_profile_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_dashboard/get_dashboard_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_revenue_analysis/get_revenue_anaylsis_cubit.dart';
import 'package:elite_admin/bloc/dashboard/get_user_analysis/get_user_analysis_cubit.dart';
import 'package:elite_admin/bloc/livetv/ads/get_all_live_tv_ads/get_all_live_tv_ads_cubit.dart';
import 'package:elite_admin/bloc/livetv/category/get_live_category/get_live_category_cubit.dart';
import 'package:elite_admin/bloc/livetv/create/get_live_tv/get_live_tv_cubit.dart';
import 'package:elite_admin/bloc/movie/cast_crew/get_all_castcrew/get_all_castcrew_cubit.dart';
import 'package:elite_admin/bloc/movie/category/get_all_category/get_all_category_cubit.dart';
import 'package:elite_admin/bloc/movie/genre/get_all_genre/get_all_genre_cubit.dart';
import 'package:elite_admin/bloc/movie/language/get_all_language/get_all_language_cubit.dart';
import 'package:elite_admin/bloc/movie/movie%20ads/get_all_movie_ads/get_all_movie_ads_cubit.dart';
import 'package:elite_admin/bloc/movie/upload_movie/get_all_movie/get_all_movie_cubit.dart';
import 'package:elite_admin/bloc/music/artist/get_artist/get_artist_cubit.dart';
import 'package:elite_admin/bloc/music/category/get_all_music_category/get_all_music_category_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/get_all_music/get_all_music_cubit.dart';
import 'package:elite_admin/bloc/rental/get_rentals/get_rentals_cubit.dart';
import 'package:elite_admin/bloc/reports/get_reports/get_reports_cubit.dart';
import 'package:elite_admin/bloc/setting/get_setting/get_setting_cubit.dart';
import 'package:elite_admin/bloc/short_film/ads/get_short_film_ads/get_short_flim_ads_cubit.dart';
import 'package:elite_admin/bloc/short_film/castcrew/get_all_cast_crew_short_film/get_all_cast_crew_short_film_cubit.dart';
import 'package:elite_admin/bloc/short_film/get_all_short_flim/get_all_short_film_cubit.dart';
import 'package:elite_admin/bloc/subadmin/get_subadmin/get_subadmin_cubit.dart';
import 'package:elite_admin/bloc/subscription/get_subscription/get_subscription_cubit.dart';
import 'package:elite_admin/bloc/tv_show/ads/get_web_ads/get_web_ads_cubit.dart';
import 'package:elite_admin/bloc/tv_show/castcrew/get_all_cast_crew/get_all_cast_crew_tv_show_cubit.dart';
import 'package:elite_admin/bloc/tv_show/episode_tv_show/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite_admin/bloc/users/get_all_user/get_all_user_cubit.dart';
import 'package:elite_admin/bloc/web_series/ads/get_web_ads/get_web_ads_cubit.dart';
import 'package:elite_admin/bloc/web_series/castcrew/get_all_cast_crew/get_all_cast_crew_webseries_cubit.dart';
import 'package:elite_admin/bloc/web_series/episode/get_all_episode/get_all_episode_cubit.dart';
import 'package:elite_admin/bloc/web_series/season/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/bloc/web_series/series/get_all_series/get_all_series_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/model/drawer_model.dart';
import 'package:elite_admin/presentation/ads/ads.dart';
import 'package:elite_admin/presentation/auth/login_screen.dart';
import 'package:elite_admin/presentation/auth/profile.dart';
import 'package:elite_admin/presentation/dashboard/admin_dashboard.dart';
import 'package:elite_admin/presentation/live_tv/ads/live_tv_ads.dart';
import 'package:elite_admin/presentation/live_tv/category/category.dart';
import 'package:elite_admin/presentation/live_tv/live_tv.dart';
import 'package:elite_admin/presentation/movie/ads/movie_ads.dart';
import 'package:elite_admin/presentation/movie/castcrew/cast_crew.dart';
import 'package:elite_admin/presentation/movie/genre/genre.dart';
import 'package:elite_admin/presentation/movie/language/language_screen.dart';
import 'package:elite_admin/presentation/movie/movie/movie_category.dart';
import 'package:elite_admin/presentation/movie/movie/movie_screen.dart';
import 'package:elite_admin/presentation/notification/notification.dart';
import 'package:elite_admin/presentation/rental/rental.dart';
import 'package:elite_admin/presentation/reports/reports.dart';
import 'package:elite_admin/presentation/setting/setting_screen.dart';
import 'package:elite_admin/presentation/short_flim/ads/short_ads.dart';
import 'package:elite_admin/presentation/short_flim/cast_crew/cast_crew.dart';
import 'package:elite_admin/presentation/short_flim/short_films.dart';
import 'package:elite_admin/presentation/song/artist/artist.dart';
import 'package:elite_admin/presentation/song/song.dart';
import 'package:elite_admin/presentation/song/song_category.dart';
import 'package:elite_admin/presentation/subadmin/subadmin.dart';
import 'package:elite_admin/presentation/subscription/subscription.dart';
import 'package:elite_admin/presentation/tv_show/ads/tv_show.dart';
import 'package:elite_admin/presentation/tv_show/cast_crew/cast_crew.dart';
import 'package:elite_admin/presentation/tv_show/episode/episode.dart';
import 'package:elite_admin/presentation/tv_show/season/season.dart';
import 'package:elite_admin/presentation/tv_show/tv_show.dart';
import 'package:elite_admin/presentation/users/user.dart';
import 'package:elite_admin/presentation/web_series/ads/web_series_ads.dart';
import 'package:elite_admin/presentation/web_series/cast_crew/cast_crew.dart';
import 'package:elite_admin/presentation/web_series/episode/episode.dart';
import 'package:elite_admin/presentation/web_series/season/season.dart';
import 'package:elite_admin/presentation/web_series/web_series.dart';
import 'package:elite_admin/utils/preferences/local_preferences.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_app_bar.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with Utility {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  List<DrawerItem> _drawerItems = [];
  int _selectedScreenIndex = 0;
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    context.read<GetProfileCubit>().getProfile(context);
    context.read<GetAllMovieCubit>().getAllMovie();
    context.read<GetAllMovieCategoryCubit>().getAllMovieCategory();
    context.read<GetAllGenreCubit>().getGenre();
    context.read<GetAllLanguageCubit>().getAllLanguage();
    context.read<GetAllSeasonCubit>().getAllSeason();
    context.read<GetLiveCategoryCubit>().getAllLiveCategory();
    context.read<GetLiveTvCubit>().getAllLiveCategory();
    context.read<GetAllEpisodeCubit>().getAllEpisode();
    context.read<GetAllMovieAdsCubit>().getAllMovies();
    context.read<GetDashboardCubit>().getDashboard();
    context.read<GetSubadminCubit>().getSubAdmins();
    context.read<GetUserAnalysisCubit>().getUserAnalysis();
    context.read<GetRevenueAnaylsisCubit>().getRevenueAnalysis();
    context.read<GetAllTrailerCubit>().getAllTrailer();
    context.read<GetAllSeriesCubit>().getAllSeries();
    context.read<GetWebAdsCubit>().getAllWebAds();
    context.read<GetArtistCubit>().getAllArtist();
    context.read<GetAllTvShowSeriesCubit>().getAllSeries();
    context.read<GetAllTvShowEpisodeCubit>().getAllEpisode();
    context.read<GetAllTvShowSeasonCubit>().getAllSeason();
    context.read<GetAllMovieAdsCubit>().getAllMovies();
    context.read<GetTvShowWebAdsCubit>().getAllWebAds();
    context.read<GetShortFlimAdsCubit>().getAllWebAds();
    context.read<GetAllAdsCubit>().getAllAds();
    context.read<GetAllUserCubit>().getAllUser();
    context.read<GetAllShortFilmCubit>().getAllShortFilm();
    context.read<GetRentalsCubit>().getRentals();
    context.read<GetReportsCubit>().getReports();
    context.read<GetAllCastCrewTvShowCubit>().getAllCastCrew();
    context.read<GetAllMusicCategoryCubit>().getAllMusic();
    context.read<GetAllMusicCubit>().getAllMusic();
    context.read<GetAllCastcrewCubit>().getAllCastCrew();
    context.read<GetSettingCubit>().getSetting();
    context.read<GetAllLiveTvAdsCubit>().getAllLiveTvAds();
    context.read<GetSubscriptionCubit>().getAllSub();
    context.read<GetAllCastCrewShortFilmCubit>().getAllCastCrew();
    context.read<GetAllCastCrewWebseriesCubit>().getAllCastCrew();
  }

  void _initializeData(Map<String, bool>? permissions) {
    _drawerItems = [
      if (permissions?['Dashboard'] == true)
        DrawerItem(
          title: 'Dashboard OverView',
          tag: null,
          icon: AppImages.dashboardSvg,
          screen: AdminDashboardScreen(
            onMenuTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          index: 0,
        ),
      if (permissions?['Movie'] == true)
        DrawerItem(
          title: 'Movies',
          icon: AppImages.movieSvg,
          tag: "quick",
          children: [
            DrawerItem(title: 'Movie', icon: AppImages.movieSvg, tag: "quick", screen: const MovieScreen(), index: 1),
            DrawerItem(
              title: 'Cast Crew',
              icon: AppImages.movieSvg,
              tag: "quick",
              screen: const CastCrewScreen(),
              index: 2,
            ),
            DrawerItem(
              title: 'Movie Ads',
              icon: "asset/svg/video (1).svg",
              tag: "quick",
              screen: const MovieAdsScreen(),
              index: 3,
            ),
          ],
        ),
      if (permissions?['Music'] == true)
        DrawerItem(
          title: 'Songs',
          icon: AppImages.songSvg,
          tag: "quick",
          children: [
            DrawerItem(title: 'Songs', icon: AppImages.songSvg, tag: "quick", index: 4, screen: const SongScreen()),
            DrawerItem(title: 'Artists', icon: AppImages.songSvg, tag: "quick", index: 5, screen: const ArtistScreen()),
          ],
        ),
      if (permissions?['Web Series'] == true)
        DrawerItem(
          title: 'Web Series',
          icon: AppImages.webSeriesSvg,
          tag: "quick",
          children: [
            DrawerItem(
              title: 'WebSeries',
              icon: AppImages.webSeriesSvg,
              tag: "quick",
              screen: const WebSeriesScreen(),
              index: 6,
            ),
            DrawerItem(
              title: 'Season',
              icon: AppImages.webSeriesSvg,
              tag: "quick",
              screen: const SeasonScreen(),
              index: 7,
            ),
            DrawerItem(
              title: 'Episode',
              icon: AppImages.webSeriesSvg,
              tag: "quick",
              screen: const EpisodeScreen(),
              index: 8,
            ),
            DrawerItem(
              title: 'Web Series Ads',
              icon: "asset/svg/video (2).svg",
              tag: "quick",
              screen: const WebSeriesAdsScreen(),
              index: 9,
            ),
            DrawerItem(
              title: 'Cast Crew',
              icon: AppImages.webSeriesSvg,
              tag: "quick",
              screen: const WebScreenCastCrewScreen(),
              index: 10,
            ),
          ],
        ),
      if (permissions?['Tv Show'] == true)
        DrawerItem(
          title: 'Tv Shows',
          icon: AppImages.webSeriesSvg,
          tag: "quick",
          children: [
            DrawerItem(
              title: 'Tv Shows',
              icon: "asset/svg/tv-show.svg",
              tag: "quick",
              screen: const TvShowScreen(),
              index: 11,
            ),
            DrawerItem(
              title: 'TV Show Season',
              icon: "asset/svg/tv-show.svg",
              tag: "quick",
              screen: const TvShowSeasonScreen(),
              index: 12,
            ),
            DrawerItem(
              title: 'TV Show Episode',
              icon: "asset/svg/tv-show.svg",
              tag: "quick",
              screen: const TvShowEpisodeScreen(),
              index: 13,
            ),
            DrawerItem(
              title: 'TV Show Ads',
              icon: "asset/svg/adwords.svg",
              tag: "quick",
              screen: const TvShowAdsScreen(),
              index: 14,
            ),
            DrawerItem(
              title: 'TV Show Cast Crew',
              icon: "asset/svg/tv-show.svg",
              tag: "quick",
              screen: const TvShowCastCrewScreen(),
              index: 15,
            ),
          ],
        ),
      if (permissions?['Live TV'] == true)
        DrawerItem(
          title: 'Live TV',
          icon: AppImages.tvSvg,
          tag: "quick",
          children: [
            DrawerItem(title: 'Live TV', icon: AppImages.tvSvg, tag: "quick", screen: const TvShowScreen(), index: 16),
            DrawerItem(
              title: 'Live Tv Ads',
              icon: "asset/svg/video.svg",
              tag: "quick",
              screen: const LiveTvScreen(),
              index: 17,
            ),
          ],
        ),
      if (permissions?['Short Film'] == true)
        DrawerItem(
          title: 'Short Flim',
          icon: AppImages.dramaSvg,
          tag: "quick",
          children: [
            DrawerItem(
              title: 'Short Flim',
              icon: AppImages.dramaSvg,
              tag: "quick",
              screen: const ShortFilmsScreen(),
              index: 18,
            ),
            DrawerItem(
              title: 'Short Flim Cast Crew',
              icon: AppImages.dramaSvg,
              tag: "quick",
              screen: const ShortFilmCastCrewScreen(),
              index: 19,
            ),
            DrawerItem(
              title: 'Short Film Ads',
              icon: "asset/svg/adwords.svg",
              tag: "quick",
              screen: const ShortFlimAdsScreen(),
              index: 20,
            ),
          ],
        ),
      DrawerItem(
        title: 'Trailer',
        icon: "asset/svg/languages.svg",
        screen: const TrailerScreen(),
        tag: "quick",
        index: 21,
      ),
      if (permissions?['Ads'] == true)
        DrawerItem(title: 'Ads', icon: "asset/svg/adwords.svg", screen: const AdsScreen(), tag: "quick", index: 22),
      if (permissions?['Movie'] == true)
        DrawerItem(
          title: 'Movie Categories',
          icon: "asset/svg/television.svg",
          screen: const MovieCategoryScreen(),
          tag: "menu",
          index: 23,
        ),
      if (permissions?['Music'] == true)
        DrawerItem(
          title: 'Songs Categories',
          icon: "asset/svg/music-note.svg",
          screen: const SongCategoryScreen(),
          tag: "menu",
          index: 24,
        ),
      if (permissions?['Live TV'] == true)
        DrawerItem(
          title: 'Live TV Categories',
          icon: "asset/svg/tv-show.svg",
          screen: const LiveTvCategoryScreen(),
          tag: "menu",
          index: 25,
        ),
      if (permissions?['Rentals'] == true)
        DrawerItem(title: 'Rentals', icon: AppImages.rentalsSvg, screen: const RentalScreen(), tag: "menu", index: 26),
      if (permissions?['Language'] == true)
        DrawerItem(
          title: 'Language',
          icon: "asset/svg/languages.svg",
          screen: const LanguageScreen(),
          tag: "menu",
          index: 27,
        ),
      if (permissions?['Genre'] == true)
        DrawerItem(title: 'Genre', icon: AppImages.languageSvg, screen: const GenreScreen(), tag: "menu", index: 28),
      if (permissions?['Users'] == true)
        DrawerItem(title: 'Users', icon: AppImages.userSvg, screen: const UserScreen(), tag: "menu", index: 29),
      if (permissions?['Sub Admin'] == true)
        DrawerItem(title: 'SubAdmin', icon: AppImages.userSvg, screen: const SubAdminScreen(), tag: "menu", index: 30),
      if (permissions?['Subscription'] == true)
        DrawerItem(
          title: 'Subscription',
          icon: AppImages.subscriptionSvg,
          screen: const SubscriptionScreen(),
          tag: "menu",
          index: 31,
        ),
      if (permissions?['Reports'] == true)
        DrawerItem(title: 'Reports', icon: AppImages.reportsSvg, screen: const ReportScreen(), tag: "menu", index: 32),
      if (permissions?['Notification'] == true)
        DrawerItem(
          title: 'Notification',
          icon: AppImages.notificationSvg,
          screen: const NotificationScreen(),
          tag: "menu",
          index: 33,
        ),
      if (permissions?['Settings'] == true)
        DrawerItem(
          title: 'Settings',
          icon: AppImages.settingSvg,
          screen: const SettingScreen(),
          tag: "menu",
          index: 34,
        ),
    ];

    _screens = [
      AdminDashboardScreen(
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
          log("message called.");
        },
      ),
      const MovieScreen(),
      const CastCrewScreen(),
      const MovieAdsScreen(),
      const SongScreen(),
      const ArtistScreen(),
      const WebSeriesScreen(),
      const SeasonScreen(),
      const EpisodeScreen(),
      const WebSeriesAdsScreen(),
      const WebScreenCastCrewScreen(),
      const TvShowScreen(),
      const TvShowSeasonScreen(),
      const TvShowEpisodeScreen(),
      const TvShowAdsScreen(),
      const TvShowCastCrewScreen(),
      const LiveTvScreen(),
      const LiveTVAdsScreen(),
      const ShortFilmsScreen(),
      const ShortFilmCastCrewScreen(),
      const ShortFlimAdsScreen(),
      TrailerScreen(),
      const AdsScreen(),
      const MovieCategoryScreen(),
      const SongCategoryScreen(),
      const LiveTvCategoryScreen(),
      const RentalScreen(),
      const LanguageScreen(),
      const GenreScreen(),
      const UserScreen(),
      const SubAdminScreen(),
      const SubscriptionScreen(),
      const ReportScreen(),
      const NotificationScreen(),
      const SettingScreen(),
    ];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DrawerItem? selectedItem = _drawerItems
        .expand((item) {
          log("message = = = ${item.screen}");
          if (item.children != null) {
            return [item, ...item.children ?? []];
          }
          return [item];
        })
        .firstWhere(
          (item) => item.index == _selectedScreenIndex,
          orElse: () => _drawerItems.isNotEmpty ? _drawerItems.first : null,
        );

    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Do you want to exit the app?"),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("No")),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Yes")),
            ],
          ),
        );

        return shouldExit;
      },
      child: BlocConsumer<GetProfileCubit, GetProfileState>(
        listener: (context, state) {
          if (state is GetProfileErrorState &&
              (state.error.contains("Session expired. Please login again") ||
                  state.error.contains("Invalid or expired token"))) {
            LocalStorageUtils.clear().then((e) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            });
          }
          if (state is GetProfileLoadedState) {
            _initializeData(state.model.admin?.permissions);
          }
        },
        builder: (context, state) {
          if (state is GetProfileLoadingState) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          if (state is GetProfileErrorState) {
            return const Scaffold(body: Center(child: CustomErrorWidget()));
          }
          return Scaffold(
            key: _scaffoldKey,
            appBar: _selectedScreenIndex == 0
                ? null
                : PreferredSize(
                    preferredSize: const Size(double.infinity, 70),
                    child: CustomAppBar(
                      settingOnTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                      },
                      notificationOnTap: () {
                        setState(() {
                          _selectedScreenIndex = 18;
                        });
                      },
                      text: selectedItem?.title ?? "",
                      leading: Builder(
                        builder: (context) => InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Row(
                            children: [
                              widthBox10(),
                              svgAsset(
                                assetName: AppImages.drawerSvg,
                                height: 30,
                                color: AppColors.greyColor,
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            body: _screens.isEmpty
                ? const Center(child: CustomCircularProgressIndicator())
                : (_selectedScreenIndex < _screens.length ? _screens[_selectedScreenIndex] : _screens[0]),
            drawer: Drawer(
              backgroundColor: AppColors.lightGreyColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    heightBox10(),
                    TextFormFieldWidget(
                      hintText: "Search",
                      contentPadding: 3,
                      rounded: 15,
                      backgroundColor: const Color.fromRGBO(173, 170, 170, 0.32),
                      isSuffixIconShow: true,
                      controller: searchController,
                      onChanged: (p0) {},
                      suffixIcon: InkWell(onTap: () {}, child: const Icon(Icons.search)),
                    ),
                    heightBox15(),
                    ..._drawerItems.where((item) => item.tag == null).map((item) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: ListTile(
                          leading: svgAsset(assetName: item.icon, width: 24, height: 24),
                          title: Text(item.title),
                          onTap: () {
                            if (item.screen != null) {
                              setState(() {
                                _selectedScreenIndex = item.index ?? 0;
                                log("_selectedScreenIndex -1 $_selectedScreenIndex");
                              });
                              Navigator.pop(context);
                            }
                          },
                        ),
                      );
                    }).toList(),
                    heightBox10(),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            child: TextWidget(text: "Quick"),
                          ),
                          ..._drawerItems.where((item) => item.tag == "quick").map((item) {
                            if (item.children != null && item.children!.isNotEmpty) {
                              return ExpansionTile(
                                collapsedIconColor: AppColors.blackColor,
                                expandedAlignment: Alignment.centerLeft,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                                childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
                                collapsedShape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                iconColor: AppColors.greyColor,
                                enabled: true,
                                leading: svgAsset(assetName: item.icon, width: 24, height: 24),
                                title: Text(item.title),
                                children: item.children!.map((child) {
                                  return ListTile(
                                    leading: svgAsset(assetName: child.icon, width: 24, height: 24),
                                    title: Text(child.title),
                                    onTap: () {
                                      if (child.screen != null) {
                                        setState(() {
                                          _selectedScreenIndex = child.index ?? 0;
                                          log("_selectedScreenIndex 0 $_selectedScreenIndex");
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            } else {
                              return ListTile(
                                leading: svgAsset(assetName: item.icon, width: 24, height: 24),
                                title: Text(item.title),
                                onTap: () {
                                  if (item.screen != null) {
                                    setState(() {
                                      _selectedScreenIndex = item.index ?? 0;
                                    });
                                    log("_selectedScreenIndex 1 $_selectedScreenIndex");
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            }
                          }).toList(),
                        ],
                      ),
                    ),
                    heightBox15(),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            child: TextWidget(text: "Menu"),
                          ),
                          ..._drawerItems.where((item) => item.tag == "menu").map((item) {
                            if (item.children != null && item.children!.isNotEmpty) {
                              return ExpansionTile(
                                collapsedIconColor: AppColors.blackColor,
                                expandedAlignment: Alignment.centerLeft,
                                initiallyExpanded: true,
                                dense: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                collapsedShape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                iconColor: AppColors.greyColor,
                                enabled: true,
                                leading: svgAsset(assetName: item.icon, width: 24, height: 24),
                                title: Text(item.title),
                                children: item.children!.map((child) {
                                  return ListTile(
                                    leading: svgAsset(assetName: child.icon, width: 24, height: 24),
                                    title: Text(child.title),
                                    onTap: () {
                                      if (child.screen != null) {
                                        setState(() {
                                          _selectedScreenIndex = child.index ?? 0;
                                        });

                                        log("_selectedScreenIndex 2  $_selectedScreenIndex");
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                }).toList(),
                              );
                            } else {
                              return ListTile(
                                leading: svgAsset(assetName: item.icon, width: 24, height: 24),
                                title: Text(item.title),
                                onTap: () {
                                  if (item.screen != null) {
                                    setState(() {
                                      _selectedScreenIndex = item.index ?? 0;
                                      log("_selectedScreenIndex 1: $_selectedScreenIndex ${item.screen}");

                                      log("📦 _drawerItems (screens):");
                                      for (var item in _drawerItems) {
                                        if (item.screen != null) {
                                          log(
                                            "➡️ ${item.title} | screen: ${item.screen.runtimeType} | index: ${item.index}",
                                          );
                                        }
                                        if (item.children != null && item.children!.isNotEmpty) {
                                          for (var child in item.children!) {
                                            log(
                                              "   └── 🧒 ${child.title} | screen: ${child.screen.runtimeType} | index: ${child.index}",
                                            );
                                          }
                                        }
                                      }

                                      log("📺 _screens (${_screens.length} total):");
                                      for (int i = 0; i < _screens.length; i++) {
                                        log("[$i] => ${_screens[i].runtimeType}");
                                      }
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            }
                          }).toList(),
                        ],
                      ),
                    ),
                    heightBox10(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

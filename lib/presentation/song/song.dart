import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite_admin/utils/apiurls/api.dart';
import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/bloc/music/upload_music/delete_music/delete_music_cubit.dart';
import 'package:elite_admin/bloc/music/upload_music/get_all_music/get_all_music_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/presentation/song/add_update_song.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/custom_pagination.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> with Utility {
  int currentPage = 1;
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<GetAllMusicCubit>().getAllMusic();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: ListView(
            children: [
              const TextWidget(text: "Songs", fontSize: 15, fontWeight: FontWeight.w600),
              heightBox15(),
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      controller: searchController,
                      isSuffixIconShow: true,
                      onChanged: (p0) {
                        context.read<GetAllMusicCubit>().getAllMusic(search: p0);
                      },
                      hintText: "search song",
                      suffixIcon: const Icon(Icons.search, color: AppColors.blackColor),
                    ),
                  ),
                  widthBox10(),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUpdateSongScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(colors: AppColors.blueGradientList),
                      ),
                      child: Row(
                        children: [
                          const TextWidget(text: "Add", color: AppColors.whiteColor),
                          widthBox5(),
                          const Icon(Icons.add_circle_rounded, color: AppColors.whiteColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              heightBox10(),
              BlocListener<DeleteMusicCubit, DeleteMusicState>(
                listener: (context, state) {
                  if (state is DeleteMusicErrorState) {
                   showMessage(context,  state.error);
                    return;
                  }

                  if (state is DeleteMusicLoadedState) {
                   showMessage(context,  "Delete Successfully");
                    context.read<GetAllMusicCubit>().getAllMusic();
                    Navigator.pop(context);
                  }
                },
                child: BlocBuilder<GetAllMusicCubit, GetAllMusicState>(
                  builder: (context, state) {
                    if (state is GetAllMusicLoadingState) {
                      return const Center(child: CustomCircularProgressIndicator());
                    }

                    if (state is GetAllMusicErrorState) {
                      return const CustomErrorWidget();
                    }
                    if (state is GetAllMusicLoadedState) {
                      return state.model.data?.items?.isEmpty ?? true
                          ? const Center(child: CustomEmptyWidget())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = state.model.data?.items?[index];
                                return Card(
                                  color: AppColors.whiteColor,
                                  surfaceTintColor: AppColors.whiteColor,
                                  child: Container(
                                    height: 130,
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: CachedNetworkImage(
                                            imageUrl: "${AppUrls.baseUrl}/${data?.coverImg}",
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                text: '${data?.songTitle}',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              heightBox5(),
                                              TextWidget(text: data?.artist?.artistName ?? ""),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => AddUpdateSongScreen(id: data?.id, data: data),
                                                  ),
                                                );
                                              },
                                              child: svgAsset(assetName: AppImages.editSvg, height: 32, width: 30),
                                            ),
                                            heightBox5(),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return DeleteDialog(
                                                      onCancelPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      onDeletePressed: () {
                                                        context.read<DeleteMusicCubit>().deleteMusic(data?.id ?? "");
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              child: svgAsset(assetName: AppImages.deleteSvg, height: 32, width: 28),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: state.model.data?.items?.length,
                            );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              heightBox15(),
              BlocBuilder<GetAllMusicCubit, GetAllMusicState>(
                builder: (context, state) {
                  if (state is GetAllMusicLoadedState) {
                    return CustomPagination(
                      currentPage: currentPage,
                      totalPages: state.model.data?.totalPages ?? 0,
                      onPageChanged: (e) {
                        setState(() {
                          currentPage = e;
                        });
                        context.read<GetAllMusicCubit>().getAllMusic(page: currentPage);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

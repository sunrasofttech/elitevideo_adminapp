import 'package:elite_admin/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elite_admin/bloc/tv_show/season_tv_show/get_all_season/get_all_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/post_season/post_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/season_tv_show/update_season/update_season_cubit.dart';
import 'package:elite_admin/bloc/tv_show/tv_show/get_all_tv_show/get_all_tv_show_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/model/season_model.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_dropdown.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

import '../../../bloc/tv_show/season_tv_show/get_all_season/get_all_season_model.dart';

class TvShowSeasonAddUpdateScreen extends StatefulWidget {
  const TvShowSeasonAddUpdateScreen({
    super.key,
    this.id,
    this.data,
  });
  final String? id;
  final Datum? data;

  @override
  State<TvShowSeasonAddUpdateScreen> createState() => _TvShowSeasonAddUpdateScreenState();
}

class _TvShowSeasonAddUpdateScreenState extends State<TvShowSeasonAddUpdateScreen> with Utility {
  String? selectedSeason;
  String? selectedSeasonId;
  bool status = true;
  List<Season> seasonList = [];

  final TextEditingController _seasonController = TextEditingController();
  final TextEditingController _releasedDateController = TextEditingController();
  final _seasonFocusNode = FocusNode();
  final _releasedDateFocusNode = FocusNode();
  int? editingIndex;

  @override
  void dispose() {
    _seasonController.dispose();
    _releasedDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.data != null) {
      var data = widget.data;
      _seasonController.text = data?.seasonName ?? "";
      status = data?.status ?? false;
      _releasedDateController.text = data?.releasedDate ?? "";
    }
    super.initState();
  }

  void onEdit(int index) {
    setState(() {
      final selectedSeason = seasonList[index];
      _seasonController.text = selectedSeason.seasonName;
      _releasedDateController.text = selectedSeason.releasedDate;
      status = selectedSeason.status;
      selectedSeasonId = selectedSeason.seriesId;
      editingIndex = index;
    });
  }

  void onDelete(int index) {
    setState(() {
      seasonList.removeAt(index);
      if (editingIndex == index) {
        editingIndex = null;
        _seasonController.clear();
        _releasedDateController.clear();
      }
    });
  }

  void addOrUpdateSeason() {
    _releasedDateFocusNode.unfocus();
    _seasonFocusNode.unfocus();
    final name = _seasonController.text.trim();
    final releasedDate = _releasedDateController.text.trim();
    if (widget.id != null) {
      context.read<UpdateTvShowSeasonCubit>().updateSeason(
            seasonName: _seasonController.text,
            status: status,
            id: widget.id ?? "",
          );
      return;
    }
    if (name.isEmpty || releasedDate.isEmpty || selectedSeasonId == null) return;

    final season = Season(
      seasonName: name,
      status: status,
      seriesId: selectedSeasonId!,
      releasedDate: releasedDate,
      showType: "tvshows"
    );

    setState(() {
      if (editingIndex != null) {
        seasonList[editingIndex!] = season;
        editingIndex = null;
      } else {
        seasonList.add(season);
      }
      _seasonController.clear();
      _releasedDateController.clear();
    });
  }

  void uploadSeasons() {
    if (seasonList.isNotEmpty) {
      context.read<PostTvShowSeasonCubit>().postSeason(season: seasonList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heightBox50(),
                const TextWidget(
                  text: "Select Series",
                ),
                const SizedBox(height: 10),
                BlocListener<UpdateTvShowSeasonCubit, UpdateSeasonState>(
                  listener: (context, state) {
                    if (state is UpdateSeasonErrorState) {
                     showMessage(context, state.error);
                      return;
                    }

                    if (state is UpdateSeasonLoadedState) {
                     showMessage(context, "Update Successfully");
                      Navigator.pop(context);
                      context.read<GetAllTvShowSeasonCubit>().getAllSeason();
                    }
                  },
                  child: BlocBuilder<GetAllTvShowSeriesCubit, GetAllSeriesState>(
                    builder: (context, state) {
                      if (state is GetAllSeriesLoadedState) {
                        final genres =
                            state.model.data?.map((datum) => datum.seriesName).whereType<String>().toList() ?? [];
                        return CustomDropdown(
                          items: genres,
                          selectedValue: selectedSeason,
                          onChanged: (value) {
                            setState(() {
                              selectedSeason = value;
                              final selectedDatum = state.model.data?.firstWhere((datum) => datum.seriesName == value);
                              if (kDebugMode) {
                                print("Selected Datum ID: ${selectedDatum?.id}");
                              }
                              selectedSeasonId = selectedDatum?.id;
                            });
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const TextWidget(
                  text: "Season Name",
                ),
                const SizedBox(height: 5),
                TextFormFieldWidget(
                  controller: _seasonController,
                  focusNode: _seasonFocusNode,
                ),
                const SizedBox(height: 10),
                heightBox10(),
                const TextWidget(
                  text: "Released Date",
                ),
                heightBox5(),
                TextFormFieldWidget(
                  focusNode: _releasedDateFocusNode,
                  controller: _releasedDateController,
                  readOnly: true,
                  isSuffixIconShow: true,
                  suffixIcon: InkWell(
                      onTap: () {
                        selectDate(context, _releasedDateController);
                      },
                      child: const Icon(Icons.calendar_month_outlined)),
                ),
                heightBox10(),
                const TextWidget(
                  text: "Status",
                ),
                heightBox10(),
                Switch(
                    activeColor: AppColors.zGreenColor,
                    value: status,
                    onChanged: (v) {
                      setState(() {
                        status = v;
                      });
                    }),
                heightBox10(),
                BlocConsumer<PostTvShowSeasonCubit, PostSeasonState>(
                  listener: (context, state) {
                    if (state is PostSeasonErrorState) {
                     showMessage(context, "${state.error} ❌");
                      return;
                    }
                    if (state is PostSeasonLoadedState) {
                      context.read<GetAllTvShowSeasonCubit>().getAllSeason();
                     showMessage(context, "Post Sucessfully ✅");
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    return CustomOutlinedButton(
                      inProgress: (state is PostSeasonLoadingState),
                      onPressed: addOrUpdateSeason,
                      buttonText: widget.id != null
                          ? "Update Season"
                          : editingIndex != null
                              ? 'Update'
                              : 'Add',
                    );
                  },
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: seasonList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.blueGradientList,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: seasonList[index].seasonName,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              TextWidget(
                                text: "Released Date : ${seasonList[index].releasedDate}",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              TextWidget(
                                text: "Status : ${seasonList[index].status == true ? "ON" : "OFF"}",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => onEdit(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: () => onDelete(index),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                if (seasonList.isNotEmpty)
                  CustomOutlinedButton(
                    onPressed: uploadSeasons,
                    buttonText: "Upload",
                  ),
                heightBox20(),
                backButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

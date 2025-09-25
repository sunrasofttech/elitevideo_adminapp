import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:elite_admin/bloc/rental/delete_rentals/delete_rentals_cubit.dart';
import 'package:elite_admin/bloc/rental/get_rentals/get_rentals_cubit.dart';
import 'package:elite_admin/bloc/rental/get_rentals/get_rentals_model.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/constant/image.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custom_empty_widget.dart';
import 'package:elite_admin/utils/widget/custom_error_widget.dart';
import 'package:elite_admin/utils/widget/customcircularprogressbar.dart';
import 'package:elite_admin/utils/widget/delete_dialog.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

final List<String> rentalTypes = ['movie', 'shortfilm', 'series'];

class RentalScreen extends StatefulWidget {
  const RentalScreen({super.key});

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> with SingleTickerProviderStateMixin, Utility {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<GetRentalsCubit>().getRentals(type: rentalTypes[0]);
    _tabController = TabController(length: rentalTypes.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging == false) {
        final selectedType = rentalTypes[_tabController.index];
        context.read<GetRentalsCubit>().getRentals(type: selectedType);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGreyColor,
        title: const TextWidget(
          text: "Rental",
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Movie'),
            Tab(text: 'ShortFilm'),
            Tab(text: 'WebSeries'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: rentalTypes.map((type) {
          return _RentalTabView(type: type);
        }).toList(),
      ),
    );
  }
}

class _RentalTabView extends StatelessWidget with Utility {
  final String type;
  const _RentalTabView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteRentalsCubit, DeleteRentalsState>(
      listener: (context, state) {
        if (state is DeleteRentalsloadedState) {
          Fluttertoast.showToast(msg: "Delete Sucessfully");
          context.read<GetRentalsCubit>().getRentals(type: type);
          Navigator.pop(context);
        }

        if (state is DeleteRentalsErrorState) {
          Fluttertoast.showToast(msg: state.error);
          return;
        }
      },
      child: BlocBuilder<GetRentalsCubit, GetRentalsState>(
        builder: (context, state) {
          if (state is GetRentalsLoadingState) {
            return const Center(child: CustomCircularProgressIndicator());
          }

          if (state is GetRentalsErrorState) {
            return const Center(child: CustomErrorWidget());
          }

          if (state is GetRentalsLoadedState) {
            final rentals = state.model.data?.rentals ?? [];

            if (rentals.isEmpty) return const CustomEmptyWidget();

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                switch (type) {
                  case "movie":
                    return _movieCard(rental, context);
                  case "shortfilm":
                    return _shortFilmCard(rental, context);
                  case "series":
                    return _seriesCard(rental, context);
                  default:
                    return const SizedBox();
                }
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _movieCard(Rental rental, BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: "User Name : ${rental.user?.name}",
                ),
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
                            context.read<DeleteRentalsCubit>().deleteRentals(rental.id ?? "");
                          },
                        );
                      },
                    );
                  },
                  child: svgAsset(
                    assetName: AppImages.deleteSvg,
                    height: 32,
                    width: 28,
                  ),
                ),
              ],
            ),
            TextWidget(
              text: "Movie Name : ${rental.movie?.movieName}",
            ),
            TextWidget(
              text: "Cost : ${rental.cost}",
            ),
            TextWidget(
              text: "Expire ON :${formatDate(rental.validityDate.toString())}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _shortFilmCard(Rental rental, BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: "User Name : ${rental.user?.name}",
                ),
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
                            context.read<DeleteRentalsCubit>().deleteRentals(rental.id ?? "");
                          },
                        );
                      },
                    );
                  },
                  child: svgAsset(
                    assetName: AppImages.deleteSvg,
                    height: 32,
                    width: 28,
                  ),
                ),
              ],
            ),
            TextWidget(
              text: "Short Film Name : ${rental.shortfilm?.shortFilmTitle}",
            ),
            TextWidget(
              text: "Cost : ${rental.cost}",
            ),
            TextWidget(
              text: "Expire ON :${formatDate(rental.validityDate.toString())}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _seriesCard(Rental rental, BuildContext context) {
    return Card(
      color: AppColors.whiteColor,
      surfaceTintColor: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: "User Name : ${rental.user?.name}",
                ),
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
                            context.read<DeleteRentalsCubit>().deleteRentals(rental.id ?? "");
                          },
                        );
                      },
                    );
                  },
                  child: svgAsset(
                    assetName: AppImages.deleteSvg,
                    height: 32,
                    width: 28,
                  ),
                ),
              ],
            ),
            TextWidget(
              text: "Series Name : ${rental.series?.seriesName}",
            ),
            TextWidget(
              text: "Cost : ${rental.cost}",
            ),
            TextWidget(
              text: "Expire ON :${formatDate(rental.validityDate.toString())}",
            ),
          ],
        ),
      ),
    );
  }
}

String formatDate(String? rawDate) {
  if (rawDate == null) return "--";
  try {
    DateTime date = DateTime.parse(rawDate);
    return DateFormat('dd-MM-yyyy').format(date);
  } catch (e) {
    return "--";
  }
}

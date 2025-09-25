class Season {
  String seasonName;
  bool status;
  String seriesId;
  String showType;
  String releasedDate;

  Season({
    required this.seasonName,
    required this.status,
    required this.showType,
    required this.seriesId,
    required this.releasedDate,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonName: json['season_name'],
      status: json['status'],
      showType: json['show_type'],
      seriesId: json['series_id'],
      releasedDate: json['released_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season_name': seasonName,
      'status': status,
      "show_type": showType,
      'series_id': seriesId,
      'released_date': releasedDate,
    };
  }
}

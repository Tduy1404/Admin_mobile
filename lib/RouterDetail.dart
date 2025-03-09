class BusRouteDetail {
  final String routeId;
  final String routeName;
  final String inboundDescription;
  final String outboundDescription;

  BusRouteDetail({
    required this.routeId,
    required this.routeName,
    required this.inboundDescription,
    required this.outboundDescription,
  });

  factory BusRouteDetail.fromJson(Map<String, dynamic> json) {
    return BusRouteDetail(
      routeId: json['RouteId'].toString(),
      routeName: json['RouteName'].toString(),
      inboundDescription: json['InBoundDescription'] ?? 'Không có dữ liệu',
      outboundDescription: json['OutBoundDescription'] ?? 'Không có dữ liệu',
    );
  }
}
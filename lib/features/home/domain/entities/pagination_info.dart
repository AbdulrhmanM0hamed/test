class PaginationInfo {
  final int perPage;
  final int to;
  final int total;

  const PaginationInfo({required this.perPage, required this.to, required this.total});

  bool get hasMore => to < total;
}

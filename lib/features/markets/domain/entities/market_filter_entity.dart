class MarketFilterEntity {
  final String category;
  final String sortBy; // 'name', 'price', 'change', 'volume'
  final bool ascending;
  final String searchQuery;

  const MarketFilterEntity({
    required this.category,
    required this.sortBy,
    required this.ascending,
    required this.searchQuery,
  });

  MarketFilterEntity copyWith({
    String? category,
    String? sortBy,
    bool? ascending,
    String? searchQuery,
  }) {
    return MarketFilterEntity(
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

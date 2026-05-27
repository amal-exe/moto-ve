abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Map<String, dynamic>> favoriteItems;

  FavoriteLoaded(this.favoriteItems);
}
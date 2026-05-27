abstract class FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent {
  final Map<String, dynamic> item;

  AddFavoriteEvent(this.item);
}
class RemoveFavoriteEvent extends FavoriteEvent {

  final Map<String, dynamic> item;

  RemoveFavoriteEvent(this.item);
}
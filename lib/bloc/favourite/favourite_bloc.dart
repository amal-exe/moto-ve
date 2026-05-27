import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favourite_event.dart';
import 'favourite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {

  List<Map<String, dynamic>> favoriteItems = [];

  FavoriteBloc() : super(FavoriteInitial()) {

    loadFavorites();

    /// ADD FAVORITE
    on<AddFavoriteEvent>((event, emit) async {

      final exists = favoriteItems.any(
            (item) => item['name'] == event.item['name'],
      );

      if (!exists) {

        favoriteItems.add(event.item);

        await saveFavorites();
      }

      emit(FavoriteLoaded(List.from(favoriteItems)));
    });

    /// REMOVE FAVORITE
    on<RemoveFavoriteEvent>((event, emit) async {

      favoriteItems.removeWhere(
            (item) => item['name'] == event.item['name'],
      );

      await saveFavorites();

      emit(FavoriteLoaded(List.from(favoriteItems)));
    });
  }

  /// SAVE
  Future<void> saveFavorites() async {

    final prefs = await SharedPreferences.getInstance();

    List<String> encoded = favoriteItems
        .map((item) => jsonEncode(item))
        .toList();

    await prefs.setStringList('favorites', encoded);
  }

  /// LOAD
  Future<void> loadFavorites() async {

    final prefs = await SharedPreferences.getInstance();

    List<String>? saved =
    prefs.getStringList('favorites');

    if (saved != null) {

      favoriteItems = saved
          .map((item) => Map<String, dynamic>.from(
        jsonDecode(item),
      ))
          .toList();

      emit(FavoriteLoaded(List.from(favoriteItems)));
    }
  }
}
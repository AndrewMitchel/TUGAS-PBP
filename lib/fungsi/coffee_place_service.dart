import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/coffee_place.dart';

class CoffeePlaceService {
  final SupabaseClient supabase =
      Supabase.instance.client;

  Future<List<CoffeePlace>>
      getCoffeePlaces() async {
    final response = await supabase
        .from('coffee_places')
        .select()
        .order(
          'id',
          ascending: true,
        );

    return (response as List)
        .map(
          (item) => CoffeePlace.fromMap(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}
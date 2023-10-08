import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:live_bresto/data/model/layer.dart';

part 'map_seeds.freezed.dart';
part 'map_seeds.g.dart';

@freezed
class MapSeeds with _$MapSeeds {
  const factory MapSeeds({
    required int width,
    required int height,
    required List<Layer> layers,
  }) = _MapSeeds;

  factory MapSeeds.fromJson(Map<String, dynamic> json) =>
      _$MapSeedsFromJson(json);
}

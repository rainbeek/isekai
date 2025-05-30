import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isekai/data/model/layer.dart';

part 'world_map.freezed.dart';
part 'world_map.g.dart';

@freezed
abstract class WorldMap with _$WorldMap {
  const factory WorldMap({
    required int width,
    required int height,
    required List<Layer> layers,
  }) = _WorldMap;

  factory WorldMap.fromJson(Map<String, dynamic> json) =>
      _$WorldMapFromJson(json);
}

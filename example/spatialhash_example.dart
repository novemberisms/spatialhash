import "dart:math";

import "package:spatialhash/spatialhash.dart";

void main() {
  // create a new spatial hash whose origin is at (0, 0), with 10 x 10 cells.
  // each cell will be 100 x 100 pixels in size. therefore the spatial hash stretches
  // from (0, 0) to (1000, 1000).
  final spatialHash = SpatialHash<String>(10, 10, 100, 100);

  // add an item to the spatial hash with the given bounding box.
  // this item is located at (35, 35) and has dimensions of 100 x 100 pixels
  spatialHash.add("some item", Rectangle(35, 35, 100, 100));

  // add a second item to the spatial hash
}
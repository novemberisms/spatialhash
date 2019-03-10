# SpatialHash
An easy-to-use implementation of a Spatial Hash for Dart.

## Usage

Creating a spatial hash for Entities 10 cells wide and 10 cells tall, where each cell is 100 x 100 pixels.

```dart
import "dart:math";
import "package:spatialhash/spatialhash.dart";

var mySpatialHash = SpatialHash<Entity>(10, 10, 100, 100);
```

Adding an entity to a spatial hash is done with `add`.

```dart
  var entity = Entity();
  mySpatialHash.add(entity, Rectangle(entity.x, entity.y, entity.width, entity.height));
```

To update the position of an entity already in the spatial hash, use `update`.

```dart
  mySpatialHash.update(entity, Rectangle(entity.x, entity.y, entity.width, entity.height));
```

For removing an entity from the spatial hash, use `remove`.

```dart
  mySpatialHash.remove(entity);
```

The main utility of a spatial hash comes from the `near` method. This provides a set of items that
are potentially colliding with the given item.

Sample efficient collision detection. Assume you have an expensive function `isOverlapping` that computes
for pixel-perfect overlap between two entities of arbitrary shape. Instead of comparing each entity's shape
with every other entity's shape, you can narrow down the possible entity's to compare against using a spatial hash.

```dart
/// calls the [entity]'s `onCollide` method for each entity it is in collision with.
void detectCollisions(Entity entity) {
  for (final otherEntity in mySpatialHash.near(entity)) {
    if (isOverlapping(entity.shape, otherEntity.shape)) {
      entity.onCollide(otherEntity);
    }
  }
}
```

See the docs for more details and more methods. Or better yet, take a look at the source code! It's only a single dart file.

# License

This package is licensed under the [MIT License](https://en.wikipedia.org/wiki/MIT_License).

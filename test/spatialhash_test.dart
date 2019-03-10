import 'package:spatialhash/spatialhash.dart';
import 'package:test/test.dart';
import "dart:math";

void main() {
  test("Adding an item to the spatial hash", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    hash.add("first", Rectangle(5, 5, 10, 10));

    expect(hash.cellAt(5, 5).contains("first"), equals(true));
    expect(hash.cellAt(15, 5).contains("first"), equals(true));
    expect(hash.cellAt(25, 5).contains("first"), equals(false));

    expect(hash.cellAt(5, 15).contains("first"), equals(true));
    expect(hash.cellAt(15, 15).contains("first"), equals(true));
    expect(hash.cellAt(25, 15).contains("first"), equals(false));

    expect(hash.cellAt(5, 25).contains("first"), equals(false));
    expect(hash.cellAt(15, 25).contains("first"), equals(false));
    expect(hash.cellAt(25, 25).contains("first"), equals(false));
  });

  test("Adding multiple items to the spatial hash", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    hash.add("first", Rectangle(5, 5, 10, 10));
    hash.add("second", Rectangle(15, 15, 10, 10));

    // check for first
    expect(hash.cellAt(5, 5).contains("first"), equals(true));
    expect(hash.cellAt(15, 5).contains("first"), equals(true));
    expect(hash.cellAt(25, 5).contains("first"), equals(false));

    expect(hash.cellAt(5, 15).contains("first"), equals(true));
    expect(hash.cellAt(15, 15).contains("first"), equals(true));
    expect(hash.cellAt(25, 15).contains("first"), equals(false));

    expect(hash.cellAt(5, 25).contains("first"), equals(false));
    expect(hash.cellAt(15, 25).contains("first"), equals(false));
    expect(hash.cellAt(25, 25).contains("first"), equals(false));

    // check for second
    expect(hash.cellAt(5, 5).contains("second"), equals(false));
    expect(hash.cellAt(15, 5).contains("second"), equals(false));
    expect(hash.cellAt(25, 5).contains("second"), equals(false));

    expect(hash.cellAt(5, 15).contains("second"), equals(false));
    expect(hash.cellAt(15, 15).contains("second"), equals(true));
    expect(hash.cellAt(25, 15).contains("second"), equals(true));

    expect(hash.cellAt(5, 25).contains("second"), equals(false));
    expect(hash.cellAt(15, 25).contains("second"), equals(true));
    expect(hash.cellAt(25, 25).contains("second"), equals(true));
  });

  test("The cellAt() method should only return a copy", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    hash.add("first", Rectangle(5, 5, 10, 10));

    final cell = hash.cellAt(5, 5);
    cell.remove("first");
    cell.add("second");

    expect(hash.cellAt(5, 5).contains("first"), equals(true));
    expect(hash.cellAt(5, 5).contains("second"), equals(false));
  });

  test("Getting the bounding box of a cell", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    expect(hash.cellAt(5, 5,).rect, equals(Rectangle(0, 0, 10, 10)));
    expect(hash.cellAt(15, 5,).rect, equals(Rectangle(10, 0, 10, 10)));
    expect(hash.cellAt(25, 5,).rect, equals(Rectangle(20, 0, 10, 10)));
    expect(hash.cellAt(5, 15,).rect, equals(Rectangle(0, 10, 10, 10)));
    expect(hash.cellAt(15, 15,).rect, equals(Rectangle(10, 10, 10, 10)));
    expect(hash.cellAt(25, 15,).rect, equals(Rectangle(20, 10, 10, 10)));
    expect(hash.cellAt(5, 25,).rect, equals(Rectangle(0, 20, 10, 10)));
    expect(hash.cellAt(15, 25,).rect, equals(Rectangle(10, 20, 10, 10)));
    expect(hash.cellAt(25, 25,).rect, equals(Rectangle(20, 20, 10, 10)));
  });

  test("contains() method", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    expect(hash.contains("first"), equals(false));
    hash.add("first", Rectangle(5, 5, 10, 10));
    expect(hash.contains("first"), equals(true));
    expect(hash.contains("second"), equals(false));
  });

  test("Removing an item", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    hash.add("first", Rectangle(5, 5, 10, 10));

    expect(hash.remove("first"), equals(true));
    expect(hash.remove("second"), equals(false));
    expect(hash.contains("first"), equals(false));
    expect(hash.cellAt(5, 5).contains("first"), equals(false));
    expect(hash.cellAt(15, 5).contains("first"), equals(false));
    expect(hash.cellAt(5, 15).contains("first"), equals(false));
    expect(hash.cellAt(15, 15).contains("first"), equals(false));
  });

  test("clear() method", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    hash.add("first", Rectangle(5, 5, 10, 10));
    hash.add("second", Rectangle(15, 5, 10, 10));
    hash.add("third", Rectangle(5, 15, 10, 10));
    hash.add("fourth", Rectangle(15, 15, 10, 10));

    expect(
        hash.cellAt(15, 15).toSet().containsAll(["first", "second", "third", "fourth"]),
        equals(true));

    hash.clear();

    expect(hash.contains("first"), equals(false));
    expect(hash.contains("second"), equals(false));
    expect(hash.contains("third"), equals(false));
    expect(hash.contains("fourth"), equals(false));
  });

  test("Updating an item in the spatial hash", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);
    void testContents(List shouldContain) {
      var i = 0;
      for (final cell in hash.cellsAt(Rectangle(0, 0, 30, 30))) {
        expect(cell.contains("first"), equals(shouldContain[i]));
        i++;
      }
    }

    hash.add("first", Rectangle(5, 5, 10, 10));
    testContents([true, true, false, true, true, false, false, false, false]);
    hash.update("first", Rectangle(15, 15, 10, 10));
    testContents([false, false, false, false, true, true, false, true, true]);
    hash.update("first", Rectangle(15, 5, 10, 10));
    testContents([false, true, true, false, true, true, false, false, false]);
    hash.update("first", Rectangle(5, 25, 0, 0));
    testContents([false, false, false, false, false, false, true, false, false]);
  });

  test("Iterating over all cells in a rectangular region", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    hash.add("a", Rectangle(5, 5, 0, 0));
    hash.add("b", Rectangle(15, 5, 0, 0));
    hash.add("c", Rectangle(25, 5, 0, 0));
    hash.add("d", Rectangle(5, 15, 0, 0));
    hash.add("e", Rectangle(15, 15, 0, 0));
    hash.add("f", Rectangle(25, 15, 0, 0));
    hash.add("g", Rectangle(5, 25, 0, 0));
    hash.add("h", Rectangle(15, 25, 0, 0));
    hash.add("i", Rectangle(25, 25, 0, 0));

    var i = 0;
    var expected = ["a", "b", "d", "e"];

    for (final cell in hash.cellsAt(Rectangle(0, 0, 19, 19))) {
      expect(cell.first, equals(expected[i]));
      i++;
    }

    i = 0;
    expected = ["a", "b", "c", "d", "e", "f", "g", "h", "i"];
    for (final cell in hash.cellsAt(Rectangle(0, 0, 30, 30))) {
      expect(cell.first, equals(expected[i]));
      i++;
    }

    i = 0;
    expected = ["e", "f", "h", "i"];
    for (final cell in hash.cellsAt(Rectangle(15, 15, 25, 25))) {
      expect(cell.first, equals(expected[i]));
      i++;
    }
  });

  test("sample collision detection using near()", () {
    final hash = SpatialHash<String>(3, 3, 10, 10);

    hash.add("player", Rectangle(5, 5, 10, 10));

    hash.add("a", Rectangle(5, 5, 0, 0));
    hash.add("b", Rectangle(15, 5, 0, 0));
    hash.add("c", Rectangle(25, 5, 0, 0));
    hash.add("d", Rectangle(5, 15, 0, 0));
    hash.add("e", Rectangle(15, 15, 0, 0));
    hash.add("f", Rectangle(25, 15, 0, 0));
    hash.add("g", Rectangle(5, 25, 0, 0));
    hash.add("h", Rectangle(15, 25, 0, 0));
    hash.add("i", Rectangle(25, 25, 0, 0));

    var expected = Set.from(["a", "b", "d", "e"]);
    var shouldNotAppear = Set.from(["c", "f", "g", "h", "i"]);

    for (final item in hash.near("player")) {
      expect(expected.contains(item), equals(true));
      expect(shouldNotAppear.contains(item), equals(false));
    }
  });
}

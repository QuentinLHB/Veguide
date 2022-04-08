/// Class used to store data used by the [Leaves] widget.
class LeavesController{
  int leafLevel = 3;

  /// Creates a controller used by the [Leaves] widget.
  /// The [leafLevel] argument sets the initial value of the [Leaves] object, and
  /// must be between 1 and 3.
  LeavesController({int leafLevel=3}){
    assert(leafLevel > 0 && leafLevel <= 3);
    this.leafLevel = leafLevel;
  }
}
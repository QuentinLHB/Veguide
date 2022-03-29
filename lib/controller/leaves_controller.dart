class LeavesController{
  int leafLevel = 3;
  bool clickable = false;

  LeavesController({int? leafLevel=3, bool? clickable=false}){
    this.leafLevel = leafLevel ?? 3;
    this.clickable = clickable ?? false;
  }
}
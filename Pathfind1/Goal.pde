
class Goal
{
  Cell position; 
  
  public Goal(CellGrid world)
  {
    position = world.cellAtPixels(width - 50, height / 2);
  }
}

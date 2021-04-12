
class Goal
{
  Cell position; 
  
  public Goal(CellGrid world)
  {
    position = world.cellAtPixels(700, 300);
  }
}

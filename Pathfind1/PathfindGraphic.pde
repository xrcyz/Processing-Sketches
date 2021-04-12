
class PathfindGraphic
{
  PGraphics pg;
  CellGrid cells;
  Agent agent;
  Goal goal;
  ArrayList<Cell> path;
  
  public PathfindGraphic(CellGrid cells, Agent agent, Goal goal)
  {
    this.cells = cells; 
    this.agent = agent; 
    this.goal = goal; 
    path = agent.getPath();
    
    pg = createGraphics(width, height);
    
    pg.beginDraw();
    pg.colorMode(HSB, 1, 1, 1, 1); 
    pg.endDraw(); 
  }
  
  int frame = 0;
  
  void draw()
  {
    
    if(mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height)
    {
      goal.position = cells.cellAtPixels(mouseX, mouseY); 
    }
    
    
    for(Cell cell : cells.cells)
    {
      cell.updateCost();
    }
    
    if(frame > 10)
    {
      path = agent.getPath();
      frame = 0;
    }
    frame++;
    
    pg.beginDraw();
    pg.clear();
    //pg.stroke(0, 0, 0.9);
    pg.noStroke();
    for(int i = 0; i < cells.countCellsX; i++)
    {
      for(int j = 0; j < cells.countCellsY; j++)
      {
        Cell cell = cells.getCell(i, j); 
        if(cell.Equals(agent.position))
        {
          pg.fill(0, 0.5, 0.8);
        }
        else if(cell.Equals(goal.position))
        {
          pg.fill(0.6, 0.5, 0.8);
        }
        else if(path.contains(cell))
        {
          pg.fill(0.3, 0.0, 0.8);
        }
        else
        {
          float h = (map(cell.interestingValue, 0, 100, 0.7, 0)+1)%1;
          float b = (map(cell.arrivalCost, 1, 0, 0.0, 0.7));
          float s = cell.interestingValue < 0 ? 0 : 0.5;
          pg.fill(h, s, b);    
          
        }
        
        pg.rect(i * cells.cellSize, j * cells.cellSize, cells.cellSize, cells.cellSize); 
      }
    }
    
    pg.endDraw(); 
    
    image(pg, 0, 0); 
  }
}

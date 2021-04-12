
class Cell
{
  int X;
  int Y;
  float arrivalCost; 
  float interestingValue = -99;
  
  float noise_s = 0.11f;
  float noise_o = 500f;
  float noise_z = 0f;
  
  public Cell(int x, int y)
  {
    X = x;
    Y = y;
    
    updateCost();
  }
  
  boolean Equals(Cell other)
  {
    return X == other.X && Y == other.Y;
  }
  
  void updateCost()
  {
    noise_z += 0.004;
    arrivalCost =  noise(X * noise_s + noise_o, Y * noise_s + noise_o, noise_z);
    arrivalCost = arrivalCost * arrivalCost;
  }
}

class CellGrid
{
  Cell[] cells;
  int cellSize = 5;
  int countCellsX;
  int countCellsY;
  
  public CellGrid(int pixelsX, int pixelsY)
  {
    countCellsX = pixelsX / cellSize; 
    countCellsY = pixelsY / cellSize;
    cells = new Cell[countCellsX * countCellsY];
    for(int i = 0; i < countCellsX; i++)
    {
      for(int j = 0; j < countCellsY; j++)
      {
        cells[getIndex(i,j)] = new Cell(i, j); 
      }
    }
  }
  
  int getIndex(int x, int y)
  {
    int i = countCellsX * y + x;
    return i;
  }
  
  PVector getXY(int index)
  {
    int x = index % countCellsX;
    int y = floor(index / countCellsX);
    return new PVector(x, y);
  }
  
  Cell getCell(int x, int y)
  {
    return cells[countCellsX * y + x];
  }
  
  ArrayList<Cell> getNeighbors(Cell cell)
  {
    ArrayList<Cell> result = new ArrayList<Cell>(); 
    
    for(int i = max(0, cell.X - 1); i < min(countCellsX, cell.X + 2); i++) //<>//
    {
      for(int j = max(0, cell.Y - 1); j < min(countCellsY, cell.Y + 2); j++)
      {
        if(i == cell.X && j == cell.Y) { }
        else
        {
          Cell c = cells[getIndex(i,j)];
          result.add(c);
        }
      }
    }
    
    return result;
  }
  
  Cell cellAtPixels(float x, float y)
  {
    int i = floor(x / cellSize); 
    int j = floor(y / cellSize);
    return getCell(i, j);
  }
  
  Cell getRandomPosition()
  {
    int x = (int)(random(0, countCellsX)); 
    int y = (int)(random(0, countCellsY));
    return getCell(x, y); 
  }
  
}

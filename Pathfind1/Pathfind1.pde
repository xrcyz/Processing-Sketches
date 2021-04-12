//Implementation of [pathfinding tutorial](https://www.redblobgames.com/pathfinding/a-star/introduction.html)

CellGrid world;
Agent agent;
Goal goal; 
PathfindGraphic pf;

void setup()
{
  size(200, 200); 
  colorMode(HSB, 1, 1, 1, 1); 
  
  world = new CellGrid(width, height);
  goal = new Goal(world);
  agent = new Agent(world, goal);
  pf = new PathfindGraphic(world, agent, goal);
  
}

void draw()
{
  background(47f/360f, 0.05, 1);
  pf.draw();
  
  fill(0, 0, 1);
  text(frameRate, 10, 20); 
}

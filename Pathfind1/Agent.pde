import java.util.HashMap;
import java.util.Comparator;
import java.util.PriorityQueue;

class AgentStep
{
  Cell position;
  float costToReach; 
  
  AgentStep(Cell p, float f)
  {
    position = p; 
    costToReach =f; 
  }
}

class Agent
{
  CellGrid world;
  Goal goal;
  Cell position; 
  
  PriorityQueue<AgentStep> frontier; //sorts the frontier least cost position
  HashMap<Cell, Cell> came_from;
  HashMap<Cell, Float> cost_so_far;
  
  Agent(CellGrid world, Goal goal)
  {
    this.world = world;
    this.goal = goal; 
    position = world.cellAtPixels(100, 300); 
    
    frontier = new PriorityQueue<AgentStep>(5, new Comparator<AgentStep>()
    {
      public int compare(AgentStep a, AgentStep b) { return (int)(a.costToReach - b.costToReach); }  
    }); 
    
    came_from = new HashMap<Cell, Cell>();
    cost_so_far = new HashMap<Cell, Float>();
  }
  
  float movementCost(Cell src, Cell dest)
  {
    //float dist = sqrt(sq(src.X - dest.X) + sq(src.Y - dest.Y));
    //float cost = dest.arrivalCost * dist;
    
    return 5 * dest.arrivalCost * sqrt(sq(src.X - dest.X) + sq(src.Y - dest.Y)); //cost;
  }
  
  float manhattanDistance(Cell src, Cell dest)
  {
    return 0.001 * abs(src.X - dest.X) + abs(src.Y - dest.Y);
  }
  
  public ArrayList<Cell> getPath()
  {
    //visualisation
    for(Cell cell : world.cells)
    {
      cell.interestingValue = -99;
    }
    
    //search 
    frontier.clear();
    came_from.clear();
    cost_so_far.clear();
    
    frontier.add(new AgentStep(position, 0f)); 
    came_from.put(position, null);
    cost_so_far.put(position, 0f); 
    
    while(frontier.size() > 0)
    {
      Cell current = frontier.poll().position;
      if(current.Equals(goal.position)) break;
      
      ArrayList<Cell> neighbors = world.getNeighbors(current);
      for(Cell neighbor : neighbors)
      {
        float new_cost = cost_so_far.get(current) + movementCost(current, neighbor);
        
        if(!came_from.containsKey(neighbor) || new_cost < cost_so_far.get(neighbor))
        {
          neighbor.interestingValue = new_cost;
          cost_so_far.put(neighbor, new_cost);
          came_from.put(neighbor, current);
          
          float priority = new_cost + manhattanDistance(neighbor, goal.position);
          frontier.add(new AgentStep(neighbor, priority));
        }
      }
      
      frontier.remove(0); 
    }
    
    //return path
    Cell step = goal.position; 
    ArrayList<Cell> path = new ArrayList<Cell>(); 
    while(!step.Equals(this.position))
    {
      path.add(step);
      step = came_from.get(step); 
      if(step == position)
      {
        break;
      }
    }
    
    return path; 
  }
  
}

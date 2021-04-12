
Table csv;
Point[] tradingData;
int tradesToShow = 50*5; 
float rangeToShow = 20; 
float tradingDay;

LineChart chart;

float cash = 10000;

void setup()
{
  size(800, 600); 
  
  tradingDay = random(25*5, 200*5);
  
  csv = loadTable("CBA.csv", "header");
  
  tradingData = new Point[csv.getRowCount()];
  
  int i = 0;
  for(TableRow row : csv.rows())
  {
    float open = row.getFloat("Open"); 
    
    if(!Float.isNaN(open))
    {
      tradingData[i] = new Point(i, open);      
      i++;
    }
    
  }
  
  chart = new LineChart(800, 550);
  chart.refresh(tradingData);
  
}

void draw()
{
  background(255);
  
  chart.refresh(tradingDay, tradesToShow, rangeToShow); 
  chart.draw(0, 25); 
  
  //to do
  //add grid lines / axis markers
  //add volume bar chart
  
  if(tradingDay < tradingData.length - 1) 
  {
    tradingDay+=0.5;
  }
  
  fill(255, 255, 0);
  text("Your score: $" + nf(cash, 0, 1), 20, 60);
  float years = tradingDay / (52*5);
  float n = max(1, tradingDay / (52*5));
  float ratio = pow(cash / 10000f, 1f / n); 
  text("Average returns: " + ratio, 20, 80);
  text("Can you beat 4%?", 20, 100);
}

boolean play = true;

void keyPressed()
{
  if(play) 
  { 
    play = false; noLoop(); 
  }
  else 
  {
    play = true; loop();
  }
}

void mousePressed()
{
  chart.leftMousePressed();
}

void mouseReleased()
{
  chart.leftMouseReleased();
}

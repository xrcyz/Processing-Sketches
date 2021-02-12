
class PolarPlot
{
  PGraphics pgBackground;
  PGraphics pgPlot; 
  int w, h;
  
  Point[] data; 
  float xMin, xMax, yMin, yMax;
  
  public PolarPlot(int w, int h)
  {
    this.w = w;
    this.h = h;
    pgBackground = createGraphics(w, h);
    pgPlot = createGraphics(w, h);
  }
  
  public void refresh(Point[] data, float freq)
  {
    this.data = data;
    setDefaultDataExtents();
    setChartAxis();
    setChartPlot(freq);
  }
  
  public void refresh(float freq)
  {
    setChartPlot(freq);
  }
  
  void setDefaultDataExtents()
  {
    float max = 0; 
    
    for(int i = 0; i < data.length; i++)
    {
      max = max(max, data[i].y);
    }
    
    println(max);
    xMin = yMin = -max;
    xMax = yMax = max;
  }
  
  void setChartAxis()
  {
    float xAxisPosition = h - (0 - yMin)/(yMax - yMin)*h; //invert y-axis
    float yAxisPosition = (0 - xMin)/(xMax - xMin)*w;
        
    //graphics
    pgBackground.beginDraw();
    pgBackground.clear();
    pgBackground.fill(240);
    pgBackground.noStroke();
    pgBackground.rect(0, 0, w-1, h-1); //bounding box
    pgBackground.stroke(0);
    pgBackground.strokeWeight(1); 
    pgBackground.line(0, xAxisPosition, w, xAxisPosition); //x-axis
    pgBackground.line(yAxisPosition, 0, yAxisPosition, h); //y-axis
    pgBackground.endDraw(); 
  }
  
  PVector cm = new PVector(0, 0); 
  
  void setChartPlot(float freq)
  {
    pgPlot.beginDraw();
    pgPlot.clear();
    pgPlot.noFill();
    pgPlot.strokeWeight(2);
    pgPlot.stroke(100, 100, 240, 200); 
    pgPlot.beginShape();
    
    PVector r = new PVector(0, 0);
    cm = new PVector(0, 0); 
    
    for(int i = 0; i < data.length; i++)
    {
      //raw data point
      float x = data[i].x;
      float y = data[i].y;
      
      //transform to polar coordinates
      r.x = 0;
      r.y = y;
      r.rotate(x*freq);
      
      //update the center of mass
      cm.add(r);
      
      //map point to draw coordinates
      r.x = map(r.x, xMin, xMax, 0, w);
      r.y = map(r.y, yMin, yMax, 0, h);
      
      //plot the vertex
      pgPlot.vertex(r.x, r.y); 
    }
    pgPlot.endShape(); 
    
    //draw centroid
    cm.div(data.length);
    pgPlot.stroke(0);
    pgPlot.fill(255, 255, 0);
    pgPlot.ellipse(
      map(cm.x, xMin, xMax, 0, w), 
      map(cm.y, yMin, yMax, 0, h), 
      10, 10); 
    
    pgPlot.endDraw(); 
  }
  
  void draw(float x, float y)
  {
    image(pgBackground, x, y);
    image(pgPlot, x, y); 
    
    if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h)
    {
      //mouse pointer
      fill(0);
      ellipse(mouseX, mouseY, 2, 2);
      
      //coordinate text
      float chartX = map(mouseX, x, x + w, xMin, xMax);
      float chartY = map(mouseY, y, y + h, yMax, yMin); //invert y-axis
      String text = nf(chartX, 0, 2) + ", " + nf(chartY, 0, 2);
      noStroke();
      fill(250, 250, 250, 200);
      rect(mouseX + 5, mouseY - 20, textWidth(text)+5, 12); 
      fill(20); 
      textSize(12);
      
      text(text, mouseX + 6, mouseY - 10);
    }
  }
}

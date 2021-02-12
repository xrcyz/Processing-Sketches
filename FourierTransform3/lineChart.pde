
class Point
{
  float x;
  float y;
  Point(float x_, float y_) { x=x_; y=y_; }
}

class LineChart
{
  PGraphics pgAxis;
  PGraphics pgLine; 
  int w, h;
  
  Point[] data; 
  float xMin, xMax, yMin, yMax;
  
  float lastMouseX = 0;
  
  LineChart(int w, int h)
  {
    this.w = w;
    this.h = h;
    pgAxis = createGraphics(w, h);
    pgLine = createGraphics(w, h);
  }
  
  void refresh(Point[] data)
  {
    this.data = data;
    setDefaultDataExtents();
    setChartAxis();
    setChartLine();
  }
  
  void setDefaultDataExtents()
  {
    //extents
    xMin = data[0].x;
    xMax = data[data.length-1].x;
    yMin = data[0].y;
    yMax = data[0].y;
    for(int i = 0; i < data.length; i++)
    {
      yMin = min(data[i].y, yMin);
      yMax = max(data[i].y, yMax); 
    }
    
    float buffer = 0.05 * (yMax - yMin);
    yMin -= buffer;
    yMax += buffer;
  }
    
  void setChartAxis()
  {
    float xAxisPosition = h - (0 - yMin)/(yMax - yMin)*h; //invert y-axis
    float yAxisPosition = (0 - xMin)/(xMax - xMin)*w;
        
    //graphics
    pgAxis.beginDraw();
    pgAxis.clear();
    pgAxis.fill(240);
    pgAxis.noStroke();
    pgAxis.rect(0, 0, w-1, h-1); //bounding box
    pgAxis.stroke(0);
    pgAxis.strokeWeight(1); 
    pgAxis.line(0, xAxisPosition, w, xAxisPosition); //x-axis
    pgAxis.line(yAxisPosition, 0, yAxisPosition, h); //y-axis
    pgAxis.endDraw(); 
  }
  
  void setChartLine()
  {
    pgLine.beginDraw();
    pgLine.clear();
    pgLine.noFill();
    pgLine.stroke(255, 0, 0); 
    pgLine.beginShape();
    for(int i = 0; i < data.length; i++)
    {
      float x = map(data[i].x, xMin, xMax, 0, pgLine.width); 
      float y = map(data[i].y, yMin, yMax, pgLine.height, 0); //invert y-axis
      pgLine.vertex(x, y); 
    }
    pgLine.endShape(); 
    pgLine.endDraw(); 
  }
  
  void draw(float x, float y)
  {
    image(pgAxis, x, y);
    image(pgLine, x, y); 
    
    if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h)
    {
      lastMouseX = mouseX;
      
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

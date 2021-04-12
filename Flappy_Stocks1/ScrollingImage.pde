
class Point
{
  float x;
  float y;
  Point(float x_, float y_) { x=x_; y=y_; }
}

class Line
{
  PVector start;
  PVector end; 
  color colour = color(0); 
  
  public Line(float x1, float y1, float x2, float y2) 
  {
    start = new PVector(x1, y1);
    end = new PVector(x2, y2); 
  }
}

class LineChart
{
  PGraphics pgBackground;
  PGraphics pgLine; 
  PGraphics pgAnnotations;
  int w, h;
  
  Point[] data; 
  ArrayList<Line> mouseClicks;
  float xMin, xMax, yMin, yMax;
  float xIncrement, yIncrement; 
  
  PVector finalPoint = new PVector(0, 0);
  
  LineChart(int w, int h)
  {
    this.w = w;
    this.h = h;
    pgBackground = createGraphics(w, h);
    pgLine = createGraphics(w, h);
    pgAnnotations = createGraphics(w, h); 
    
    mouseClicks = new ArrayList<Line>(); 
  }
  
  void refresh(Point[] data)
  {
    this.data = data;
    setDefaultDataExtents();
    setBackground();
    setChartLine();
  }
  
  float lastY = -1; 
  
  void refresh(float lastPointX, float dx, float dy)
  {
    
    int prevPoint = floor(lastPointX); 
    int nextPoint = ceil(lastPointX); 
    
    if(nextPoint >= tradingData.length) return; //end of game
    
    xMax = lerp(data[prevPoint].x, data[nextPoint].x, lastPointX - prevPoint);
    xMin = xMax - dx;
    
    if(lastY < 0) 
    {
      lastY = data[prevPoint].y;
    }
    else
    {
      float y = lerp(data[prevPoint].y, data[nextPoint].y, lastPointX - prevPoint);
      lastY += (y - lastY)/20;
      
      //y cannot be greater than yMax, or less than yMin
      if(lastY + dy/2 < y ) y = lastY + dy/2;
      else if(lastY - dy/2 > y) y = lastY - dy/2;
    }
    
    yMax = lastY + dy/2;
    yMin = yMax - dy;
    
    setBackground();
    setChartLine();
    setAnnotations();
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
  
  void setBackground()
  {     
    pgBackground.beginDraw();
    pgBackground.clear();
    pgBackground.fill(20, 20, 40);
    pgBackground.noStroke();
    pgBackground.rect(0, 0, w-1, h-1); //bounding box
    pgBackground.endDraw(); 
  }
  
  void setChartLine()
  {
    pgLine.beginDraw();
    pgLine.clear();
    pgLine.noFill();
    pgLine.strokeWeight(2);
    pgLine.stroke(100, 100, 240); 
    pgLine.beginShape();
    for(int i = 0; i < data.length; i++)
    {
      //to do - bail if data is out of range
      float x = map(data[i].x, xMin, xMax, 0, w); 
      float y = map(data[i].y, yMin, yMax, h, 0); //invert y-axis
      pgLine.vertex(x, y); 
      
      //store the final point for use in buy/sell orders
      if(data[i].x < xMax)
      {
        finalPoint.x = data[i].x;
        finalPoint.y = data[i].y;
      }
    }
    pgLine.endShape(); 
    pgLine.endDraw(); 
  }
  
  void setAnnotations()
  {
    pgAnnotations.beginDraw();
    pgAnnotations.clear();
    pgAnnotations.strokeWeight(3);
    
    for(Line line : mouseClicks) 
    {
      if(line.end.x > xMin && line.start.x < xMax)
      {
        float x1 = map(line.start.x, xMin, xMax, 0, w); 
        float y1 = map(line.start.y, yMin, yMax, h, 0); //invert y-axis
        
        float x2 = map(line.end.x, xMin, xMax, 0, w); 
        float y2 = map(line.end.y, yMin, yMax, h, 0); //invert y-axis
        
        if(y2 < y1) //up is down
        {
          pgAnnotations.stroke(0, 255, 0); 
        }
        else 
        {
          pgAnnotations.stroke(255, 0, 0); 
        }
        
        pgAnnotations.line(x1, y1, x2, y2); 
      }
    }
    
    if(mousePressed)
    {
      float x1 = map(leftMouseDown.x, xMin, xMax, 0, w); 
      float y1 = map(leftMouseDown.y, yMin, yMax, h, 0); //invert y-axis
      
      float x2 = map(finalPoint.x, xMin, xMax, 0, w); 
      float y2 = map(finalPoint.y, yMin, yMax, h, 0); //invert y-axis
      
      if(y2 < y1) //up is down
      {
        pgAnnotations.stroke(0, 255, 0); 
      }
      else 
      {
        pgAnnotations.stroke(255, 0, 0); 
      }
      
      pgAnnotations.line(x1, y1, x2, y2); 
    }
    
    pgAnnotations.endDraw();
  }
  
  void draw(float x, float y)
  {    
    image(pgBackground, x, y);
    image(pgLine, x, y); 
    image(pgAnnotations, x, y);
    
    if(mouseX > x && mouseX < x + pgBackground.width && mouseY > y && mouseY < y + pgBackground.height)
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
  
  PVector leftMouseDown = new PVector(0, 0);
  PVector leftMouseUp = new PVector(0, 0);
    
  void leftMousePressed()
  {
    leftMouseDown.x = finalPoint.x;
    leftMouseDown.y = finalPoint.y; 
  }
  
  void leftMouseReleased()
  {
    leftMouseUp.x = finalPoint.x;
    leftMouseUp.y = finalPoint.y; 
    
    Line line = new Line(leftMouseDown.x, leftMouseDown.y, leftMouseUp.x, leftMouseUp.y); 
    
    mouseClicks.add(line); 
    
    float roi = leftMouseUp.y / leftMouseDown.y;
    println(roi);
    cash = roi * cash; 
  }
}

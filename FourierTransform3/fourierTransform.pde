
import java.util.Comparator;
import java.util.List;
import java.util.Arrays;

class FourierTransform
{
  Point[] waveData;
  LineChart waveChart;
  
  Point[] fourierData;
  LineChart fourierChart;
  
  PolarPlot fourierPlot; 
  
  Point[] reconData;
  LineChart reconChart;
  
  int p = 600; //how many points in line chart
  
  FourierTransform(boolean noisy)
  {
    this.waveData = new Point[p];
    this.fourierData  = new Point[p];
    
    refresh(noisy);
  }
  
  void refresh(boolean noisy)
  {
    //populate wave data
    for(int i = 0; i < p; i++)
    {
      float x = map(i, 0, p, -TWO_PI, 2*TWO_PI)+3;
      float y = 5*sin(3*x)+3*cos(7*x)+cos(17*x)+5;
      float noise = noisy ? (-0.4999999+noise(map(i, 0, p, 0, 100)))*3 : 0;
      waveData[i] = new Point(x, y + noise);
    }
    
    waveChart = new LineChart(700, 180);
    waveChart.refresh(waveData);
    
    //populate fourier data
    int maxFreq = 24;
    for(int i = 0; i < p; i++)
    {
      float freq = map(i, 0, p, -0.5, maxFreq);
      float transform = getFourierTransformAtFrequency(waveData, freq);
      fourierData[i] = new Point(freq, transform);
    }
    
    fourierChart = new LineChart(500, 180);
    fourierChart.refresh(fourierData);
    
    //populate polar plot
    fourierPlot = new PolarPlot(180, 180); 
    fourierPlot.refresh(waveData, 3); 
    
    //populate reconstructed wave data
    /*
        y = 5*sin(3*x)+3*cos(7*x)+cos(17*x)+5;
        This function has peaks at (0, 5), (3, 2.5), (7, 1.5), (17, 0.5)
        The origin is a special case for the constant offset.
        (0, 5) => (+5)
        (3, 2.5) => 5*sin(3*x)
        (7, 1.5) => 3*cos(7*x)
        (17, 0.5) => 1*cos(17*x)
        
        a cos function is just a phase-shifted sin function;
        phase-shifting is denoted by the heading of the polar-plot centroid
    */
    
    //to be continued...
  }
  
  PVector cm = new PVector(0, 0); 
  
  float getFourierTransformAtFrequency(Point[] points, float freq)
  {
    cm.x = 0; //center of mass.x
    cm.y = 0;
    
    //given a frequency, rotate the function in polar coordinates proportionally
    for(int i = 0; i < points.length; i++)
    {
      float x = points[i].x;
      float y = points[i].y;
      
      cm.x += y*cos(x*freq);
      cm.y += y*sin(x*freq);
    }
    
    cm.div(points.length);
    
    //a peak indicates a strong affect
    //the vector heading indicates the frequency's phase shift (sin or cos)
    return cm.mag();
  }
  
  void draw()
  {
    waveChart.draw(50,20);
    fourierChart.draw(50,220);
    fourierPlot.refresh(polarPlotFrequency); //fourierChart.lastMouseX);
    fourierPlot.draw(50 + 500 + (250 - 180 - 25)/2, 220); 
  }
  
}

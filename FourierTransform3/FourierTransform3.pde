//inspirations
// https://www.youtube.com/watch?v=spUNpyF58BY
// https://prajwalsouza.github.io/Experiments/Fourier-Transform-Visualization.html
// https://openprocessing.org/sketch/934352
// https://openprocessing.org/sketch/1052703

FourierTransform ft;
FourierTransform ft_noisy;

float polarPlotFrequency = 0;

void setup()
{
  size(800, 600); 
  
  boolean noisy;
  ft = new FourierTransform(noisy=false);
  ft_noisy = new FourierTransform(noisy=true);
}

boolean showNoise = false;

void draw()
{
  background(255);
  
  if(showNoise)
  {
    ft_noisy.draw();
  }
  else
  {
    ft.draw();
  }
  
  //update polar plot
  polarPlotFrequency += (ft.fourierPlot.cm.mag() < 1 ? 0.005 : 0.002);
  if(polarPlotFrequency > 8)//ft.fourierChart.xMax)
  {
    polarPlotFrequency = 0;
  }
  stroke(0, 0, 255);
  line(
    map(polarPlotFrequency, ft.fourierChart.xMin, ft.fourierChart.xMax, 50, 550),
    220,
    map(polarPlotFrequency, ft.fourierChart.xMin, ft.fourierChart.xMax, 50, 550),
    220 + ft.fourierChart.h
    );
}

void mouseReleased()
{
  showNoise = !showNoise;
}

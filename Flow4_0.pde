import processing.video.*;
import processing.serial.*;

Capture video;
CaptureSystem CV;
TerrainHandler TH;
BallSystem BS;
VehicleSystem VS;

Boolean[] SW = new Boolean[10]; 
PImage a;

void setup()
{
  fullScreen();
  //port = new Serial(this, Serial.list()[0], 9600);
  frameRate(60);

  video = new Capture(this, 1280, 1024, 5);

  CV = new CaptureSystem(video);
  video.start();

  SW[0] = false;
  SW[1] = true;
  SW[2] = false;
  SW[3] = false;
}




void draw()
{

  background(240, 248, 255); 




  if (!CV.hasDone)
  {
    if (video.available())
      video.read();

    CV.calculate();
  }

  if (SW[3])
  {
    if (video.available())
      video.read();
    CV.calculateSuper();

    TH = new TerrainHandler(CV.obstacles, CV.start, CV.end);
    TH.update();
    VS = new VehicleSystem(TH.getPathFinder(), TH.getObstaclePath());
    BS = new BallSystem(TH.getPathFinder(), TH.getObstaclePath());

    SW[3] = false;
  }
  // if(CV.hasDone)
  //image(video, 0, 0, width, height);

  if (CV.hasDone && SW[1])
  {  

    TH = new TerrainHandler(CV.obstacles, CV.start, CV.end);
    TH.update();
    VS = new VehicleSystem(TH.getPathFinder(), TH.getObstaclePath());
    BS = new BallSystem(TH.getPathFinder(), TH.getObstaclePath());

    SW[0] = true;
    if (TH.hasDone)
      SW[1] = false;
  }

  if (SW[0])
  {

    TH.displayTerrain();
    BS.runBalls();
  }

  if (keyPressed)
  {
    if (key == 'o')
      SW[3] = true;
  }


  //if(port.available() > 0)
  //{

  // data = port.read();
  // println(data);
  //}
}
class CaptureSystem
{
  // Başlangıç ve bitiş noktasıyla engeller sistemi
  ArrayList<Blob> obstacles;
  ArrayList<Blob> start;
  ArrayList<Blob> end;


  Capture video;

  ComputerVision obs;
  ComputerVision str;
  ComputerVision en;

  boolean hasDone;

  CaptureSystem(Capture video)
  {
    this.video = video;
    obs = new ComputerVision(this.video);
    str = new ComputerVision(this.video);
    en = new ComputerVision(this.video);
    hasDone = false;

    obs.col = color(30);
    str.col = color(173, 255, 47);
    en.col = color(220, 20, 60);
    str.isEllipse = true;
    en.isEllipse = true;
  }


  void calculate()
  {
    if (!obs.hasDone)
    {
      obs.runEverything();
    } else if (!str.hasDone) 
    {

      str.runEverything();
    } else if (!en.hasDone)
    {

      en.runEverything();
    } else
    {
      obstacles = obs.blobs;
      start = str.blobs;
      end = en.blobs;
      hasDone = true;
    }
  }
  
  void calculateSuper()
  {
   obs.justCalculate();
   str.justCalculate();
   en.justCalculate();
   obstacles = obs.blobs;
   start = str.blobs;
   end = en.blobs;
    
  }
}
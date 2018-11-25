class VehicleSystem
{
  ArrayList<Vehicle> vehicles;
  PVector start;
  PVector end;
  ArrayList<PVector> points;
  ObstaclePath obsPath;
  float sepForce;
  float sepDist;
  int mouseRate;
  PathDisplay pathDis;

  VehicleSystem(PathFinder walkPath, ObstaclePath obsPath)
  {
    this.start = walkPath.getPointsSimplified().get(0);
    this.pathDis = new PathDisplay(walkPath.getPointsSimplified());
    this.end = walkPath.getPointsSimplified().get(walkPath.getPointsSimplified().size()-1);
    this.points = walkPath.getPointsSimplified();
    this.obsPath = obsPath;
    vehicles = new ArrayList<Vehicle>(); 
    mouseRate = 0;
    sepForce = 3;
    sepDist = 20;
  }


  void runVehicles()
  {
    //pathDis.displayRoad();
    vehicleUpdate();
    removeStuck();
    hasReached();


    if (mousePressed)
    {
      if (mouseRate % 6 == 0)
        vehicles.add(new Vehicle(constrain(mouseX, 5, width-5), constrain(mouseY, 5, height-5)));

      mouseRate++;
    }
  }

  void hasReached()
  {
    for (int i = vehicles.size()-1; i >= 0; i--)
    {
      if (vehicles.get(i).hasReached)
        vehicles.remove(i);
    }
  }


  void removeStuck()
  {
    for (int i = vehicles.size()-1; i >= 0; i--)
    {
      if (vehicles.get(i).lifespan <=0)
        vehicles.remove(i);
    }
  }

  void vehicleUpdate()
  {
    if (frameCount % 20 == 1)
    {
      vehicles.add(new Vehicle(start.x, start.y));
    }

    if (vehicles.size() > 0)
    {
      for (Vehicle a : vehicles)
      {
        a.update();
        a.display();
        a.followPoints(points);
        a.obstacleCheck(obsPath);
        a.separate(vehicles, sepDist, sepForce);
      }
    }
  }
}
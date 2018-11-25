class TerrainHandler
{
  ArrayList<Blob> obstacles; 
  ArrayList<Blob> starts;
  ArrayList<Blob> ends;

  boolean hasDone;
  boolean AStar;

  ObstacleSystem obsSystem;
  ObstaclePath obsPath;
  AStar astar;
  PathFinder pathF;
  PathDisplay pathD;

  TerrainHandler(ArrayList<Blob> obstacles, ArrayList<Blob> starts, ArrayList<Blob> ends)
  {
    this.obstacles = obstacles;
    this.starts = starts;
    this.ends = ends;

    AStar = true;
    hasDone = false;
    obsSystem = new ObstacleSystem();
    obsPath = new ObstaclePath();
  }

  void update()
  {
    createObstacleSystem();
    createObstacleTerrain();
    //if (AStar)
    //{
    createAStar();
    //AStar = false;
    //}
    calculateAStar();
    createPathFinder();
    createPathDisplayLess();
    
    hasDone = true;
  }


  void createObstacleSystem()
  {
    for (Blob i : obstacles)
    {
      obsSystem.addObstacle(new Obstacle(i.x1, i.y1, i.x2, i.y2));
    }
  }

  void createObstacleTerrain()
  {
    obsPath.calculateTerrain(obsSystem);
  }

  void createAStar()
  {
    astar = new AStar(new PVector(starts.get(0).x, starts.get(0).y), new PVector(ends.get(0).x, ends.get(0).y), obsPath);
  }

  void calculateAStar()
  {
    astar.calculate();
  }

  PathFinder getPathFinder()
  {
    return pathF;
  }

  ObstaclePath getObstaclePath()
  {
    return obsPath;
  }

  void createPathFinder()
  {
    pathF = new PathFinder(astar.path);
  }

  ArrayList<PVector> getSimplified()
  {
    return pathF.getPointsSimplified();
  }

  ArrayList<PVector> getPoints()
  {
    return pathF.getPoints();
  }

  ArrayList<PVector> getLess()
  {
    return pathF.getPointsLess();
  }



  void createPathDisplayLess()
  {
    pathD = new PathDisplay(getLess());
  }

  void displayTerrain()
  {
    pathD.displayRoad();
    obsSystem.displayObstacles();
  }
}
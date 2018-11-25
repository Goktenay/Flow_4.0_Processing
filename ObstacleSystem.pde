// Engellerin listesini tutan class


class ObstacleSystem
{
  ArrayList<Obstacle> OSystem;

  ObstacleSystem()
  {
    OSystem = new ArrayList<Obstacle>();
  }

  void addObstacle(Obstacle i)
  {
    OSystem.add(i);
  }

  void removeObstacle(Obstacle i)
  {
    OSystem.remove(i);
  }


  void displayObstacles()
  {
    for (Obstacle a : OSystem)
    {
      a.display();
    }
  }
}
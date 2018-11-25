class BallSystem
{
  ArrayList<Ball> balls;
  PVector start;
  PVector end;
  ArrayList<PVector> points;
  PathDisplay pathDis;
  ObstaclePath obsPath;

  boolean T1 = true, T2 = true, T3 = true, T4 = true, T5 = true;
  boolean hasDone;


  int mouseRate;
  BallSystem(PathFinder walkPath, ObstaclePath obsPath)
  {
    this.pathDis = new PathDisplay(walkPath.getPointsLess());
    this.start = walkPath.getPointsLess().get(0);
    this.end = walkPath.getPointsLess().get(walkPath.getPointsLess().size()-1);
    this.points = walkPath.getPointsLess();
    this.obsPath = obsPath;
    balls = new ArrayList<Ball>(); 
    mouseRate = 0;
  }


  void runBalls()
  {
    pathDis.displayRoad();
    if (frameCount % 30 == 1)
    {
      balls.add(new Ball(start.x, start.y));
    }


    this.keyPressed();

    updateBalls();
    hasReached();


    if (mousePressed)
    {
      if (mouseRate % 6 == 0)
        balls.add(new Ball(constrain(mouseX, 5, width-5), constrain(mouseY, 5, height-5)));

      mouseRate++;
    }
  }

  void updateBalls()
  { 
    if (balls.size() > 0)
    {
      for (Ball a : balls)
      {
        if (T1)
          a.update();
        a.display();
        if (T2)
          a.followPoints(points);
        a.edgeDetection();
        if (T3)
          a.collisionDetection(obsPath.pureTerrain);
        if (T4)
          a.collisionWithBalls(balls);
        if (!T5)
          a.applyGravity();
      }
    }


    // top listesi çok dolduysa ilk topu listeden kaldır
    if (balls.size() > 150)
    {
      balls.remove(0);
    }

    // topun yaşam süresi bitmişse listeden kaldır
    for (int i = balls.size()-1; i >= 0; i--)
    {
      if (balls.get(i).isDead)
        balls.remove(i);
    }
  }



  void hasReached()
  {
    for (int i = balls.size()-1; i >= 0; i--)
    {
      if (balls.get(i).hasReached)
        balls.remove(i);
    }
  }


  void keyPressed()
  {
    if (key == 'z')
      T1 = !T1;
    else if (key == 'x')
      T2 = !T2;
    else if (key == 'c')
      T3 = !T3;
    else if (key == 'v')
      T4 = !T4;
    else if (key == 'b')
      T5 = !T5;
  }
}
class PathDisplay
{
  ArrayList<PVector> pathList;
  float r;

  PathDisplay(ArrayList<PVector> pathList)
  {
    this.pathList = pathList;
    // Kalınlık
    r = 20;
  }

  void display()
  {
    for (int i = 0; i < pathList.size()-1; i++)
    {
      line(pathList.get(i).x, pathList.get(i).y, pathList.get(i+1).x, pathList.get(i+1).y);
    }
  }

  void displayRoad()
  {
    strokeJoin(ROUND);
    stroke(175);
    strokeWeight(r*2);
    noFill();
    beginShape();

    for (PVector point : pathList)
    {
      vertex(point.x, point.y);
    }

    endShape();
    stroke(0);
    strokeWeight(1);
    noFill();
    beginShape();
    for (PVector point : pathList)
    {
      vertex(point.x, point.y);
    }
    endShape();
    fill(173, 255, 47);
    ellipse(pathList.get(0).x, pathList.get(0).y, r, r);
    fill(220, 20, 60);
    ellipse(pathList.get(pathList.size()-1).x, pathList.get(pathList.size()-1).y, r, r);
  }
}
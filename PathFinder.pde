// Verilen node'ları PVectore çeviriyor ve nokta sayısını azaltıyor.

class PathFinder
{
  ArrayList<PVector> points= new ArrayList<PVector>();
  ArrayList<PVector> gridLocs = new ArrayList<PVector>();
  ArrayList<PVector> lessPoints = new ArrayList<PVector>();
  int offset =4;


  PathFinder(ArrayList<Node> path)
  {
    // yolun PVector versiyonunu oluştur
    for (int i = path.size()-1; i >= 0; i--)
    {
      points.add(new PVector(path.get(i).x, path.get(i).y )) ;
    }


    // grid location
    for (int i = path.size()-1; i >= 0; i--)
    {
      gridLocs.add(new PVector(path.get(i).j, path.get(i).i )) ;
    }


    // daha az nokta veren fonksiyon

    // ilk point
    lessPoints.add(new PVector(path.get(path.size()-1).x, path.get(path.size()-1).y));

    for (int i = path.size()-2; i >= 1; i--)
    {
      if (i % 20 == 0)
        lessPoints.add(new PVector(path.get(i).x, path.get(i).y )) ;
    }

    // son point
    lessPoints.add(new PVector(path.get(0).x, path.get(0).y));
  }




  ArrayList<PVector> getPoints()
  {
    return points;
  }




  ArrayList<PVector> getPointsSimplified()
  {
    ArrayList<PVector> temp = new ArrayList<PVector>();
    temp.add(points.get(0));


    int count0 = 1;
    int count1 = 1000;
    while (count0 < points.size() - 20)
    {

      while (count1 >= offset*6)
      {

        if ( (gridLocs.get(count0).x + gridLocs.get(count0+offset).x) / 2 == gridLocs.get(count0 + (offset/2)).x  && (gridLocs.get(count0).y + gridLocs.get(count0+offset).y) / 2 == gridLocs.get(count0 + (offset/2)).y)
        {
          temp.add(points.get(count0));
          count1 = 0;
        }
        break;
      }

      count0++;
      count1++;
    }
    temp.add(points.get(points.size()-1));
    return temp;
  }


  ArrayList<PVector> getPointsLess()
  {
    return lessPoints;
  }
}
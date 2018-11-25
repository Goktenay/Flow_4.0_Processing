// Yol bulma algoritması şık gözüksün diye engellerin offset kadar uzağından yol bulmaya başlatıcaz.

class ObstaclePath
{
  // Güzel gözüken yol
  boolean[][] OTerrain;

  // Saf engel yolu (offset etkilemeden)
  boolean[][] pureTerrain;

  // Engellere olan maksimum uzalık
  int offset;

  // Genişlik ve Yükseklik boyutunda bir array oluştur ve her değerine false ata
  ObstaclePath()
  {
    OTerrain = new boolean[width][height];
    pureTerrain = new boolean[width][height];


    //Hepsine false ata
    for (int row = 0; row < OTerrain.length; row++)
    {
      for (int column = 0; column < OTerrain[row].length; column++)
      {
        OTerrain[row][column] = false;
        pureTerrain[row][column] = false;
      }
    }

    offset = 30;
  }




  // Yeni yol arazisini belirle
  void calculateTerrain(ObstacleSystem i)
  {
    for (Obstacle a : i.OSystem)
    {
      // Yol izleme arazisini belirle
      int startX = (int) a.start.x - offset;
      int startY = (int) a.start.y - offset;

      int endX = (int) a.end.x + offset;
      int endY = (int) a.end.y + offset;

      // Arrayi (yani ekran sınırlarını) aşmadığından emin ol
      if (startX < 0)
        startX = 0;

      if (startY < 0)
        startY = 0;

      if (endX >= width)
        endX = width-1;

      if (endY >= height)
        endY = height-1;

      // Obstacle olan yerleri true yap
      for (int row = startX; row <= endX; row++)
      {
        for (int column = startY; column <= endY; column++)
        {
          OTerrain[row][column] = true;
        }
      }
    }

    for (Obstacle a : i.OSystem)
    {

      // Yol izleme arazisini belirle
      int startX = (int) a.start.x;
      int startY = (int) a.start.y;

      int endX = (int) a.end.x;
      int endY = (int) a.end.y;

      // Arrayi (yani ekran sınırlarını) aşmadığından emin ol
      if (startX < 0)
        startX = 0;

      if (startY < 0)
        startY = 0;

      if (endX >= width)
        endX = width-1;

      if (endY >= height)
        endY = height-1;

      // Obstacle olan yerleri true yap
      for (int row = startX; row <= endX; row++)
      {
        for (int column = startY; column <= endY; column++)
        {
          pureTerrain[row][column] = true;
        }
      }
    }
  }
}
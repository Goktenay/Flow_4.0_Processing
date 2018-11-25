class Blob
{
  // Oluşturacağımız kümelerin sol üst (minimum) ve sağ alt (maksimum) x ve y değerleri
  float minX;
  float minY;
  float maxX;
  float maxY;

  float x1;
  float y1;
  float x2;
  float y2; 
  float xR;
    float yR; 
    float r ;
    float x ;
    float y ;

  // Noktaların listesi
  ArrayList<PVector> points;

  Blob(float x, float y)
  {
    // bulduğumuz piksel hem maksimum hem de minumum değerleri taşıyor
    minX = x;
    minY = y;
    maxX = x;
    maxY = y;



    // Listeyi yaratıp içine kordinatları vektör olarak koyuyoruz
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }
   void calculate()
  {
    xR =  (map(maxX, 0, video.width, 0, width) - map(minX, 0, video.width, 0, width)) /2;
    yR =  (map(maxY, 0, video.height, 0, height) - map(minY, 0, video.height, 0, height))/2;
    r = (xR + yR)/2;
    x = r + map(minX, 0, video.width, 0, width);
    y = r + map(minY, 0, video.height, 0, height);
    x1 =  map(minX, 0, video.width, 0, width);
    y1 = map(minY, 0, video.height, 0, height);
    x2 = map(maxX, 0, video.width, 0, width);
    y2 = map(maxY, 0, video.height, 0, height);
  }

  void displayEl(Capture video, color col)
  {
    stroke(1);
    fill(col);
    strokeWeight(2);
    rectMode(CORNERS);
    // ekranda göstermek için map() fonksiyonunu kullanıyorum
    rect(map(minX, 0, video.width, 0, width), map(minY, 0, video.height, 0, height), map(maxX, 0, video.width, 0, width), map(maxY, 0, video.height, 0, height)); 
  }

  void displayCir(Capture video, color col)
  {
    stroke(0);

    strokeWeight(2);
    fill(col);
    ellipse(x, y, r*2, r*2);
  
  }



  void addPoint(float x, float y)
  {
    // Minimum ve maximum (sol üst ve sağ alt) noktaları belirliyoruz
    points.add(new PVector(x, y));
    minX = min(minX, x);
    minY = min(minY, y);
    maxX = max(maxX, x);
    maxY = max(maxY, y);
  }

  float blobSize()
  {
    // hacmini döndürür
    return (maxX - minX) * (maxY - minY);
  }

  boolean isNear(float x, float y, float distBorder)
  {
    // Noktanın kümeye olan uzaklığını ölçüyoruz

    float pX = max(min(x, maxX), minX);
    float pY = max(min(y, maxY), minY);

    // Uzaklığın karekökünü hesaplamaya gerek yok (optimizasyon)
    float d = distSq(pX, pY, x, y);

    // sınırın karesini alıyoruz uzaklığın karekökünü almadığımız için
    if ( d < distBorder * distBorder)
    {
      return true;
    } else
    {
      return false;
    }
  } 



  // Uzaklık formülünün karekökü alınmamış hali (optimizasyon)
  float distSq(float x1, float y1, float x2, float y2) 
  {
    float dist = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
    return dist;
  }
}
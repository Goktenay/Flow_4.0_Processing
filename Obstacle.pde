// Engel objesi yaratır

class Obstacle
{
  // Başlangıç, bitiş ve nesneyi çizmek için başlangıç-bitiş vektörü
  PVector start;
  PVector end;
  PVector rec;

  Obstacle(float x1, float y1, float x2, float y2)
  {
    start = new PVector(x1, y1);
    end = new PVector(x2, y2);
    rec = PVector.sub(end, start);
  }

  // Ekranda göstermek 
  void display()
  {
    fill(30);
    rect(start.x, start.y, end.x, end.y);
  }
}
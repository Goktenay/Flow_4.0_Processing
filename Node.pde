// Griddeki dü

class Node
{
  int x;
  int y;

  // Algoritma değişkenleri
  // h = Minimum uzaklık, tahmini değer
  float h = 0;
  // g = şimdiye kadarkı uzaklık, gerçek değer
  float g = 0;
  // f = toplam tahmini uzaklık, g + h
  float f = 0;

  // Ekranda çizmek için veriler
  int size = AStar.SIZE;


  // Grid boyutu
  int rows = width/size;
  int cols = height/size;

  // Komşu düğümleri tutan liste
  ArrayList<Node> neighbors;

  // Bu düğümün 2 boyutlu listedeki konumu
  int i;
  int j;

  // Önceki düğüm bilgisi
  Node previous = null; 

  // Bu düğüm bir engel mi?
  boolean isObstacle = false;



  Node(int x, int y)
  {
    neighbors = new ArrayList<Node>();
    this.x = x;
    this.y = y;

    j = x/size;
    i = y/size;
  }

  void display(color col)
  {
    strokeWeight(0.1);
    fill(col);
    if (false)
    {
      fill(0);
    }
    rect(x, y, size-1, size-1);
  }

  // Komşu düğümleri eklemek için
  void addNeighbors(Node[][] grid)
  {
    // Liste sınırını aşmadığımızdan emin olmak için
    if (i < cols - 1)
      neighbors.add(grid[i + 1][j]);

    if (j < rows - 1)
      neighbors.add(grid[i][j + 1]);

    if (i > 0)
      neighbors.add(grid[i - 1][j]);

    if (j > 0)
      neighbors.add(grid[i][j - 1]);

    if (j > 0 && i < cols -1 )
      neighbors.add(grid[i+1][j - 1]);

    if (j > 0 && i > 0)
      neighbors.add(grid[i - 1][j - 1]);

    if (j < rows -1 && i > 0 )
      neighbors.add(grid[i - 1][j + 1]);

    if (j < rows -1 && i < cols -1)
      neighbors.add(grid[i + 1][j + 1]);
  }
}
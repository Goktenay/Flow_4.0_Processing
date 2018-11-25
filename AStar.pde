// En kısa yolu bulma algoritması olarak A* kullanıyoruz. 

class AStar
{
  // Sıra ve sütun uzunluğu
  static final int SIZE = 4;

  // 2 Boyutlu düğüm listesi
  Node[][] grid;

  // Açık ve kapalı düğümlerin listesi;
  ArrayList<Node> openList = new ArrayList<Node>();
  ArrayList<Node> closedList = new ArrayList<Node>();

  // En kısa yol bulunduğunda yolun kaydedileceği liste
  ArrayList<Node> path = new ArrayList<Node>();
 

  // Başlangıç ve bitiş düğümleri
  Node start;
  Node end;

  // Düğüm yerleştirirken kullanmak için
  int rows = width/SIZE;
  int cols = height/SIZE;

  AStar(PVector st, PVector en, ObstaclePath terrainMap)
  {
    // Düğüm listesini oluştur
    grid = new Node[cols][rows];

    // Düğüm listesini biçimlendir (Listedeki her konuma bir düğüm ata)
    for (int i = 0; i < grid.length; i++)
    {
      for (int j = 0; j < grid[i].length; j++)
      {
        grid[i][j] = new Node(j*SIZE, i*SIZE);
      }
    }

    // Her düğümün komşu düğümlerini ekle
    for (int i = 0; i < grid.length; i++)
    {
      for (int j = 0; j < grid[i].length; j++)
      {
        grid[i][j].addNeighbors(grid);
      }
    }

    // Duvar olup olmadığını ekle
    for (int i = 0; i < grid.length; i++)
    {
      for (int j = 0; j < grid[i].length; j++)
      {
        if (terrainMap.OTerrain[j*SIZE][i*SIZE]) grid[i][j].isObstacle = true ;
      }
    }

    // Sonra ihtiyacımız olur diye global variable olarak atıyoruz
    start = grid[(int)(st.y/SIZE)][(int)(st.x/SIZE)];
    end = grid[(int)(en.y/SIZE)][(int)(en.x/SIZE)];

    // Algoritma gereği açık düğüm listesine ilk düğümü atıyoruz
    openList.add(this.start);
  }


  void calculate()
  {
    // Deneme
    path.clear();
    closedList.clear();
    openList.add(start);
    
    // Açık düğüm listesi boş değilken..
    while (openList.size() > 0)
    {
      // Açık listedeki en küçük f değerine sahip düğümü bul
      int winner = 0; 
      for (int i = 0; i < openList.size(); i++)
      {
        if (openList.get(i).f < openList.get(winner).f)
        {
          winner = i;
        }
      }

      Node current = openList.get(winner);

      // Eğer en kısa f değerine sahip düğüm bitiş ise çözüm bulunmuştur
      if (current == end)
      {
        // Yolu bul
        Node temp = current;
        path.add(temp);
        while (temp.previous != null)
        {
          path.add(temp.previous);
          temp = temp.previous;
        }
        println("Hesaplandı");
      
        break;
      }

      openList.remove(current);
      closedList.add(current);
      ArrayList<Node> neighbors = current.neighbors;


      // Kontrol ettiğimiz düğümün komşularını getir
      for (int i = 0; i < neighbors.size(); i++)
      {
        Node neighbor =  neighbors.get(i);
        // Geçiçi değer
        float tempG;

        // Eğer komşu düğüm daha önceden değerlendirilmemişse..
        if (!closedList.contains(neighbor) && !neighbor.isObstacle)
        {
          // Komşu düğümün başlangıç düğümüne olan uzaklığını hesapla ve geçiçi değerde tut
          tempG = current.g + SIZE;


          // Yeni yol daha mı iyi?
          boolean newPath = false;

          // Eğer komşu düğüm açık listedeyse 
          if (openList.contains(neighbor))
          {      
            // Eğer yeni bulduğumuz yol daha kısaysa
            if (tempG < neighbor.g)
            {
              // Komşudaki uzun yolu kısa yol ile değiştir
              neighbor.g = tempG;

              // Yeni yol daha kısa
              newPath = true;
            }
          } else // Eğer komşu düğüm açık listede değilse
          {
            neighbor.g = tempG;
            newPath = true;
            openList.add(neighbor);
          }


          if (newPath)
          {
            // Bitişe olan minimum uzaklığı hesapla
            neighbor.h = heuristic(neighbor, end);

            // Başlangıca olan gerçek ve bitişe olan minimum uzaklığı topla
            neighbor.f = neighbor.g + neighbor.h;

            neighbor.previous = current;
          }
        }
      }
    }

    // Eğer açık düğüm listesi boş ise çözüm yok demektir
    if (openList.size() <= 0)
    {
      println("çözüm yok");
      
      return;
    }
  }

  float heuristic(Node neig, Node end)
  {
    return dist(neig.x, neig.y, end.x, end.y);
  }
}
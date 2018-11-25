
class ComputerVision
{
  // video objesi
  Capture video;

  // Karşılaştıracağımız piksel rengi
  color trackCol;


  // Renk Sınırı
  float colBorder;

  // Uzaklık sınırı
  float distBorder;

  // Bulacağımız kümeleri tutan liste
  ArrayList<Blob> blobs = new ArrayList<Blob>();

  // İşimiz bitti mi?
  boolean hasDone;

  // Elips mi?
  boolean isEllipse;

  // Tıkladı mı?
  boolean hasClicked;

  // Küme rengi
  color col;



  ComputerVision(Capture video)
  {
    this.video = video;

    // keyfi değerler
    colBorder = 20;

    distBorder = 50;

    trackCol = color(0); 

    hasDone = false;

    isEllipse = false;

    hasClicked = false;
  }

  void displayVideo()
  {
    // aldığımız görüntüyü ekrana yansıtıyoruz
    image(video, 0, 0, width, height);
  }


  void runEverything()
  {
    displayVideo();
    calculate();
    if (hasClicked)
      {
      calculateBlobs();
      displayBlobs();
      }
    if (keyPressed)
      this.keyPressed();
    if (mousePressed)
      this.mousePressed();
    showText();
  }
  
  void justCalculate()
  {
   calculate();
   calculateBlobs(); 
  }


  void calculate()
  {
    // pixel arrayini çağırmadan önce gerekli;
    video.loadPixels();

    // Her yeni aramada siliyoruz bulduğumuz kümeleri
    blobs.clear();



    // Bütün pikselleri dolaşıp renk uyuşuyor mu (yakın mı) diye kontrol et
    for ( int x = 0; x < video.width; x++)
    {
      for (int y = 0; y < video.height; y++)
      {
        // x ve y'yi tek boyutlu piksel listesine dönüştürüyoruz
        int loc = x + y * video.width;

        // Bu pikseldeki renk ne?
        color currentCol = video.pixels[loc];

        // Pikselin R, G, B değerleri
        float Rc = red(currentCol);
        float Gc = green(currentCol);
        float Bc = blue(currentCol);

        // İstediğimiz rengin R, G, B değerler
        float Rt = red(trackCol);
        float Gt = green(trackCol);
        float Bt = blue(trackCol);

        float dist = distSq(Rc, Gc, Bc, Rt, Gt, Bt);



        // Eğer renk sınırını aşmıyorsa
        if (dist < colBorder * colBorder) 
        {
          // bulundu mu?
          boolean hasFound = false;

          // kümeleri tara
          for (Blob j : blobs)
          {
            // bu nokta kümeye yakın mı?
            if (j.isNear(x, y, distBorder))
            {
              // kümeye yeterince yakınsa kümeye bekle
              j.addPoint(x, y);
              // bulundu
              hasFound = true;
              // diğer kümelere bakmamıza gerek yok
              break;
            }
          }

          // Eğer hiç bir kümeye ait değilse kendisi yeni bir kümedir
          if (!hasFound)
          {

            Blob k = new Blob(x, y);
            blobs.add(k);
          }
        }
      }
    }
  }
  void calculateBlobs()
  {
     for (Blob i : blobs)
    {
     i.calculate();
    }
  }

  void displayBlobs()
  {
    for (Blob i : blobs)
    {
      if (!isEllipse)
        i.displayEl(video, col);
      else
        i.displayCir(video, col);
    }
  }


  void keyPressed() {
    if(!hasDone)
    {
    if (key == 'a') {
      distBorder +=1;
    } else if (key == 'z') {
      if (distBorder - 1 <= 3)
        distBorder = 3;
      else
        distBorder -=1;
    }
    if (key == 's') {
      colBorder +=1;
    } else if (key == 'x') {
      if (colBorder - 1 <= 1)
        colBorder = 1;
      else
        colBorder -= 1;
    }
    if (key == 'n')
    {
      if (hasClicked)
        hasDone = true;
    }
    }
  }

  void mousePressed() {
    // Save color where the mouse is clicked in trackColor variable  
    int loc = (int)map(mouseX, 0, width, 0, video.width) + ((int)map(mouseY, 0, height, 0, video.height)*video.width);
    trackCol = video.pixels[loc];
    hasClicked = true;
  }

  void showText()
  {

    textAlign(RIGHT);
    stroke(255);
    stroke(0);
    strokeWeight(10);
    fill(255);
    textSize(30);
    text("Uzaklık Sınırı: " + distBorder +"  -  " + "Renk Sınırı: " + colBorder, width-11, 29);
    fill(0);
    text("Uzaklık Sınırı: " + distBorder +"  -  " + "Renk Sınırı: " + colBorder, width-10, 30);
  }



  ArrayList<Blob> getBlobs()
  {
    return blobs;
  }

  // 3 boyutlu uzaklık (karekökü alınmadan) formülü
  float distSq(float x1, float y1, float z1, float x2, float y2, float z2)
  {
    float dist = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
    return dist;
  }
}
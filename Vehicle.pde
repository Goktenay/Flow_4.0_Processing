class Vehicle
{
  // Objenin olmazsa olmazı lokasyon, hız ve ivme vektörleri
  PVector location;
  PVector velocity;
  PVector acceleration;

  // Rengi
  color col;

  // yaşam süresi
  float lifespan;
  float fullLifespan;


  // kütle
  float mass;

  // sayaç
  int counter;

  // Hedefe ulaştı mı?
  boolean hasReached;

  // Maksimum kuvvet ve maksimum hız
  float maxForce;
  float maxSpeed;


  // Cisim ile çarpıştı mı?
  boolean collisionCheck;

  // Rastgele başlangıç değerleri
  float aR = 1;
  float vR = 0.2;
  float lR = 40;

  Vehicle (float x, float y)
  {
    // ivme ve hız başlangıçta 0;
    acceleration = new PVector(random(-aR, aR), random(-aR, aR));
    velocity = new PVector(random(-vR, vR), random(-vR, vR));

    location = new PVector(x+random(-lR, lR), y+ random(-lR, lR));

    // Yaşam süresine keyfi değer atıyorum
    lifespan = 300;
    fullLifespan = lifespan;

    col = color(random(255), random(255), random(255));

    mass = 8;
    hasReached = false;
    counter = 1;

    // Çarpışmadı
    collisionCheck = false;
    //ölmüyor



    // Keyfi değerler
    maxSpeed = 5;
    maxForce = 0.4;
  }


  void update()
  {
    if (!collisionCheck)
    {
      // ivme hıza eklenir.
      velocity.add(acceleration);
    }

    // Eğer hız aşılıyorsa maximum hıza indirilir
    velocity.limit(maxSpeed);

    // Eğer bir cisme çarpmıyorsak
    if (!collisionCheck)
    {
      // hız lokasyona eklenir
      location.add(velocity);
    } else
    {
      velocity.div(9);
      lifespan -= 2;
    }

    // fizik kurallarının aşılmaması için
    acceleration.mult(0);
  }

  void applyForce(PVector force)
  {
    // f = m * a; yani kuvvet / kütle bize ivmeyi verir. O değeri de cismin ivmesine ekleriz
    acceleration.add(PVector.div(force, mass));
  }

  void seek(PVector target)
  {
    // Araçtan hedefe olan vektör, arzulanan hız vektörü
    PVector desired = PVector.sub(target, location);

    // Bu vektörü istediğimiz arzulanan hız vektörüne çeviriyoruz (büyüklüğünü maksimum hız büyüklüğüne getiriyoruz)
    desired.setMag(maxSpeed);

    // Steer yani sürüş vektörünü bulabilmek için arzulanan hız vektöründen o anki hız vektörünü çıkartıyoruz
    PVector steer = PVector.sub(desired, velocity);

    // maksimum kuvveti geçmemek için büyüklüğünü limitliyoruz.
    steer.limit(maxForce);

    // Kuvveti uyguluyoruz
    applyForce(steer);
  }

  void display()
  {
    // Üçgen çizdiğimiz için üçgenin sivri ucunu istediğimiz yere getiriyoruz
    float theta = velocity.heading2D() + PI/2;
    fill(col, map(lifespan, 0, fullLifespan, 0, 255 ));
    stroke(0, map(lifespan, 0, fullLifespan, 0, 255 ));
    strokeWeight(1.5);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape();
    vertex(0, -mass/2);
    vertex(-mass, mass*2);
    vertex(mass, mass*2);
    endShape(CLOSE);
    popMatrix();
  }


  void arrive(PVector target)
  {
    // arzulanan hız için yön vektörü
    PVector desired = PVector.sub(target, location);

    // araç ile hedef arasındaki vektörün büyüklüğü
    float d = desired.mag();

    desired.normalize();
    if (d <= 100)
    {
      float m = map(d, 0, 100, 0, maxSpeed);
      desired.mult(m);
    } else
    {
      desired.mult(maxSpeed);
    }

    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void followPoints(ArrayList<PVector> targets)
  {


    // arzulanan hız için yön vektörü
    PVector desired = PVector.sub(targets.get(counter), location);

    // araç ile hedef arasındaki vektörün büyüklüğü
    float d = desired.mag();

    desired.normalize();
    if (d <= 80)
    {
      float m = map(d, 0, 80, 0.5, maxSpeed);
      desired.mult(m);
    } else
    {
      desired.mult(maxSpeed);
    }

    // Hedefe çok yakınsa hedef çok çekiyor
    if (counter == targets.size()-1)
      maxForce = 1;


    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
    applyForce(steer);

    if (counter+1 != targets.size())
    {

      //if(PVector.sub(targets.get(counter), location).mag() < 10) 
      if (PVector.sub(targets.get(counter+1), location).mag() < PVector.sub(targets.get(counter+1), targets.get(counter)).mag())
      {
        counter++;
      }
    } else
    {
      // Hedefe ulaştı
      if (dist(location.x, location.y, targets.get(targets.size()-1).x, targets.get(targets.size()-1).y) < 20)
        hasReached = true;
    }
  }


  // Argüman olarak engellerin kordinatını gösteren ObstaclePath objesini alıyoruz
  void obstacleCheck(ObstaclePath path)
  {
    // Eğer cisim daha önce çarpışmamışsa
    if (!collisionCheck)
    {
      // lokasyonun engelin ütüne denk gelip gelmediğine bak
      if (location.x > 0 && location.x < width && location.y > 0 && location.y < height) 
      {
        if (path.pureTerrain[(int)location.x][(int)location.y])

          // eğer gelmişse collisionCheck'i true yap.
          collisionCheck = true;
      }
    }
  }




  void separate (ArrayList<Vehicle> boids, float dist, float force) {
    float desiredseparation = dist;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // Her ajanı kontrol et ajanlar yakın mı diye
    for (int i = 0; i < boids.size(); i++) {
      Vehicle other = (Vehicle) boids.get(i);
      float d = PVector.dist(location, other.location);
      // Eğer ajan kendin değilsen (uzaklık 0 dan büyükse) ve değer belli bir uzaklıktan küçükse 
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        
        steer.add(diff);
        count++;            
      }
    }
    // Topların avarajını al
    if (count > 0) {
      steer.div((float)count);
    }


    if (steer.mag() > 0) {
      // Sürme = Arzulanan - hız
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    applyForce( steer.mult(force));
  }
}
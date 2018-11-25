class Ball
{  
  // Hareket simülasyonu oluşturmak için 3 vektör; Pozisyon, hız ve ivme.
  PVector position;
  PVector velocity;
  PVector acceleration;

  // yaşam süresi
  float lifespan;

  // Renkleri
  float R;
  float G;
  float B;

  // Maximum hız ve ivme
  float maxSpeed;
  float maxAcceleration;

  // Kütlesi
  float mass;

  // Sayaç
  int counter;

  // yarıçapı (mass = r * r, r = (mass)^(1/2);
  float r;

  // Rastgele başlangıç değerleri
  float aR = 1;
  float vR = 0.2;
  float lR = 40;


  // sonuca ulaştı mı?
  boolean hasReached;

  // özel top mu?
  boolean isSpecial;

  // özel topun R kontrolü
  boolean isRadiusSmall;

  // Öldü mü?
  boolean isDead;


  Ball(float x, float y)
  {
    // Oluşturulan topun pozisyonu
    acceleration = new PVector(random(-aR, aR), random(-aR, aR));
    velocity = new PVector(random(-vR, vR), random(-vR, vR));
    position = new PVector(x+random(-lR, lR), y+ random(-lR, lR));

    // Keyfi değerler atıyorum max hız ve ivmeye
    maxSpeed = 5;
    maxAcceleration = 3;

    lifespan = random(2000, 5000);
    isDead = false;

    if (random(100) < 1)
    {
      isSpecial = true;
      isRadiusSmall = true;
    } else
    {
      isSpecial = false;
      R = random(255);
      G = random(255);
      B = random(255);
    }



    // Kütlesi rastgele 0.5 ile 2 arasında bir sayı
    mass = random(200, 600);
    counter = 0;

    // sonuca ulaştı mı?
    hasReached = false;

    // Yarıçap
    r = sqrt(mass);
  }


  void display()
  {
    if (isSpecial)
    {
      fill(random(255), random(255), random(255));
      if (isRadiusSmall)
      {
        mass += 60;
        r = sqrt(mass);
        if (mass > 6000)
        {
          isRadiusSmall = false;
        }
      } else
      {
        mass -= 60;
        r = sqrt(mass);
        if (mass< 200)
          isRadiusSmall = true;
      }
    } else
      fill(R, G, B);

    strokeWeight(2);
    ellipse(position.x, position.y, r, r);
  }

  void update()
  {

    // ivme hıza eklenir
    velocity.add(acceleration);

    // hızın max değerde kalması için sınırlıyoruz
    velocity.setMag(constrain(velocity.mag(), -1*maxSpeed, maxSpeed));

    // Hız posizyona eklenir
    position.add(velocity);

    // Fizik kurallarının düzgün çalışması için ivmeyi 0 ile çarpıyoruz
    acceleration.mult(0);

    lifespan -= 2;
    if (lifespan < 0)
    {
      isDead = true;
    }
  }

  void collisionWithBalls(ArrayList<Ball> others)
  {
    for (Ball other : others)
    {
      if (distSq(other.position.x, other.position.y, this.position.x, this.position.y) < (other.r/2 + this.r/2) * (other.r/2 + this.r/2) && distSq(other.position.x, other.position.y, this.position.x, this.position.y) > 0 ) 
      {
        PVector force = PVector.sub(other.position, this.position);
        applyForce(force.mult(-50));
      }
    }
  }


  void attraction(PVector attractor)
  {
    // Çekileceği yönü belirliyoruz
    PVector direction = PVector.sub(attractor, position);

    // formülde kullanmak için uzaklığı kaydediyoruz
    float dir = direction.mag();

    // Çok yaklaşınca kontrolden çıkmasın diye uzaklığı sınırlıyoruz
    dir = constrain(dir, 40.0, 60.0);

    // Çekim yönünü bulmak için yön vektörünün büyüklüğünü 1 e getiriyoruz
    direction.normalize();

    // Çekim kuvvet vektörü = ((çekim yönü) * katsayı) / (uzaklık * uzaklık)
    direction.mult(80000.0 / (dir * dir));

    // Kuvveti uyguluyoruz
    applyForce(direction);
    if (dist(attractor.x, attractor.y, position.x, position.y) < 30)
      hasReached = true;
  }


  void followPoints(ArrayList<PVector> targets)
  {

    // arzulanan hız için yön vektörü
    PVector direction = PVector.sub(targets.get(counter), position);

    // araç ile hedef arasındaki vektörün büyüklüğü
    float dir = direction.mag();

    // Çok yaklaşınca kontrolden çıkmasın diye uzaklığı sınırlıyoruz
    dir = constrain(dir, 20.0, 40.0);

    // Çekim yönünü bulmak için yön vektörünün büyüklüğünü 1 e getiriyoruz
    direction.normalize();

    // Çekim kuvvet vektörü = ((çekim yönü) * katsayı) / (uzaklık * uzaklık)
    direction.mult(60000.0 / (dir*dir));

    if (counter == targets.size()-1)
      applyForce(direction.mult(3)); 

    applyForce(direction);

    if (counter+1 != targets.size())
    {

      if (PVector.sub(targets.get(counter+1), position).mag() < PVector.sub(targets.get(counter+1), targets.get(counter)).mag())
      {

        counter++;
      }
    } else
    {
      if (dist(targets.get(targets.size()-1).x, targets.get(targets.size()-1).y, position.x, position.y) < 30)
        hasReached = true;
    }
  }


  void applyForce(PVector force)
  {
    // Uygulanan kuvveti değiştirmemek için yedek objeye alıyoruz
    PVector tempForce = force.get();

    // f = m * a, yani ivme = kuvvet / kütle
    tempForce.div(mass);   

    // Eğer ivme sınırını aşıyorsak düzelt
    //if (tempForce.mag() > maxAcceleration)
    //{
    //tempForce.setMag(maxAcceleration);
    //}


    // Objeye kuvveti uygula;
    acceleration.add(tempForce);
  }

  float distSq(float x1, float y1, float x2, float y2)
  {
    return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2);
  }


  // Kenarlara çarpıp çarpmadığını kontrol ediyor
  void edgeDetection()
  {
    if (position.x < r/2 || position.x > width - r/2)
    {

      if (position.x < r/2)
        position.x = r/2;
      else 
      position.x = width - r/2;

      velocity.x *= -1;
    }

    if (position.y < r/2 || position.y > height - r/2)
    {

      if (position.y < r/2)
        position.y = r/2;
      else 
      position.y = height - r/2;

      velocity.y *= -1;
    }
  }

  void applyGravity()
  {
    applyForce(new PVector(0, 70));
  }
  // Çarpışma sistemini bu fonksiyon kontrol edecek.
  void collisionDetection(boolean[][] terrainPath)
  {

    // TerrainPath listesini aşmadığımıza emin olmak için kontrol ediyoruz, eğer aşmıyorsak
    if (terrainPath[0].length  - (position.y+ r/2 ) > 0  && (position.y+r/2) > (r/2) && terrainPath.length  - (position.x+ r/2 ) > 0  && (position.x+r/2) > (r/2))
    {

      // Cismin sağına, soluna, üstüne ve alt noktalarına bakıyor, eğer bir şeye çarpıyor ise ona uygun davramnmasını sağlıyor
      if (terrainPath[(int)(position.x+ r/2)][(int)position.y] || terrainPath[(int)(position.x-r/2)][(int)position.y] || terrainPath[(int)position.x][(int)(position.y+r/2)] || terrainPath[(int)position.x][(int)(position.y-r/2)])
      {

        if ( terrainPath[(int)(position.x+ r/2)][(int)position.y])
          velocity.x = -1* abs(velocity.x);
        if (terrainPath[(int)(position.x-r/2)][(int)position.y])
          velocity.x =   abs(velocity.x);

        if (terrainPath[(int)position.x][(int)(position.y+r/2)])
          velocity.y*= -1;

        if (terrainPath[(int)position.x][(int)(position.y-r/2)])
          velocity.y *= -1;

        position.add(velocity);
      }
    }
  }
}
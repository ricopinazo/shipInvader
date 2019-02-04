import java.util.Random;

class Cloud
{
  float x, y;
  float vx;
  float size;
  PImage picture;
  Random rand;

  Cloud(float x_, float y_, float vx_, float size_)
  {
    x = x_;
    y = y_;
    size = size_;
    vx = vx_;
    rand = new Random();
    if(rand.nextInt(2) == 0)
      picture = loadImage("cloud1.png");
    else
      picture = loadImage("cloud2.png");
}

  void move()
  {
      x += vx;
      image(picture,x,y,size,size*0.6);
  }
}

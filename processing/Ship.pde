class Ship
{
  float x, y;
  float vx, v_fall;
  float x_size, y_size;
  boolean touched;
  PImage picture;

  Ship(String file, float x_, float y_, float x_size_, float vx_)
  {
    x = x_;
    y = y_;
    x_size = x_size_;
    y_size = x_size/2;
    vx = vx_;
    v_fall = 2;
    touched = false;
    picture = loadImage(file);
  }

  boolean collision(float x_, float y_)
  {
    boolean now_touched = false;
    if (x_ > (x-x_size/2)  &&  x_ < x+(x_size/2)  &&  y_ > (y-y_size/2)  &&  y_ < (y+y_size/2))
    {
      now_touched = true;
      touched = true;
    }
    return now_touched;
  }

  void move()
  {
    if (!touched)
      x += vx;
    else
    {
      x += vx;
      y += v_fall;
    }
    
    image(picture,x - x_size/2, y - y_size*2.9, x_size, y_size*3);
  }
  
  void set_vx(float vx_)
  {
   vx = vx_; 
  }
}

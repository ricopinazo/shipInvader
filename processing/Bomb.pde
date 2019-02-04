class Bomb
{
  float x_start, y_start;
  float diameter;
  float vx_start, vy_start;
  float x, y;
  float vx, vy;
  float a;

  Bomb(float x_, float y_, float vx_, float vy_, float diameter_)
  {
    x_start = x_;
    x =  x_;
    y_start = y_;
    y = y_;
    vx_start = vx_;
    vx = vx_;
    vy_start = vy_;
    vy = vy_;
    a = 0.2;
    diameter = diameter_;
  }

  void move()
  {
    x = x + vx;
    vy = vy + a;
    y = y + vy;
    
    fill(0, 180);
    ellipse(x-diameter/2, y - diameter / 2, diameter, diameter);
  }
}

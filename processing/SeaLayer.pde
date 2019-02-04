class SeaLayer
{
 PImage picture;
 float y;
 float y_size;
 float x;
 float vx;
 float width;
 float height;
 
 SeaLayer(String file, float y_, float width_, float vx_)
 {
   picture = loadImage(file);
   y = y_;
   vx = vx_;
   x = 0;
   width = width_;
   height = width * 0.0216843 * 2; // Esa es la proporcion de la imagen
 }
 
 void move()
 {
   if(x > -width)
     x = x - vx;
   else
     x= 0;
   image(picture,x,y - height/2, width*2, height);
 }
}

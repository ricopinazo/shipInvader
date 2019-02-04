import java.util.Random;
import processing.serial.*;

final int max_num_bombs = 5;
final int device = 0;          // CHANGE THIS!!!
final float max_speed = 8.0;
final float min_speed = 6.0;

Serial port;

float y_sea;      // y position of the sea surface
int regenerate_index;
int num_bombs;
boolean game_over;

Random rand;

ArrayList<Bomb> bombs;
ArrayList<Ship> ships;
ArrayList<Cloud> clouds;
Ship player;
SeaLayer sealayer1, sealayer2, sealayer3;


void setup()
{
  size(1200, 700);
  
  String port_name = Serial.list()[device]; //change the 0 to a 1 or 2 etc. to match your port
  port = new Serial(this, port_name, 9600);
  port.clear();
  
  y_sea = height*0.67;
  regenerate_index = 0;
  num_bombs = max_num_bombs;  
  game_over = false;
  
  rand = new Random();

  bombs = new ArrayList<Bomb>();
  ships = new ArrayList<Ship>();
  clouds = new ArrayList<Cloud>();
  for (int k = 0; k < 3; ++k)
    clouds.add(new Cloud(rand.nextInt(width), rand.nextInt((int)(y_sea*0.7)), 2.0+rand.nextInt(10)/10.0, 200+rand.nextInt(100)));
  player = new Ship("ship1.png", width*0.7, y_sea, 150, 0);
  sealayer1 = new SeaLayer("sea1.png", y_sea, width, 5);
  sealayer2 = new SeaLayer("sea2.png", y_sea, width, 4);
  sealayer3 = new SeaLayer("sea3.png", y_sea, width, 3);
  
}


void draw()
{
  generate_new_objects();

  check_collisions();

  draw_background();

  if (!player.touched)
    draw_bombs_marker();

  draw_objects();

  // GAME OVER message if player has been touched
  if (player.touched)
  {
    textSize(72);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width/2, height/2);
  }
}


void generate_new_objects()
{
  // Generate a bomb if one hit has been detected in Arduino
  if ( port.available() > 0) 
  {  // If data is available,
    String input = port.readStringUntil('\n');   // read it and store it in val
    if (num_bombs > 0  &&  input != null  &&  !input.equals("")  &&  !input.equals("0"))
    {
      float speed;
      try
      {
        speed = Float.parseFloat(input)/10.0;
        if(speed > max_speed)
          speed = max_speed;
        if(speed < min_speed)
          speed = min_speed;
        println("imput: " + input);
      }
      catch(NumberFormatException e)
      {
        speed = min_speed;  // default value
        println("bad input: " + input);
      }
      bombs.add(new Bomb(player.x, player.y, -speed, -speed, width*0.01));    // OBJECT CREATION AFTER HIT DETECTED
      --num_bombs;
      regenerate_index = 0;
    }
    port.clear();
  } 

  // Generate new clouds
  if (rand.nextInt(250)==0)
  {
    clouds.add(new Cloud(-300.0, rand.nextInt((int)(y_sea*0.7)), 2.0+rand.nextInt(10)/5.0, 200+rand.nextInt(100)));
  }

  // Generate new ships
  if (rand.nextInt(200)==0)
  {
    int ship_file = rand.nextInt(3);
    switch(ship_file)
    {
    case 0:
      ships.add(new Ship("ship2.png", -200, y_sea, 150, 0.4 + rand.nextInt(90)/100.0));
      break;
    case 1:
      ships.add(new Ship("ship3.png", -200, y_sea, 150, 0.4 + rand.nextInt(90)/100.0));
      break;
    case 2:
      ships.add(new Ship("ship4.png", -200, y_sea, 150, 0.4 + rand.nextInt(90)/100.0));
      break;
    }
  }
}


void check_collisions()
{
  // Check collisions and draw ships
  for (int k=0; k < ships.size(); ++k)
  {
    boolean collision = false;
    int i = 0;
    while (i < bombs.size()  &&  !collision)
    {
      collision = ships.get(k).collision(bombs.get(i).x, bombs.get(i).y);
      if (collision)
        bombs.remove(i);
      ++i;
    }
    // Check collisions between other ships and player ship
    player.collision(ships.get(k).x + ships.get(k).x_size*0.3, ships.get(k).y);
  }
}


void draw_background()
{
  // Draw sky
  background(180, 200, 235);
  noStroke();
  fill(175, 195, 230);
  rect(0, 0, width, y_sea*0.8);
  fill(170, 190, 225);
  rect(0, 0, width, y_sea*0.7);
  fill(165, 185, 220);
  rect(0, 0, width, y_sea*0.57);

  // Draw Sun
  fill(250, 210, 150, 40);
  ellipse(width*0.3, height*0.3, width*0.25, width*0.25);
  fill(250, 210, 150, 90);
  ellipse(width*0.3, height*0.3, width*0.19, width*0.19);
  fill(250, 210, 150, 130);
  ellipse(width*0.3, height*0.3, width*0.14, width*0.14);
  fill(250, 210, 150, 250);
  ellipse(width*0.3, height*0.3, width*0.08, width*0.08);
}


void draw_bombs_marker()
{
  ++regenerate_index;
  if (regenerate_index == 100 && num_bombs < max_num_bombs)
  {
    ++num_bombs;
    regenerate_index = 0;
  }  
  fill(0, 120);
  for (int k = 1; k <= num_bombs; ++k)
    ellipse(width*0.04 * k, width*0.04, width*0.02, width*0.02);
}


void draw_objects()
{
  // Draw clouds
  for (int k=0; k < clouds.size(); ++k)
    clouds.get(k).move();

  // Draw back sea layer
  sealayer3.move();

  // Draw bombs
  for (int k=0; k < bombs.size(); ++k)
    bombs.get(k).move();

  // Draw ships
  for (int k=0; k < ships.size(); ++k)
    ships.get(k).move();

  // Stop player ship if it goes very far and draw it
  if ((player.vx > 0 && player.x > width-100)  ||  (player.vx < 0 && player.x < 100))
    player.set_vx(0.0);
  player.move();

  // Draw frontal sea layers
  sealayer2.move();
  sealayer1.move();
  fill(37, 171, 187);
  noStroke();
  rect(0, y_sea + sealayer1.height/2 - 1, width, height);
}


void clean_objects()
{
  int k;

  // Remove clouds
  k = 0;
  while (k < clouds.size())
  {
    if (clouds.get(k).x > 2 * width)
      clouds.remove(k);
    else
      ++k;
  }
  // Draw back sea layer
  sealayer3.move();

  // Draw bombs
  k = 0;
  while (k < clouds.size())
  {
    if (bombs.get(k).y > 2 * height)
      bombs.remove(k);
    else
      ++k;
  }

  // Draw ships
  k = 0;
  while (k < ships.size())
  {
    if (ships.get(k).x > 2 * width)
      ships.remove(k);
    else
      ++k;
  }
}


void mousePressed()
{
  if (num_bombs > 0)
  {
    bombs.add(new Bomb(player.x, player.y, -6.0, -6.0, width*0.01));
    --num_bombs;
    regenerate_index = 0;
  }
}


void keyPressed() {
  if (key == CODED)
  {
    if (keyCode == RIGHT)
      player.set_vx(1.0);
    else if (keyCode == LEFT)
      player.set_vx(-1.0);
  }
}


void keyReleased() {
  if (key == CODED)
  {
    if (player.vx > 0  &&  keyCode == RIGHT)
      player.set_vx(0.0);
    else if (player.vx < 0  &&  keyCode == LEFT)
      player.set_vx(0.0);
  }
}

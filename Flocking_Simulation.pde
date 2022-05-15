color backColour = #DEDEDE;
color pointerColour = #FF1A1A;
color boidColour = #FF1A1A;
int boidSize = 10;
int visionRadius = 100;
int neighbourhoodRadius = 50;
float maxForce = 0.1;
float maxSpeed = 2;

boid[] Flock = new boid[100];

void setup()
{
  size(800, 600); // Defining the size of the canvas
  //frameRate(1);
  background(backColour); // Setting the colour of the background
  for(int i = 0; i < Flock.length; i++)
  {
    Flock[i] = new boid(i);
  }
}

void draw()
{
  background(backColour);
  noStroke();
  fill(pointerColour);
  circle(mouseX, mouseY, 5);
  for(int i = 0; i < Flock.length; i++)
  {
    Flock[i].flock(Flock);
    Flock[i].update();
    Flock[i].draw();
  }
}

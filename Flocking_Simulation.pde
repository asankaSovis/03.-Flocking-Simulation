color backColour = #DEDEDE;
color pointerColour = #FF1A1A;
color boidColour = #FF1A1A;
int boidSize = 10;

boid[] flock = new boid[1];

void setup()
{
  size(800, 600); // Defining the size of the canvas
  background(backColour); // Setting the colour of the background
  for(int i = 0; i < flock.length; i++)
  {
    flock[i] = new boid();
  }
}

void draw()
{
  background(backColour);
  noStroke();
  fill(pointerColour);
  circle(mouseX, mouseY, 5);
  for(int i = 0; i < flock.length; i++)
  {
    flock[i].draw();
  }
}

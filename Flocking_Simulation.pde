/* FLOCKING SIMULATION ----------------------------------------------------------

In this example, we wil create a flocking simulation. This was first proposed by Craig
Reynolds. In it he proposes a simulation that simulates a flock of birds using nothing
but mathematical models.
Check out my blog post: https://asanka-sovis.blogspot.com/2021/11/02-gravity-simulation-making-bouncing.html
Coded by Asanka Akash Sovis

-----------------------------------------------------------------------------*/

// Defining global variables
color backColour = #22556E; // Background colour of the canvas
color pointerColour = #E1E4FD; // Colour of the pointer
color boidColour[] = { #D2E5E8, #DBEDD4, #F7F0D3, #ECD7DA, #E1E4FD }; // Some random colours for the boids
int boidSize = 10; // Size of a boid

int visionRadius = 100; // Radius of vision of a boid
int neighbourhoodRadius = 300; // Radius of the neighbourhood of a boid
float maxForce = 1; // Maximum force we apply on the boids movement
// NOTE: We consider the mass of a boid to be 1 unit. Thus in this case, the force
// on a boid is equal to its acceleration.
float maxSpeed = 2; // Maximum velocity with which a boid must move

boid[] Flock = new boid[200]; // The array of boids or the 'Flock'
// Can adjust the number of boids

void setup()
{
  size(1080, 720); // Defining the size of the canvas
  //frameRate(1);
  background(backColour); // Setting the colour of the background
  
  // Initializing the flock of boids
  for(int i = 0; i < Flock.length; i++)
  {
    Flock[i] = new boid(i);
  }
    noStroke(); // We do not use a stroke anywhere
}

void draw()
{
  background(backColour); // Resetting the colour of the background
  
  // We will add some text to the design
  fill(#ECD7DA);
  textAlign(CENTER);
  textSize(70);
  text("FLOCKING SIMULATION", width / 2, 200);
  textSize(20);
  text("BY ASANKA SOVIS", width / 2, 230);
  
  // Here we draw the mouse pointer, later down the line, we define one
  // of the boids as the pointer in which case we do not use this
  //fill(pointerColour);
  //circle(mouseX, mouseY, 5);
  
  // We control the boids in this for loop. For each boid, first we
  // run the flocking procedures, then update their positions, velocities,
  // accelerations, etc and then draw them each
  // NOTE: Notice how we only flock and update every other boid rather than
  // the first boid. Instead we use the first boid as the mouse location
  // to incentivise other boids to follow it.
  for(int i = 0; i < Flock.length; i++)
  {
    if (i != 0) {
      Flock[i].flock(Flock);
      Flock[i].update();
    } else {
      Flock[i].position = new PVector(mouseX, mouseY);
    }
    Flock[i].draw();
  }
  
  //saveFrame("Output\\Flocking-" + frameCount + ".png"); // Saves the current frame. Comment if you don't need
}

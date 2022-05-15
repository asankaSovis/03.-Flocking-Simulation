// BOID CLASS ---------------------------------------------------------------------
//
// We will define an individual boid as a class. This is helpful as we can
// define all actions and rules within the entity. Later we can create as
// many boids as we want from this class and control them easily individually.

class boid {
  // Parameters of a boid
  int ID = 0; // ID of a boid
  // Position of the boid in space. We set it at random across the canvas
  PVector position = new PVector(random(width), random(height));
  // Velocity of the boid. We set this at random between -2 and +2
  PVector velocity = new PVector(random(-2, 2), random(-2, 2));
  // Also set the acceleration as a variable
  PVector acceleration = new PVector();
  // Also set a random colour to the boid
  color colour = boidColour[(int)random(boidColour.length - 1)];
  
  boid(int _ID) {
    // Initialization. We set the ID according to the position in the array
    this.ID = _ID;
  }
  
  void draw() {
    // Function that draws the boid on the screen
    if (this.ID == 0)
    {
      // If the boid is the first in the array, we just draw a
      // circle because we use it as the mouse pointer
      fill(pointerColour);
      circle(this.position.x, this.position.y, boidSize / 2);
    }
    else
    {
      // For the rest of the boids we use the drawBoid function to
      // draw them on screen
      fill(this.colour);
      drawBoid(this.position, this.velocity);
    }
  }
  
  void update() {
    // This function updates the position and velocity of the boid
    // from velocity and acceleration respectively
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);
    // We also fix the edge cases by edgeFix function. See that function for
    // more details
    edgeFix();
  }
  
  void flock(boid[] myFlock) {
    // flock function that applies the rules to each boid. The rules
    // Craig Reynolds define are as follows:
    // 01. ALIGNMENT: steer towards the average heading of local flockmates
    PVector alignment = this.align(myFlock);
    // 02. COHESION: steer to move toward the average position of local flockmates
    PVector cohesion = this.cohesion(myFlock);
    // 03. SEPARATION: steer to avoid crowding local flockmates
    PVector separation = this.separation(myFlock);
    
    // All three of these are forces that act upon the boid to get it on track
    // to behave as a flock with the rest of the boids. To we take the net force
    // and add it to the steering force.
    // NOTE: Remember, we assumed the weight of a boid to be 1, so force = acceleration
    acceleration = new PVector(); // We make sure to discard the old steering force
    this.acceleration.add(alignment);
    this.acceleration.add(cohesion);
    this.acceleration.add(separation);
  }
  
  // APPLYING THE THREE RULES TO EACH BOID---------------------------------------
  //
  // The rules are applied in a simillar way. First we define two variables:
  //       01. average - Hold the average of the parameter we consider
  //       02. total - Total number of items we used so that we can calculate the average
  // NOTE: we cannot use myFlock.length - 1 because we only consider boids within a certain
  // neighbourhood.
  //
  // Then for each boid in the flock other than ourselves (NOTE: This is why we stored
  // the ID of this boid in a variable), we get the distance between that and this boid,
  // if this is below a certain value, ie. boid is a neighbour, we add the relevane value
  // to the average variable. We also increment the total in this case.
  // Once the loop end, if we managed to find any neighbours, ie. total > 0, we divide
  // the average by total to get the actual average, sets the maximum value, subtract
  // the current velocity, limit the force and return the answer.
  
  // 01. ALIGNMENT-------------------------
  PVector align(boid[] myFlock) {
    // Function that applies the alignment rule to the boid.
    // Alignment rule states that the boid must steer towards where all other neighbouring
    // boids are moving
    // What we need to do in this rule is to create a force that steer the boid towards the
    // average location of all the velocities of the other boids in the neighbourhood.
    PVector average = new PVector();
    int total = 0;
    
    for (int i = 0; i < myFlock.length; i++) {
      if (i != this.ID) {
        float distance = this.position.dist(myFlock[i].position);
        // In this rule, we consider the vision radius
        if (distance < visionRadius) {
          // We need the average velocity
          average.add(myFlock[i].velocity);
          total++;
        }
      }
    }
    
    if (total > 0) {
      average.div(total);
      average.setMag(maxSpeed);
      average.sub(this.velocity);
    }
    
    average.limit(maxForce);
    return average;
  }
  
  // 02. COHESION----------------------
  PVector cohesion(boid[] myFlock) {
    // Function that applies the cohesion rule to the boid.
    // Cohesion rule states that the boid must steer towards the average position of the other
    // boids in the neighbourhood.
    // What we need to do is to get the average position of the neighbouring boids and then create
    // a force that steer the boid towards that.
    PVector average = new PVector();
    int total = 0;
    
    for (int i = 0; i < myFlock.length; i++) {
      if (i != this.ID) {
        float distance = this.position.dist(myFlock[i].position);
        // In this rule, we consider the radius of the neighbourhood
        if (distance < neighbourhoodRadius) {
          // We need the average position
          average.add(myFlock[i].position);
          total++;
        }
      }
    }
    
    if (total > 0) {
      average.div(total);
      // Since we need the relative position, we subtract our current location
      average.sub(this.position);
      average.setMag(maxSpeed);
      average.sub(this.velocity);
    }
    
    average.limit(maxForce);
    return average;
  }
  
  // 03. SEPARATION------------------------
  PVector separation(boid[] myFlock) {
    // Function that applies the separation rule to the boid.
    // Separation rule states that the boid must always try to avoid flocking.
    // In order to do this, we first get the distance between each boid and
    // this boid. Then we calculate the ratio between the separation of the two boids
    // in each axis and that. This is used in average calculation.
    PVector average = new PVector();
    int total = 0;
    
    for (int i = 0; i < myFlock.length; i++) {
      if (i != this.ID) {
        float distance = this.position.dist(myFlock[i].position);
        if (distance < neighbourhoodRadius) {
          PVector separation = PVector.sub(this.position, myFlock[i].position);
          separation.div(distance);
          average.add(separation);
          total++;
        }
      }
    }
    
    if (total > 0) {
      average.div(total);
      average.setMag(maxSpeed);
      average.sub(this.velocity);
    }
    
    average.limit(maxForce);
    return average;
  }
  
  // ---------------------------------------------------------------------
  
  void edgeFix() {
    // This function fixes the edge. Instead of a boid disappearing from the edge of the screen,
    // we force it to reappear from the opposite side of the screen with the same parameters.
    if (position.x < 0 || position.x > width) {
      position = new PVector(abs(position.x - width), position.y);
    }
    if (position.y < 0 || position.y > height) {
      position = new PVector(position.x, abs(position.y - height));
    }
  }
}

// ----------------------------------------------------------------------------------

void drawBoid(PVector position, PVector velocity) {
  // This function draws a boid on the screen. So that we can easily identify the direction
  // that the boid is steering, we draw them as triangles pointing in the relevant direction.
  //
  // Draw a line for convenience
  //line(position.x + velocity.x * boidSize, position.y + velocity.y * boidSize, position.x, position.y);
  
  // Drawing the triangle
  // Point 01 location relative to the position of the boid
  // (Direction the boid is moving, multiplied by boidSize)
  PVector p1 = velocity.copy();
  p1.setMag(boidSize);
  
  // Point 02 location relative to the position of the boid
  // Copy of p1 rotate at 90°
  PVector p2 = p1.copy();
  p2.rotate(HALF_PI);
  
  // Point 03 location relative to the position of the boid
  // Copy of p1 rotate at -90°
  PVector p3 = p1.copy();
  p3.rotate(-HALF_PI);
  
  // Drawing the triangle
  triangle(position.x + p1.x, position.y + p1.y, position.x + p2.x/2, position.y + p2.y/2, position.x + p3.x/2, position.y + p3.y/2);
}

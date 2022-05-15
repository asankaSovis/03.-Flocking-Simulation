class boid {
  PVector position = new PVector(width/2 + random(-50, 50), height/2 + random(-50, 50));
  PVector velocity = new PVector(random(-1, 1), random(-1, 1));
  PVector acceleration = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
  int orientation = 10;
  
  boid() {
    
  }
  
  void draw() {
    fill(boidColour);
    circle(position.x, position.y, boidSize);
    update();
  }
  
  void update() {
    position.add(velocity);
    velocity.add(acceleration);
  }
}

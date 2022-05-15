class boid {
  PVector position = new PVector(width/2, height/2);
  PVector velocity = new PVector(1, 1);
  PVector acceleration = new PVector(0.1, 0.1);
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

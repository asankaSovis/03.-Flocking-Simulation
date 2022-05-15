class boid {
  PVector position = new PVector(random(width), random(height));
  PVector velocity = new PVector(random(-2, 2), random(-2, 2));
  PVector acceleration = new PVector();
  int ID = 0;
  
  boid(int _ID) {
    this.ID = _ID;
  }
  
  void draw() {
    fill(boidColour);
    circle(this.position.x, this.position.y, boidSize);
  }
  
  void update() {
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);
    edgeFix();
  }
  
  void flock(boid[] myFlock) {
    PVector alignment = this.align(myFlock);
    PVector cohesion = this.cohesion(myFlock);
    PVector separation = this.separation(myFlock);
    
    acceleration = new PVector();
    this.acceleration.add(alignment);
    this.acceleration.add(cohesion);
    this.acceleration.add(separation);
  }
  
  PVector align(boid[] myFlock) {
    PVector average = new PVector();
    int total = 0;
    for (int i = 0; i < Flock.length; i++) {
      if (i != this.ID) {
        float distance = this.position.dist(Flock[i].position);
        if (distance < visionRadius) {
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
  
  PVector cohesion(boid[] myFlock) {
    PVector average = new PVector();
    int total = 0;
    for (int i = 0; i < Flock.length; i++) {
      if (i != this.ID) {
        float distance = this.position.dist(Flock[i].position);
        if (distance < neighbourhoodRadius) {
          average.add(myFlock[i].position);
          total++;
        }
      }
    }
    if (total > 0) {
      average.div(total);
      average.sub(this.position);
      average.setMag(maxSpeed);
      average.sub(this.velocity);
    }
    average.limit(maxForce);
    return average;
  }
  
  PVector separation(boid[] myFlock) {
    PVector average = new PVector();
    int total = 0;
    for (int i = 0; i < Flock.length; i++) {
      if (i != this.ID) {
        float distance = this.position.dist(Flock[i].position);
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
  
  void edgeFix() {
    if (position.x < 0 || position.x > width) {
      position = new PVector(abs(position.x - width), position.y);
    }
    if (position.y < 0 || position.y > height) {
      position = new PVector(position.x, abs(position.y - height));
    }
  }
}

class Ground{
  float pX, pY;
  int kCount = 0;
  float posX = width;
  float posY = height - floor(random(groundHeight -20, groundHeight + 30));
  int w = floor(random(1, 10));
  
  Ground(){  
  }
  
  void show(){
    image(ground_01,posX + w, 658);
  }
  
  void move(float vel){
    posX -= vel;
  }
}

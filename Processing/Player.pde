class Player{
  float posY = 0;
  float velY = 0;
  float gravity = 0.75;
  //int size = 20;
  boolean slide = false;
  boolean attack = false;
  boolean hurt = false;
  boolean dead = false;
  boolean win = false;
  int life = 3;
  
  int runCount = -4; //sirve para cambiar cada animacino del ninja
  int lifespan;
  int score;
  
  Player(){
  }
  
  void jump(){
    if (posY == 0){
      gravity = 3;
      velY = 33;
    }
  }
  
  void show(){
    if (slide && posY == 0){
      if (runCount < 0){ //-----------ninja deslizandose
        image(ninjaSlide0, playerXpos - ninjaSlide0.width/2, height - groundHeight+20 - (posY + ninjaSlide0.height));
      }
      else {
        image(ninjaSlide1, playerXpos - ninjaSlide1.width/2, height - groundHeight+20 - (posY + ninjaSlide1.height));
      }
    } else if (attack){
        if (runCount < 0){ //-----------ninja atacando
          image(ninjaAttack0, playerXpos - ninjaAttack0.width/2 + 30, height - groundHeight+20 - (posY + ninjaAttack0.height));
        }
        else {
          image(ninjaAttack1, playerXpos - ninjaAttack1.width/2 + 30, height - groundHeight+20 - (posY + ninjaAttack1.height));
        }
    } else if (hurt) {
        image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
    }
    else {
      if (posY == 0){    
        if (runCount < 0){ //-------------ninja corriendo
          image(ninjaRun3, playerXpos - ninjaRun3.width/2, height - groundHeight - (posY + ninjaRun3.height));
        }
        else {
          image(ninjaRun5, playerXpos - ninjaRun5.width/2, height - groundHeight - (posY + ninjaRun5.height));
        }
     
      } else{ //----------------ninja saltando
        image(ninjaJump8, playerXpos - ninjaJump8.width/2, height - groundHeight - (posY + ninjaJump8.height));
        //ninjaJump8.resize(0,150);
      }
    }
    if(!dead){
      runCount++;
    }
    if (runCount > 4){
      runCount = -4;
    }
  }

 //movimiento del ninja---------------------------------------
  void move(){
    posY += velY;
    if (posY > 0){
      velY -= gravity;
    }
    else {
      velY = 0;
      posY = 0;
    }
    //-------deteccion de colisiones con obstaculos----------------------
    for (int i = 0; i < obstacles.size(); i++){
      if (dead){
        if (obstacles.get(i).collision(playerXpos, posY + ninjaSlide0.height / 2, ninjaSlide0.width * 0.5, ninjaSlide0.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          obstacles.remove(i);
          for (int k=0; k<heartss.size(); k++){
            heartss.get(k);
            heartss.remove(k);
          }
        }
        else if(obstacles.get(i).collision(playerXpos, posY + ninjaSlide1.height / 2, ninjaSlide1.width * 0.5, ninjaSlide1.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          obstacles.remove(i);
          for (int k=0; k<heartss.size(); k++){
            heartss.get(i);
            heartss.remove(heartss.size()-1);
          }
        }
      }
      else{
        if (obstacles.get(i).collision(playerXpos, posY + ninjaRun3.height / 2, ninjaRun3.width * 0.5, ninjaRun3.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          obstacles.remove(i);
          for (int k=0; k<heartss.size(); k++){
            heartss.get(i);
            heartss.remove(heartss.size()-1);
          }
        }
        else if(obstacles.get(i).collision(playerXpos, posY + ninjaRun5.height / 2, ninjaRun5.width * 0.5, ninjaRun5.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          obstacles.remove(i);
          for (int k=0; k<heartss.size(); k++){
            heartss.get(i);
            heartss.remove(heartss.size()-1);
          }
        }
      }
    }
    //-----colision con barriles
    for (int i = 0; i < barrels.size(); i++){
      if(slide && posY == 0){
        if (barrels.get(i).collision(playerXpos, posY + ninjaSlide0.height / 2, ninjaSlide0.width * 0.5, ninjaSlide0.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          barrels.remove(i);
        }
        else if(barrels.get(i).collision(playerXpos, posY + ninjaSlide1.height / 2, ninjaSlide1.width * 0.5, ninjaSlide1.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          barrels.remove(i);
        }
      } 
      else if (attack){ //si colisiona con un barril mientras ataca, desaparece el barril y no pierde
        if (barrels.get(i).collision(playerXpos, posY + ninjaAttack0.height / 2, ninjaAttack0.width * 0.5, ninjaAttack0.height)){
          barrels.remove(i);
          score += 10;
        }
        else if (barrels.get(i).collision(playerXpos, posY + ninjaAttack1.height / 2, ninjaAttack1.width * 0.5, ninjaAttack1.height)){
          barrels.remove(i);
          score += 10;
        }
        
      }
      else{
        if (barrels.get(i).collision(playerXpos, posY + ninjaRun3.height/2, ninjaRun3.width*0.5, ninjaRun3.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          barrels.remove(i);
        }
        else if(barrels.get(i).collision(playerXpos, posY + ninjaRun5.height / 2, ninjaRun5.width * 0.5, ninjaRun5.height)){
          //dead = true;
          image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
          life--;
          barrels.remove(i);
        }
      }
    }
    //-----colision con monedas, desaparecen si las toca y suma 10 pts al score
    for (int i = 0; i < coins.size(); i++){
      if(slide && posY == 0){
        if (coins.get(i).collision(playerXpos, posY + ninjaSlide0.height / 2, ninjaSlide0.width * 0.5, ninjaSlide0.height)){
          score += 50;
          coins.remove(i);
        }
        else if (coins.get(i).collision(playerXpos, posY + ninjaSlide1.height / 2, ninjaSlide1.width * 0.5, ninjaSlide1.height)){
          score += 50;
          coins.remove(i);
        }
      }
      else{
        if (coins.get(i).collision(playerXpos, posY + ninjaRun3.height/2, ninjaRun3.width*0.5, ninjaRun3.height)){
          score += 50;
          coins.remove(i);
        }
        else if (coins.get(i).collision(playerXpos, posY + ninjaRun5.height/2, ninjaRun5.width*0.5, ninjaRun5.height)){
          score += 50;
          coins.remove(i);
        }
      }
    }
    
    if (life == 0) {
      dead = true;
    }
    if (score >= 500){
      win = true;
    }
  }
  
  //Slide function ------------------------
  void sliding(boolean isSliding){
    if (posY != 0 && isSliding){
      gravity = 8;
    }
    slide = isSliding;
  }
  
  //Hurt funciton---------------------
  void hurting (boolean isHurt) {
    hurt = isHurt;
    image(ninjaHurt, playerXpos - ninjaHurt.width/2, height - groundHeight - (posY + ninjaHurt.height));
  }
  
  //Attack function ------------------------
  void attacking(boolean isAttck){
    attack = isAttck;
  }
  
  void update(){
    incrementCounter();
    move();
  }
  
  //aumento del score ------------------------
  void incrementCounter(){
    lifespan++;
    if(lifespan % 3 == 0){
      score += 1;
    }
  }
  
}

class Obstacle{
 float posX;
 int w, h;
 int type;
 
 Obstacle (int t){
  posX = width;
  type = t;
  switch (type){
   case 0: w = smallRock.width; //20
           h = smallRock.height; //40
           break;
    case 1: w = bigStatue.width; //250
            h = 100; //195
            break;
    case 2: w = manySpikes.width; //60
            h = manySpikes.height; //40
            break;
  }
 }
  
  void show(){
    switch (type){
      case 0: image(smallRock, posX - smallRock.width / 2, height - groundHeight - smallRock.height);
           //smallRock.resize(0,100);
           break;
      case 1: image(bigStatue, posX - bigStatue.width / 2, height - groundHeight - bigStatue.height);
            //bigStatue.resize(0,200);
            break;
      case 2: image(manySpikes, posX - manySpikes.width / 2, height - groundHeight - manySpikes.height);
            //manySpikes.resize(200,0);
            break;
    }
  }
  
  void move(float vel){
    posX -= vel;
  }
  
   boolean collision (float playerX, float playerY, float playerWidth, float playerHeight) {
     float playerLeft = playerX - playerWidth / 2;
     float playerRight = playerX - playerWidth / 2;
     float thisLeft = posX - w/2;
     float thisRight = posX + w/2;
     
     if (playerLeft < thisRight && playerRight > thisLeft) {
       float playerDown = playerY - playerHeight/2;
       float thisUp = h;
       if (playerDown < thisUp){
         return true;
       }
     }
     return false;
   }
  
}

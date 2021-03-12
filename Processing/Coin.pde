class Coin{
 float w = 100; //100
 float h = 25; //25
 float posX, posY;
 int k = 0;
 
 Coin(int t){
  posX = width;
  switch(t){
    case 0: posY = 70 + h /4;
           break;
    case 1: posY = 125;
            break;
    case 2: posY = 200;
            break;
  }
 }
 
 void show(){
   image(coin1, posX - coin1.width/2, height - groundHeight - (posY + coin1.height - 20), (coin1.width/2)+50, (coin1.height/2)+50);
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
       float playerUp = playerY + playerHeight/2;
       float thisUp = posY + h/2;
       float thisDown = posY - h/2;
       if (playerDown < thisUp && playerUp >= thisDown){
         return true;
       }
     }
     return false;
   }
 
}

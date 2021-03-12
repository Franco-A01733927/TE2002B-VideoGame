class Barril{
 float w = 200; //100
 float h = 25; //25
 float posX, posY;
 int flapCount = 0;
 
 Barril(int t){
  posX = width;
  switch(t){
    case 0: posY = 10 + h /4;
           break;
    case 1: posY = 60;
            break;
    case 2: posY = 130;
            break;
  }
 }
 
 void show(){
   flapCount++;
   if (flapCount < 0){
     image(Barril3, posX - Barril3.width/2, height - groundHeight - (posY + Barril3.height - 20), (Barril3.width/2)+50, (Barril3.height/2)+50);
     //Barril3.resize(0,75);
   }
   else{
     image(Barril6, posX - Barril6.width/2, height - groundHeight - (posY + Barril6.height - 20), (Barril6.width/2)+50, (Barril6.height/2)+50);
     //Barril6.resize(0,75);
   }
   if(flapCount > 10){
     flapCount = -10;
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

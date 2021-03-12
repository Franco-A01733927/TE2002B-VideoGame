//music library----------------------------------------
import processing.sound.*;

//serial object library -------------------------------
import processing.serial.*;
Serial mySerial;
String myString = null;
int nl = 10; //ASCII code for carage return serial validate when recieving dta
float myVal;

//Background sound variables---------------------------
SoundFile file;
String audioName = "Only the Braves - FiftySounds.mp3";
String path;

//PImage is a data type that stores images--------------
PImage bck0;
PImage bck1;
PImage ninjaRun3;
PImage ninjaRun5;
PImage ninjaJump8;
PImage ninjaSlide0;
PImage ninjaSlide1;
PImage ninjaAttack0;
PImage ninjaAttack1;
PImage ninjaHurt;
PImage Barril3;
PImage Barril6;
PImage smallRock;
PImage bigStatue;
PImage manySpikes;
PImage ground_01;
PImage coin1;
PImage coin2;
PImage diamond;
PImage life;

//Font Types---------------------------------------------
PFont font1;
PFont font2;
PFont font3;

//Array that stores the items that move throughout the game
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Barril> barrels = new ArrayList<Barril>();
ArrayList<Ground> grounds = new ArrayList<Ground>();
ArrayList<Coin> coins = new ArrayList<Coin>();
ArrayList<Heart> heartss = new ArrayList<Heart>();

ArrayList<PImage> hearts = new ArrayList<PImage>();

//Global Variables---------------------------------------
int obsTimer = 0;
int minTimeBetObs = 60;
int randomAddition = 0;
int groundCounter = 0;
float vel = 20;
int groundHeight = 200;
int playerXpos = 300;
int NoHearts = 3;
int heartCounter = 0;

//menu variables ----------------------------------------
final int stateGame = 0;
final int statePause = 1;
int myState = statePause;

//ninja object is initialized ---------------------------
Player ninja;

//setup game --------------------------------------------
void setup(){
  //soundtrack
  path = sketchPath(audioName);
  file = new SoundFile(this, path);
  file.loop();
  
  size (1600, 900);
  frameRate(60);
  //hearts = new PImage[3];
  
  //all usable images are loaded
  ninjaRun3 = loadImage("Images/Run__003.png");
  ninjaRun3.resize(0,150);
  ninjaRun5 = loadImage("Images/Run__005.png");
  ninjaRun5.resize(0,150);
  ninjaJump8 = loadImage("Images/Jump__008.png");
  ninjaJump8.resize(0,150);
  ninjaSlide0 = loadImage("Images/Slide__000.png");
  ninjaSlide0.resize(0,115);
  ninjaSlide1 = loadImage("Images/Slide__001.png");
  ninjaSlide1.resize(0,115);
  ninjaAttack0 = loadImage("Images/Jump_Attack__003.png");
  ninjaAttack0.resize(0,165);
  ninjaAttack1 = loadImage("Images/Jump_Attack__005.png");
  ninjaAttack1.resize(0,165);
  Barril3 = loadImage("Images/Barrel_3.png");
  Barril6 = loadImage("Images/Barrel_6.png");
  smallRock = loadImage("Images/Little_Wreckage.png");
  smallRock.resize(128,128);
  bigStatue = loadImage("Images/Decor_Statue.png");
  bigStatue.resize(0,200);
  manySpikes = loadImage("Images/Spikes_2.png");
  ground_01 = loadImage("Images/ground_1.png");
  coin1 = loadImage("Images/Coin_01.png");
  coin1.resize(0,40);
  coin2 = loadImage("Images/Coin_03.png");
  coin2.resize(0,40);
  ninjaHurt = loadImage("Images/Dead__001.png");
  ninjaHurt.resize(0,160);
  diamond = loadImage("Images/Diamond.png");
  diamond.resize(0,150);
  life = loadImage("Images/Life.png");
  life.resize(0, 60);
  
  //find serial port
  //mySerial = new Serial(this, "COM5", 9600);
  
  //load fonts
  font1 = loadFont("Rockwell-Bold-48.vlw");
  font2 = loadFont("Monospaced.bold-48.vlw");
  font3 = loadFont("MaturaMTScriptCapitals-48.vlw");
  
  //the player is created
  ninja = new Player();
}

//switch between pause and game mode --------------------
void draw(){
  switch (myState) {
    
    case stateGame:
      //checkSerial(); //read serial input from sensor
      startGame();
      break;
    
    case statePause:
      pauseGame();
      break;
      
    default:
      println("Error number 939; unknown state : " + myState+".");
      exit();
      break;
  }
}

//game mode screen --------------------------------------
void startGame(){
  //file.loop();
  bck1 = loadImage("Images/Background_05.png");
  background(bck1);
  if(ninja.dead){
    file.stop();
  }
  
  //obstacles are initialized
  updateObs();
  //font1 = loadFont("Rockwell-Bold-48.vlw");
  textFont(font1, 20);
  textAlign(LEFT, CENTER);
  //textSize(20);
  fill(0);
  text("Score: " + ninja.score, 10, 25);
  text("Coins +50 pts", 10, 50);
  text("Destroyed Barrels +10 pts", 10, 70);
  
  text("Lifes: " + ninja.life, 1310, 45);
  //image(hearts.get(0), 1395, 25);
  //image(hearts.get(1), 1455, 25);
  //image(hearts.get(2), 1515, 25);
  addHearts();
  showHearts();
}

//pause mode screen -------------------------------------
void pauseGame(){
  //file.stop();
  bck1 = loadImage("Images/Background_04.png");
  background(bck1);
  
  textFont(font2, 25);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Franco Minutti Simoni", 175, 25);
  text("A01735470", 175, 48);
  
  fill(255);
  text("Santiago Hernández Arellano", 800, 25);
  text("A01735470", 800, 48);
  
  fill(255);
  text("Jhonathan Yael Martínez Vargas", 1350, 25);
  text("A01734193", 1350, 48);

  textFont(font3, 100);
  fill(0);
  text("Ninja Dash", 800, 490); //465, 535
  
  textFont(font1, 30);
  fill(255);
  text("Press 'm' to play", 800, 750);
  
  //ninjaJump8.resize(0, 200);
  image(ninjaJump8, 750, 270, 150, 200);
  
  //diamond.resize(0,65);
  image(diamond, 610, 717, 50, 65);
  image(diamond, 935, 717, 50, 65);
}

//key press actions -------------------------------------
void keyPressed(){
  switch(key){
    case ' ' : ninja.jump();
               break;
    case 'c' : if(!ninja.dead && !ninja.win){
                   ninja.sliding(true);
               }
               break;
    case 'x' : if(!ninja.dead && !ninja.win){
                   ninja.attacking(true);
               }
               break;
  }
  
  switch (myState){
     //Game
     case stateGame:
       keyStartGame();
       break;
       
     //Pause menu
     case statePause:
       keyPauseGame();
       break;
  }
}

void keyReleased(){
  switch(key){
    case 'c' : if(!ninja.dead && !ninja.win){
                   ninja.sliding(false);
               }
               break;
    case 'x' : if(!ninja.dead && !ninja.win){
                   ninja.attacking(false);
               }
               break;
    case 'r' : if(ninja.dead || ninja.win){
                   reset();
               }
               break;
  }
}

//function to switch screens ----------------------------
void keyStartGame(){
  if (key == 'm'){
    myState = statePause;
  }
  else {
    //do nothing
  }
}

void keyPauseGame(){
  if (key == 'm'){
    myState = stateGame;
  }
  else {
    //do nothing
  }
}

//update and initialize obstacles------------------------
void updateObs(){
  showObs();
  ninja.show();
  
  if (ninja.win){ //check for winning condition
    textFont(font1, 40);
    textAlign(CENTER, CENTER);
    image(diamond, 710, 100);
    text("CONGRATS, YOU HAVE WON!!", 800, 300);
    textSize(16);
    text("(Press 'r' to restart)", 800, 340);
  }
  else if (ninja.dead) { //check for dead condition
    fill(0);
    ninja.hurting(true);
    textFont(font1, 32);
    textAlign(CENTER, CENTER);
    text("YOU LOST, TRY AGAIN!", 800, 300);
    textSize(16);
    text("(Press 'r' to restart)", 800, 330);
  }
  else{ // continue playing
    obsTimer++;
    vel += 0.04;
    if (obsTimer > minTimeBetObs + randomAddition){
      addObs();
    }
    groundCounter++;
    if(groundCounter > 10){
      groundCounter = 0;
      grounds.add(new Ground());
    }
    moveObstacles();
    ninja.update();
    checkHearts();
  }
}

//Show obstacles along the track-------------------------
void showObs(){
  for (int i=0; i<grounds.size(); i++){
    grounds.get(i).show();
  }
  for (int i=0; i<obstacles.size(); i++){
    obstacles.get(i).show();
  }
  for (int i=0; i<barrels.size(); i++){
    barrels.get(i).show();
  }
    for (int i=0; i<coins.size(); i++){
    coins.get(i).show();
  }
}

//Add obstacles to the track randomly--------------------
void addObs(){
  if(random(1) < (0.5)){
    if(random(1) < (0.5)){
      coins.add(new Coin(floor(random(3))));
    }
    else{
      barrels.add(new Barril(floor(random(3))));
    }
  }
  else {
    obstacles.add(new Obstacle(floor(random(3))));
  }
  randomAddition = floor(random(15));
  obsTimer = 0;
}

//Move obstacles through the track-----------------------
void moveObstacles(){
  for (int i=0; i<grounds.size(); i++){
    grounds.get(i).move(vel);
    if(grounds.get(i).posX < -playerXpos){
      grounds.remove(i);
      i--;
    }
  }
  for (int i=0; i<obstacles.size(); i++){
    obstacles.get(i).move(vel);
    if(obstacles.get(i).posX < -playerXpos){
      obstacles.remove(i);
      i--;
    }
  }
  for (int i=0; i<barrels.size(); i++){
    barrels.get(i).move(vel);
    if(barrels.get(i).posX < -playerXpos){
      barrels.remove(i);
      i--;
    }
  }
  for (int i=0; i<coins.size(); i++){
    coins.get(i).move(vel);
    if(coins.get(i).posX < -playerXpos){
      coins.remove(i);
      i--;
    }
  }
}

//add hearts---------------------------------------------
void addHearts(){
    heartss.add(new Heart(0));
    heartss.add(new Heart(1));
    heartss.add(new Heart(2));
}

//display hearts-----------------------------------------
void showHearts() {
  for (int i=0; i<heartss.size(); i++){
    heartss.get(i).show();
  }
}

void checkHearts(){
  if (ninja.life == 2){
    heartss.get(2);
    heartss.remove(2);
  }
}

//restart the game after losing--------------------------
void reset(){
  ninja = new Player();
  obstacles = new ArrayList<Obstacle>();
  barrels = new ArrayList<Barril>();
  grounds = new ArrayList<Ground>();
  coins = new ArrayList<Coin>();
  
  obsTimer = 0;
  randomAddition = floor(random(0));
  groundCounter = 0;
  vel = 20;
  heartCounter = 0;
  file.loop();
}

void checkSerial(){  
  //-----------
  while (mySerial.available() > 0){
    myString = mySerial.readStringUntil(nl);
    if (myString != null){
      myVal = float(myString); //takes data from serial and turns it into number
      println(myVal);
      if (myVal < 33){
        ninja.jump();
      }
      else if((myVal >= 33) && (myVal > 66)){
        if(!ninja.dead && !ninja.win){
          ninja.sliding(true);
        }
      }
      else{
        if(!ninja.dead && !ninja.win){
          ninja.attacking(true);
        }
      }
    }
  }
  //---------------
}

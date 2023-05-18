float pipe;
PFont f;
PImage birdIMG;
PImage pipeIMGtop;
PImage pipeIMGbot;
PImage landscape;
float pipeX = 1200;
float pipe1Y = 0;
float pipe2Y = 0;
float speed = 2;
boolean anyAlive = true;

float MUTATE_AMOUNT_ = 0.03;
float MUTATE_RATE_ = 0.09;
int INPUT_DIM_ = 8;
float WEIGHT_CHANCE_ = 0.1;
float STD_ = 0.3;

/*
float gravity = 375.0;
boolean drop = true;
float hitboxX = 80;
float hitboxY = 80;
int vy = 0;
*/
int gameScore = 0;
int generation = 1;
int playersAlive = 0;
int highScore = 0;

import java.util.ArrayList;
ArrayList<Player> players = new ArrayList<Player>();
int numPlayers = 100;
int[] brainLayers = {10,10,10};



void setup(){
  birdIMG = loadImage("bird.jpg");
  pipeIMGtop = loadImage("pipe2.png");
  pipeIMGbot = loadImage("pipe.png");
  landscape = loadImage("landscape.jpg");
  f = createFont("david",16,true);
  genPipe();
  
  //params
  float std = STD_;
  float weightChance = WEIGHT_CHANCE_;
  float mutateRate = MUTATE_RATE_;
  float mutateAmount = MUTATE_AMOUNT_;
 
  for(int i = 0; i<numPlayers; i++){
    players.add(new Player(brainLayers,std,mutateRate,mutateAmount,weightChance));
  }
  size(1500,1000);
  smooth();
  frameRate(60);
  draw();
}

void draw(){

  if(anyAlive){
    background(255);

    
    fill(0);
    rect(0,900,1500,1000);
    fill(255,0,0);
    textFont(f,36);
    textAlign(CENTER);
    text("Generation: "+generation,1200,250);
    text("Alive: "+playersAlive+"/"+numPlayers,1200,200);
    text("Score: "+gameScore,1200, 150);
    text("High score: "+highScore,1200,100);
    
    
    int awardPoint = 0;
    
    pipeX -= 10*speed;
    if (pipeX + 250 <= 0){
      gameScore+=1;
      genPipe();
      awardPoint=1;
    }
    pipe();
    
    anyAlive = false;
    playersAlive = 0;
    for(Player p: players){
      p.update(pipeX,pipe1Y,pipe2Y);
      
      if(p.getAlive()){
        playersAlive++;
        anyAlive = true;
        p.addPoint(awardPoint);
      }
    }
    
    
  }  

  

  else if (!anyAlive){
    /*
    landscape.resize(width,height);
    background(landscape);
    if (highScore < gameScore){
      highScore = gameScore;
      gameScore = 0;
    }
    fill(0);
    rect(width/2-150,600,300,100);
    textFont(f,36);
    textAlign(CENTER);
    text("Score: "+gameScore,width/2, height/2);
    text("High score: "+highScore,width/2,height/2 +50);
    fill(255,0,0);
    text("press F to \n play again ",width/2,635);
    */
    reset();
  }
}

/*
void bird(){
  pushMatrix();
  translate(100,gravity);
  image(birdIMG,0,0,80,80);
  //rect (0,0,40,40);
  popMatrix();
}
*/
void pipe(){
  //System.out.println(colide);
  
  pushMatrix();
  translate(pipeX,0);
  //rect(0,0,15,50);
  image(pipeIMGbot,0,pipe1Y);
  popMatrix();
  pushMatrix();
  translate(pipeX, -689);
  //translate(pipeX,0);
  image(pipeIMGtop,0,pipe2Y);
  popMatrix();
  
}

void genPipe(){
    float min=125;
    float max=475;
    //pipe 2 is top
    pipe2Y = (float)(Math.random() * ((max - min) + 1)) + min;
    pipe1Y = pipe2Y + 300;
    pipeX = 1500;
    
}

/*
void mousePressed(){
    vy = -20; 
}
void colide(){

    if(pipeX <= 100 && pipeX >= -250){
        System.out.println(gravity + "      " +pipeX);

        System.out.println("top: " + pipe2Y + ",            bot: " + pipe1Y);
      if (gravity <= pipe2Y - 19 || gravity >= pipe1Y -40){
        colide = true;


      }
    }
    if(gravity -40 <= 0 || gravity+40 >= 900){
      colide = true; 
    }

}
*/
void keyPressed(){
    if (key == 'F' || key == 'f'){
      reset();
    } 
}
void reset(){
  pipeX = 1200;
  gameScore = 0;
  background(255);

  players.sort((o1, o2)-> o2.calcScore()- o1.calcScore() );
  //println(players.get(0).calcScore(),players.get(50).calcScore());
  ArrayList<Player> newPlayers = new ArrayList<Player>();
  int maxOptions = numPlayers-10;
  float totalScore = 0;
  for(int i = 0; i<numPlayers; i++){
    highScore = max(players.get(i).getScore(),highScore);
    totalScore+=players.get(i).calcScore();
  }

  for(int i = 0; i<numPlayers; i++){
    float p1 = random(totalScore);
    float p2 = random(totalScore);
    int p1Idx = 0;
    int p2Idx = 0;
    for(int j = 0;j < numPlayers; j++){
      p1 -= players.get(j).calcScore();
      p2 -= players.get(j).calcScore();
      if(p1>0){
        p1Idx++;
        //println(p1,p1Idx);
      }
      if(p2>0){
        p2Idx++;
        //println(amount,p,pIdx);
      }
    }
    int tmp = p1Idx;
    p1Idx = min(p1Idx,p2Idx);
    p2Idx = max(p2Idx,tmp);
    if(i < maxOptions){
      
      newPlayers.add(players.get(p1Idx).giveBirth(players.get(p2Idx),0.75-MUTATE_RATE_/2.0,0.25-MUTATE_RATE_/2.0,MUTATE_AMOUNT_));
    }
    else
      newPlayers.add(players.get(p1Idx));
    //println(players.get(pIdx).getBrain());
  }
  players = newPlayers;
  
  for(Player p: players){
   p.startStats(); 
  }
  anyAlive = true;
  generation++;


    

}

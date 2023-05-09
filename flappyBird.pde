float pipe;
PFont f;
PImage birdIMG;
PImage pipeIMGtop;
PImage pipeIMGbot;
PImage landscape;
float pipeX = 1200;
float pipe1Y = 0;
float pipe2Y = 0;
boolean colide = false;
float gravity = 375.0;
boolean drop = true;
float hitboxX = 80;
float hitboxY = 80;
int vy = 0;
int gameScore = -2, newScore = -1;
int highScore = 0;
void setup(){
   birdIMG = loadImage("bird.jpg");
   pipeIMGtop = loadImage("pipe2.png");
   pipeIMGbot = loadImage("pipe.png");
   landscape = loadImage("landscape.jpg");
   f = createFont("david",16,true);

   size(1500,1000);
   smooth();
   frameRate(60);
   draw();
}

void draw(){

  if(!colide){
    background(255);

    
    fill(0);
    rect(0,900,1500,1000);
    fill(255,0,0);
    textFont(f,36);
    textAlign(CENTER);
    text("Score: "+gameScore,1200, 150);
    text("High score: "+highScore,1200,100);
    bird();
    vy += 1 ;
    gravity += vy;
    colide();

    pipeX -= 10;
    pipe();
  }  

  if (newScore >= gameScore){
      genPipe();
  }
  if (pipeX + 250 == 0){
    newScore ++;
    pipeX = 1500;
  }

  if (colide){
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
    
  }
}
void bird(){
  pushMatrix();
  translate(100,gravity);
  image(birdIMG,0,0,80,80);
  //rect (0,0,40,40);
  popMatrix();
}
void pipe(){
    System.out.println(colide);

  pushMatrix();
  translate(pipeX,0);
  //rect(0,0,15,50);
  image(pipeIMGbot,0,pipe1Y);
  popMatrix();
  pushMatrix();
  translate(pipeX, -689);
  image(pipeIMGtop,0,pipe2Y);
  popMatrix();
  
}

void genPipe(){
    float min=125;
    float max=475;
    //pipe 2 is top
    pipe2Y = (float)(Math.random() * ((max - min) + 1)) + min;
    pipe1Y = pipe2Y + 300;
    gameScore ++;
    pipe();
    //System.out.println("top: " + pipe2Y + ",            bot: " + pipe1Y);
}
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
void keyPressed(){
    if (key == 'F' || key == 'f'){
      colide = false;

      reset();
    } 
}
void reset(){
    pipeX = 1200;
    gravity = 375.0;
    drop = true;
    vy = 0;
    gameScore = -2;
    newScore = -1;
    background(255);


    setup();

}

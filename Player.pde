 //<>// //<>// //<>// //<>// //<>//


class Player{
  float y;
  float hitboxX;
  float hitboxY;
  float vy;

  
  
  int generation;
  float mutateRate;
  float mutateAmount;

  int score;
  boolean alive;
  FullyConnectedNet brain;
  int timeAlive;
  
  
  Player(int[] hidden_dims){
    this.brain = new FullyConnectedNet(INPUT_DIM_,hidden_dims,2);
    this.generation = 0;
    this.mutateRate = MUTATE_RATE_;
    this.mutateAmount = MUTATE_AMOUNT_;
    startStats();
    
  }
  Player(int[] hidden_dims,float std){
    this.brain = new FullyConnectedNet(INPUT_DIM_,hidden_dims,2,std);
    this.generation = 0;
    this.mutateRate = MUTATE_RATE_;
    this.mutateAmount = MUTATE_AMOUNT_;
    startStats();
    
  }
  Player(int[] hidden_dims,float std,float weightChance){
    this.brain = new FullyConnectedNet(INPUT_DIM_,hidden_dims,2,std,weightChance);
    this.generation = 0;
    this.mutateRate = MUTATE_RATE_;
    this.mutateAmount = MUTATE_AMOUNT_;
    startStats();
    
  }
  Player(int[] hidden_dims,float std,float weightChance,float mutateRate){
    this.brain = new FullyConnectedNet(INPUT_DIM_,hidden_dims,2,std,weightChance);
    this.generation = 0;
    this.mutateRate = mutateRate;
    this.mutateAmount = MUTATE_AMOUNT_;
    startStats();
    
  }
  Player(int[] hidden_dims,float std,float weightChance, float mutateRate,float mutateAmount){
    this.brain = new FullyConnectedNet(INPUT_DIM_,hidden_dims,2,std,weightChance);
    this.generation = 0;
    this.mutateRate = mutateRate;
    this.mutateAmount = mutateAmount;
    startStats();
    
  }

  Player(FullyConnectedNet brain, int generation, float mutateRate, float mutateAmount){
    this.brain = new FullyConnectedNet(brain);
    
    
    this.generation=generation;
    this.mutateRate = mutateRate;
    this.mutateAmount = mutateAmount;
    startStats();
  }

  void startStats(){
    this.alive = true;
    this.y = 375.0;
    this.hitboxX = 80;
    this.hitboxY = 80;
    this.vy = 0;
    this.timeAlive = 0;
    this.score = 0;
    this.generation++;
  }
  Player giveBirth(){
    return new Player(this.brain,this.generation,this.mutateRate,this.mutateAmount);
  }
  Player giveBirth(float mutateRate){
    return new Player(this.brain,this.generation,mutateRate,this.mutateAmount);
  }
  Player giveBirth(float mutateRate,float mutateAmount){
    return new Player(this.brain,this.generation,mutateRate,mutateAmount);
  }

  Player giveBirth(Player parent2, float pInherit1, float pInherit2, float mutateRate, float mutateAmount){
    FullyConnectedNet newBrain = new FullyConnectedNet(this.brain,parent2.getBrain(),pInherit1,pInherit2,mutateRate,mutateAmount);
    return new Player(newBrain,this.generation,mutateRate,mutateAmount);
  }

  Player giveBirth(Player parent2, float pInherit1, float pInherit2, float mutateAmount){
    float mutateRate = max(1-(pInherit1+pInherit2),0);
    return this.giveBirth(parent2,pInherit1,pInherit2,mutateRate,mutateAmount);
  }
  Player giveBirth(Player parent2, float pInherit1, float pInherit2){
    
    return this.giveBirth(parent2,pInherit1,pInherit2,this.mutateAmount);
  }
  Player giveBirth(Player parent2, float mutateRate){
    float pInherit = 0.5*(1-mutateRate);
    return this.giveBirth(parent2,pInherit,pInherit,mutateRate,this.mutateAmount);
  }
  Player giveBirth(Player parent2){
    return this.giveBirth(parent2,this.mutateRate);
  }


  void update(float pipeX, float pipe1Y, float pipe2Y){
    if (this.alive){
      
      this.y += vy;
      this.vy += 1*speed;
      updateImg();
      
      if (hasColided(pipeX, pipe1Y, pipe2Y)){
        this.alive = false;
        return;
      }
      Float[][] input = {{this.y,(float)this.vy,pipeX,pipe1Y,pipe2Y,this.hitboxX,this.hitboxY,pipeX+350.0}};
      Float[] output = brain.predict(input)[0];
      if (output[0]<output[1]){
        jump();
      }
      this.timeAlive += 1;


      
    }
  }

  void updateImg(){
    pushMatrix();
    translate(100,this.y);
    //rotate(PI*abs(vy)*vy/(vy*vy+21)/2);
    image(birdIMG,0,0,80,80);
    //rect (0,0,40,40);
    popMatrix();
  }

  boolean hasColided(float pipeX,float pipe1Y,float pipe2Y){
    if(this.y -this.hitboxY/2 <= 0 || this.y+this.hitboxY/2 >= 900){
      //println("ground or ceiling");
      return true;
    }
    if(pipeX <= 100 && pipeX >= -250 && (this.y+this.hitboxY/2 <= pipe2Y  || this.y+this.hitboxY/2 >= pipe1Y)){
      //println("pipe");
      return true;
      
    }
    return false;
  }
  boolean getAlive(){
    return this.alive;
  }
  void addPoint(int n){
    this.score+=n;
  }
  void jump(){
    this.vy = -20;
  }
  FullyConnectedNet getBrain(){
    return this.brain;
  }
  int calcScore(){
    return this.score*1000 + timeAlive;
  }
  int getScore(){
    return this.score;
  }
}

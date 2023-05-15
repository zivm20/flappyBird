

class FullyConnectedNet{
  
  ArrayList<Layer> weights;
  FullyConnectedNet(ArrayList<Layer> weights){
    this.weights = weights;
  }
  FullyConnectedNet(FullyConnectedNet net2){
    this.weights = new ArrayList<Layer>();
    for(Layer l: net2.getLayers()){
       if(l instanceof AffineLayer){
          this.weights.add(new AffineLayer((AffineLayer)l));
          
       }
       else if(l instanceof ReluLayer){
         this.weights.add(new ReluLayer());
       }
       else if(l instanceof SoftmaxLayer){
          this.weights.add(new SoftmaxLayer());
       }
    }
  }

  FullyConnectedNet(FullyConnectedNet net1, FullyConnectedNet net2, float pInherit1, float pInherit2, float mutateRate, float mutateAmount){
    this.weights = new ArrayList<Layer>();

    for(int i = 0; i < net1.getLayers().size(); i++){
       if(net1.getLayers().get(i) instanceof AffineLayer){
          this.weights.add(new AffineLayer((AffineLayer)net1.getLayers().get(i), (AffineLayer)net1.getLayers().get(i), pInherit1, pInherit2, mutateRate, mutateAmount));
          
       }
       else if(net1.getLayers().get(i)  instanceof ReluLayer){
         this.weights.add(new ReluLayer());
       }
       else if(net1.getLayers().get(i)  instanceof SoftmaxLayer){
          this.weights.add(new SoftmaxLayer());
       }
    }
  }

  void init(int inDim,int[] hidden_dims,int outDim,float std, float offset){
    this.weights = new ArrayList<Layer>();
    if (hidden_dims.length > 0){

    
      this.weights.add(new AffineLayer(inDim, hidden_dims[0],std,offset));
      this.weights.add(new ReluLayer());
      for (int d=1; d<hidden_dims.length-1; d++) {
        this.weights.add(new AffineLayer(hidden_dims[d], hidden_dims[d+1],std,offset));
        this.weights.add(new ReluLayer());
      }

      this.weights.add(new AffineLayer(hidden_dims[hidden_dims.length-1], outDim,std,offset));
    }
    else{
      this.weights.add(new AffineLayer(inDim, outDim,std,offset));
      
    }
    this.weights.add(new SoftmaxLayer());
    
  }
  FullyConnectedNet(int inDim,int[] hidden_dims,int outDim) {
    init(inDim,hidden_dims,outDim,1,0);
  }
  FullyConnectedNet(int inDim,int[] hidden_dims,int outDim, float std) {
    init(inDim,hidden_dims,outDim,std,0);
  }
  FullyConnectedNet(int inDim,int[] hidden_dims,int outDim, float std, float offset) {
    init(inDim,hidden_dims,outDim,std,offset);
  }

  public ArrayList<Layer> getLayers(){
    return this.weights;
  }
  public Float[][] predict(Float[][] input) {
    Float[][] output = input;
    for (Layer layer : weights) {
      output = layer.forward(output);
    }
    return output;
  }


  void mutate(float mutateRate, float mutateAmount){
    boolean mutateW = (random(100)/100 < mutateRate);
    ArrayList<Layer> newWeights = new ArrayList<Layer>();
    for(Layer w: this.weights){
      Layer tmp = w;
      if(w instanceof AffineLayer && mutateW && (random(100)/100 < mutateRate/this.weights.size())){
        tmp = new AffineLayer((AffineLayer) w);
        
        tmp.mutate(mutateRate,mutateAmount);
      }
      
      newWeights.add(tmp);
      
    }
  }

  public void train(Float[][] input, Float[][] labels, int numIterations, float learningRate) {
    int numSamples = input.length;
    for (int iteration = 0; iteration < numIterations; iteration++) {
      float loss = 0.0f;

      // Forward pass
      Float[][] output = predict(input);

      // Compute the cross-entropy loss and the gradient of the loss with respect to the output
      Float[][] gradOutput = new Float[numSamples][labels[0].length];
      for (int i = 0; i < numSamples; i++) {
        for (int j = 0; j < labels[0].length; j++) {
          loss += labels[i][j] * Math.log(output[i][j]);
          gradOutput[i][j] = labels[i][j] / output[i][j];
        }
      }

      // Backward pass
      for (int i = weights.size() - 1; i >= 0; i--) {
        gradOutput = weights.get(i).backward(gradOutput, learningRate);
      }

      // Print the loss after each iteration
      if (iteration % 100 == 0) {
        System.out.println("Iteration " + iteration + ": loss = " + (-loss / numSamples));
      }
    }
  }
}

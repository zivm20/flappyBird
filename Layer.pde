
import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

public abstract class Layer {
    protected Float[][] input;
    protected Float[][] output;

    public abstract Float[][] forward(Float[][] input);

    public abstract Float[][] backward(Float[][] gradOutput, float learningRate);
    public abstract void mutate(float mutateRate,float mutateAmount);
}

public class AffineLayer extends Layer {
    private Float[][] weights;
    private Float[] biases;



    public AffineLayer(int inputSize, int outputSize) {
        init(inputSize,outputSize,STD_,WEIGHT_CHANCE_);
    }
    public AffineLayer(int inputSize, int outputSize, Float std) {
       
        
        init(inputSize,outputSize,std,WEIGHT_CHANCE_);
    }
    public AffineLayer(int inputSize, int outputSize, Float std, float p) {
        init(inputSize,outputSize,std,p);
    }
    void init(int inputSize, int outputSize, Float std, float pWeight){
        this.weights = new Float[outputSize][inputSize];
        this.biases = new Float[outputSize];
        Random rng = new Random();
        
        for (int i = 0; i < outputSize; i++) {
            float pAddConnection = random(1);
            for (int j = 0; j < inputSize; j++){
                float p = random(1);
                if(i==j || p < pWeight){
                    this.weights[i][j] = (float)rng.nextGaussian() * std;
                }
                else if(pAddConnection < pWeight && j*pWeight/(inputSize*1.0) < pAddConnection && pAddConnection < (j+1)*pWeight/(inputSize*1.0) ){
                    this.weights[i][j] = (float)rng.nextGaussian() * std;
                }
                else{
                    this.weights[i][j] = 0.0;
                }
                
            }
            this.biases[i] = 0.0;
        }
         

    }


    public AffineLayer(AffineLayer l2){
        this.weights = l2.copyWeights();
        this.biases = l2.copyBiases();
    }

    public AffineLayer(AffineLayer l1, AffineLayer l2,float pInherit1, float pInherit2, float mutateRate, float mutateAmount){
        Float[][] l1Weights = l1.copyWeights();
        Float[][] l2Weights = l2.copyWeights();

        
        this.weights = new Float[l1.outDim()][l1.inDim()];
        Random rng = new Random();
        this.biases = new Float[l1.outDim()];
        
        for (int i = 0; i < this.weights.length; i++) {
            float pAddConnection = random(1);
            for (int j = 0; j < this.weights[0].length; j++){
                float p = random(1);
                if(p < pInherit1){
                    this.weights[i][j] = l1Weights[i][j];
                }
                else{
                    this.weights[i][j] = l2Weights[i][j];
                }
                if(!((l1Weights[i][j] == 0 && l2Weights[i][j] == 0) || (l1Weights[i][j] == 1 && l2Weights[i][j] == 1))){
                    this.weights[i][j] = this.weights[i][j] + (float)rng.nextGaussian() * mutateAmount;
                }
                else if(pAddConnection < mutateAmount && j*mutateAmount/(this.weights[0].length*1.0) < pAddConnection && pAddConnection < (j+1)*mutateAmount/(this.weights[0].length*1.0) ){
                    this.weights[i][j] = this.weights[i][j] + (float)rng.nextGaussian() * mutateAmount;
                }
                
                
            }
            biases[i] = 0.0;
        }

    }

    public int inDim(){
        return this.weights[0].length;
    }
    public int outDim(){
        return this.weights.length;
    }

    public Float[][] copyWeights(){
        Float[][] tmp = new Float[this.weights.length][this.weights[0].length];
        for (int i = 0; i < this.weights.length; i++) {
            for (int j = 0; j < this.weights[0].length; j++) {
                tmp[i][j] = this.weights[i][j];
            }
        }
        return tmp;

    }

    public Float[] copyBiases(){
        Float[] tmp = new Float[this.biases.length];
        for (int i = 0; i < this.biases.length; i++) {
            
            tmp[i]= this.biases[i];
            
        }
        return tmp;

    }

    public Float[][] forward(Float[][] input) {
        this.input = input;

        int batchSize = input.length;
        int inputSize = input[0].length;
        int outputSize = weights.length;
        Float[][] output = new Float[batchSize][outputSize];

        for (int i = 0; i < batchSize; i++) {
            for (int j = 0; j < outputSize; j++) {
                float sum = biases[j];
                for (int k = 0; k < inputSize; k++) {
                    sum += weights[j][k] * input[i][k];
                }
                output[i][j] = sum;
            }
        }

        this.output = output;
        return output;
    }

    public Float[][] backward(Float[][] gradOutput, float learningRate) {
        int batchSize = gradOutput.length;
        int inputSize = input[0].length;
        int outputSize = weights.length;

        Float[][] gradInput = new Float[batchSize][inputSize];
        Float[][] gradWeights = new Float[outputSize][inputSize];
        Float[] gradBiases = new Float[outputSize];

        for (int i = 0; i < batchSize; i++) {
            for (int j = 0; j < outputSize; j++) {
                for (int k = 0; k < inputSize; k++) {
                    gradInput[i][k] += gradOutput[i][j] * weights[j][k];
                    gradWeights[j][k] += gradOutput[i][j] * input[i][k];
                }
                gradBiases[j] += gradOutput[i][j];
            }
        }

        // update weights and biases
        for (int i = 0; i < outputSize; i++) {
            for (int j = 0; j < inputSize; j++) {
                weights[i][j] -= learningRate * gradWeights[i][j];
            }
            biases[i] -= learningRate * gradBiases[i];
        }

        return gradInput;
    }

    public void mutate(float mutateRate,float mutateAmount){
        Random rng = new Random();
        float totalMutate = 0;
        float totalWeight = 0;
        for (int i = 0; i < this.weights.length; i++) {
            for (int j = 0; j < this.weights[0].length; j++) {
              totalWeight+=weights[i][j];
              if(random(100)/100 < mutateRate){
                    float tmp =(float)rng.nextGaussian() * mutateAmount;
                    totalMutate = weights[i][j] - tmp;
                    this.weights[i][j] += tmp;
                    //println("mutated affine weight value");
                }
            }
            if(random(100)/100 < mutateRate)
                biases[i] += (float)rng.nextGaussian() * mutateAmount;
        } 
        println(totalMutate,totalWeight);
        println("--------------------------------------------");

    }
}



public class ReluLayer extends Layer {
    public Float[][] forward(Float[][] input) {
        this.input = input;

        int batchSize = input.length;
        int inputSize = input[0].length;
        Float[][] output = new Float[batchSize][inputSize];

        for (int i = 0; i < batchSize; i++) {
            for (int j = 0; j < inputSize; j++) {
                output[i][j] = Math.max(0, input[i][j]);
            }
        }

        this.output = output;
        return output;
    }

    public Float[][] backward(Float[][] gradOutput, float learningRate) {
        int batchSize = gradOutput.length;
        int inputSize = input[0].length;
        Float[][] gradInput = new Float[batchSize][inputSize];

        for (int i = 0; i < batchSize; i++) {
            for (int j = 0; j < inputSize; j++) {
                gradInput[i][j] = (input[i][j] > 0) ? gradOutput[i][j] : 0;
            }
        }

        return gradInput;
    }
    void mutate(float mutateRate,float mutateAmount){}
}

public class SoftmaxLayer extends Layer {
    public Float[][] forward(Float[][] input) {
        this.input = input;

        int batchSize = input.length;
        int inputSize = input[0].length;
        Float[][] output = new Float[batchSize][inputSize];

        for (int i = 0; i < batchSize; i++) {
            // Compute the maximum value in each input batch to prevent overflow
            float maxInput =  Collections.max(Arrays.asList(input[i]));

            // Compute the exponential of each input element and normalize by the sum of the exponentials
            float expSum = 0.0f;
            for (int j = 0; j < inputSize; j++) {
                output[i][j] = (float) Math.exp(input[i][j] - maxInput);
                expSum += output[i][j];
            }
            for (int j = 0; j < inputSize; j++) {
                output[i][j] /= expSum;
            }
        }

        this.output = output;
        return output;
    }
    void mutate(float mutateRate,float mutateAmount){}

    public Float[][] backward(Float[][] gradOutput, float learningRate) {
        int batchSize = gradOutput.length;
        int inputSize = input[0].length;
        Float[][] gradInput = new Float[batchSize][inputSize];

        for (int i = 0; i < batchSize; i++) {
            for (int j = 0; j < inputSize; j++) {
                // Compute the diagonal Jacobian matrix of the softmax function
                float softmax = output[i][j];
                float diag = softmax * (1 - softmax);

                // Compute the gradient of the loss with respect to the input using the chain rule
                float sum = 0.0f;
                for (int k = 0; k < inputSize; k++) {
                    if (k != j) {
                        sum += output[i][k] * gradOutput[i][k];
                    }
                }
                gradInput[i][j] = diag * (gradOutput[i][j] - sum);
            }
        }

        return gradInput;
    }
}

final int N = 120;
final int iter = 10;
int SCALE = 5;

int IX(int x, int y){
  x = constrain(x, 0, N-1);
  y = constrain(y, 0, N-1);
  return x + y * N;
}

class Fluid{
  int size;
  float dt;
  float diff;
  float visc;
  
  float[] s;
  float[] density;
  
  float[] Vx;
  float[] Vy;
  
  float[] Vx0;
  float[] Vy0;
  
  Fluid(float dt, float diffusion, float viscosity) {
    this.size = N;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;
    
    this.s = new float[N*N];
    this.density = new float[N*N];
    
    this.Vx = new float[N*N];
    this.Vy = new float[N*N];
    
    this.Vx0 = new float[N*N];
    this.Vy0 = new float[N*N];
  }
  
  void step() {
    float visc = this.visc;
    float diff = this.diff;
    float dt = this.dt;
    float[] Vx = this.Vx;
    float[] Vy = this.Vy;
    float[] Vx0 = this.Vx0;
    float[] Vy0 = this.Vy0;
    float[] s = this.s;
    float[] density = this.density;
    
    diffuse(1, Vx0, Vx, visc, dt);
    diffuse(2, Vy0, Vy, visc, dt);
    
    project(Vx0, Vy0, Vx, Vy);
    
    advect(1, Vx, Vx0, Vx0, Vy0, dt);
    advect(2, Vy, Vy0, Vx0, Vy0, dt);
    
    project(Vx, Vy, Vx0, Vy0);
    
    diffuse(0, s, density, diff, dt);
    advect(0, density, s, Vx, Vy, dt);
  }
  
  void addDensity(int x, int y, float amount) {
    int index = IX (x, y);
    this.density[index] += amount;
  }
  
  void addVelocity(int x, int y, float amountX, float amountY) {
    int index = IX (x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;
  }
  
  void renderD() {
    for (int i = 0; i < N; i ++ ) {
      for (int j = 0; j < N; j ++) {
        float x = i * SCALE;
        float y = j * SCALE;
        float d = this.density[IX(i,j)];
        fill(255-d);
        noStroke();
        square(x,y,SCALE);
      }
    }
  }
  
  void fadeD() {
    for (int i = 0; i < this.density.length; i++) {
      float d = density[i];
      density[i] = constrain(d-1, 0, 255);
    }
  }
}

import processing.opengl.*;

ArrayList<Box> boxs;
Table table;
float inc = 2;
PImage[] images = new PImage[15];
PShape globe;


void setup(){
  table = loadTable("Covid_DongJakGu.csv","header,csv");
  size(1280,720,P3D);
  stroke(10);
  strokeWeight(0.04);

  for (int i = 0; i<images.length; i++){
    images[i] = loadImage(i+1+".png");
  }
  textureMode(NORMAL);
  textureWrap(CLAMP);

  
  Covid[] covid = new Covid[15];
  for(int i = 1; i<16;i++){
    covid[i-1] = new Covid(table.getIntColumn(i));
  }
  
  boxs = new ArrayList<Box>();
  for(int i = 0 ; i <15 ; i++){
    boxs.add(new Box(covid[i].Comfirmed,covid[i].Recovery,i));
  }
  

}

class Covid{
  int Comfirmed;
  int Recovery;
  
  Covid(int[] arr){
    Comfirmed = arr[0];
    Recovery = arr[1];
  }
}



void draw(){
  background(255, 255, 255);
  lights(); 
  textSize(50);
  fill(0);
  text("COVID-19 in DongJak-gu",50,80);
  String str = "The size of the block represents the number of confirmed cases.\nBlue means the area where every confirmed person is completely cured.\nRed means that there are still confirmed patients under treatment.\nThe opacity of the color means the number of people.\nIn the case of opaque red, there are many confirmed cases under treatment.\nIn the case of opaque blue, there are many confirmed cases.";
  textSize(18);
  text(str,50,120);


  for (int i = boxs.size() -1; i >=0; i--){
    Box box = boxs.get(i);
    box.move();
    box.display();
  }
 
}

class Box {
  float xpos;
  float ypos;
  float xspeed = random(-3, 3);
  float yspeed = random(-3, 3);
  float rspeed = random(-3, 3);
  int xdirection = 1;
  int ydirection = 1;
  int rdirection = 1;
  int size;
  int recovery;
  int imageNum;
  
   Box(int s, int r,int num){
    xpos = random(0,1280);
    ypos = random(0,720);
    size = s;
    recovery = r;
    imageNum = num;
  }


  void move(){
    inc+=0.1;
    xpos = xpos + (xspeed * xdirection);
    ypos = ypos + (yspeed * ydirection);
    rspeed = rspeed + rdirection;
    if (xpos > width || xpos < 0){
      xdirection *= -1; 
      rdirection *= -1;
    }
    if (ypos > height || ypos < 0){
      ydirection *= -1;
      rdirection *= -1;
    }
  }
  
  void display(){
    pushMatrix();
    
    translate(xpos, ypos);
    rotateX(size);
    rotateY(size);
    scale(size*2);
    
    if(size==recovery){
      fill(random(127,255),0,127,recovery*25);
      //fill(#2E9AFE, recovery*25);
    }
    else {
      fill(0,66,random(100,255),(size-recovery)*75);
      //fill(#FA5858, (size-recovery)*75);
    }
    
    TexturedCube(imageNum);
    popMatrix();
    
  }

}

void TexturedCube(int num){
 
  beginShape(QUADS);
  texture(images[num]);
  
  // +Z "front" face
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, 1, 0);
  vertex( 1,  1,  1, 1, 1);
  vertex(-1,  1,  1, 0, 1);
  endShape();
  
  beginShape(QUADS);
  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1,  1, -1, 1, 1);
  vertex( 1,  1, -1, 0, 1);
  endShape();
  
  beginShape(QUADS);
  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex(-1,  1, -1, 0, 1);
  endShape();
  
  beginShape(QUADS);
  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1,  1, 1, 1);
  vertex(-1, -1,  1, 0, 1);
  endShape();
  
  beginShape(QUADS);
  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1,  1, -1, 1, 1);
  vertex( 1,  1,  1, 0, 1);
  endShape();
  
  beginShape(QUADS);
  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, 1, 0);
  vertex(-1,  1,  1, 1, 1);
  vertex(-1,  1, -1, 0, 1);

  endShape();
}

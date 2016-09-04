
import processing.opengl.*;
import processing.video.*;

//import com.jogamp.opengl.*;

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;
//import processing.opengl.*;
 
Capture video;
//PGraphicsOpenGL pgl;
//GL gl;
PJOGL pgl;
GL2ES2 gl;

void setup() {
    size(1024, 768, P3D);
    //pgl = (PGraphicsOpenGL) g;
    //gl = pgl.gl;
    pgl = (PJOGL) beginPGL();
    gl = pgl.gl.getGL2ES2();
    frameRate(30);
 
    //video = new Capture(this, width, height, 30);
    video = new Capture(this, 160, 120,30);
    video.start();
}

 void captureEvent(Capture c) {
  c.read();
}

void draw(){
  noFill();
  lights();
  strokeWeight(4);
  background(0);
  
  if (video.available()){
    video.read();
    video.loadPixels();
    background(0);
 
    //pgl.beginGL();
    pgl = (PJOGL) beginPGL();  
    
    gl.glDisable(GL.GL_DEPTH_TEST);
    gl.glEnable(GL.GL_BLEND);
    gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE);
 
    pushMatrix();
    translate(width, height, 0);
    rotateY(radians(mouseX-(width)));
    rotateX(radians(-(mouseY-(height))));
    translate(-width, -height, 0);
      
    int index = 0;
   
      for(int y = 0; y < video.height; y+=5){
        beginShape();
        for(int x = 0; x < video.width; x++){
          int pixelValue = video.pixels[x+(y*video.width)];
          stroke(red(pixelValue), green(pixelValue), blue(pixelValue), 255);
          vertex (x*2, y*2, (brightness(pixelValue)*2)-100);
          index++;
        }
        endShape();
       }
    //pgl.endGL();
    endPGL();
    popMatrix();
    }
}
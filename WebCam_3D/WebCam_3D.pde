
import processing.opengl.*;
import processing.video.*;
import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;
 
Capture video;
PJOGL pgl;
GL2ES2 gl;

void setup(){
    size(1024, 768, P3D);
    pgl = (PJOGL) beginPGL();
    gl = pgl.gl.getGL2ES2();
    
    //Initialize WebCam
    video = new Capture(this, 160, 120); 
    video.start();
}

 void captureEvent(Capture c) {
  c.read();
}

void draw(){
  noFill();
  lights();
  strokeWeight(3);
  background(0);
  
  if(video.available()){
    video.read();
    video.loadPixels();
    background(0);
    pgl = (PJOGL) beginPGL();  
    /*
    Enable or Disable server-side GL capabilities.
    
    GL_DEPTH_TEST: do depth comparisions and update the depth buffeer. Even if 
              the deep buffer exists and the depth mask is non-zero, the deep
              buffer is not updated if the depth test is disable
    
    GL_BLEND: blend the computed fragment color values with the values in the 
              color buffers.
    
    glBlendFunc: Specify pixel arithmetic (sfactor, dfactor)
              sfactor, dfactor - Specifies how the red, green, blue and alpha source 
                                  and destination blending factors are computed.   
    */    
    gl.glDisable(GL.GL_DEPTH_TEST);
    gl.glEnable(GL.GL_BLEND);
    gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
 
    pushMatrix();
    
    /* Move image with the mouse */
    translate(width, height, 0);
    rotateY(radians(mouseX-(width)));
    rotateX(radians(-(mouseY-(height))));
    translate(-width, -height, 0);
    
    for(int y = 0; y < video.height; y+= 1){
      beginShape();
      for(int x = 0; x < video.width; x+= 1){
        int pixelValue = video.pixels[x + (y*video.width)];
        stroke(red(pixelValue), green(pixelValue), blue(pixelValue), 255);
        vertex (x*5, y*5, (brightness(pixelValue)*2)-100);         
      } //End For
      endShape();
    } //End For
    endPGL();
    popMatrix();
    }// End if 
}
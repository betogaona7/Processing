/** 
The WebCam_3D program simply displays 3D image from the WebCam

@author Alberto Gaona
@version 1.0
@since 2016-09-04
**/ 

import processing.video.*;

/*
Open Graphics Library is a cross-language, cross platform API for rendering
2D and 3D vector graphics. The API is typically used to interact with a graphic
processing unit (GPU), to achieve hardware-accelerated.
*/

import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;
 
Capture video;
PJOGL pgl;
GL2ES2 gl;

void setup(){
  /*
  P3D is a default render (Process of generating an image from 3D model by
  means of computer programs). 
  */
  fullScreen(P3D);
  
  pgl = (PJOGL) beginPGL(); // Provide full access to the APIs in the OpenGL
  gl = pgl.gl.getGL2ES2();  // Casts to the GL2ES2 interface 
    
  /* 
  Capture is Datatype for storing and manipulating video frames from an attached 
  capture device as camera.
  Capture(parent, width frame, height frame)
  */
  video = new Capture(this, 160, 120);
  video.start(); // Starts capturing frames from the selected device.
}

 void captureEvent(Capture c) {
  c.read();
}

void draw(){
  noFill(); //Disables filling geometry.
  /*
  Sets the default ambient light, directional light, falloff, and specular values. 
  The defaults are ambientLight(128, 128, 128) and directionalLight(128, 128, 128, 0, 0, -1), 
  lightFalloff(1, 0, 0), and lightSpecular(0, 0, 0). Lights need to be included in the draw() 
  to remain persistent in a looping program. Placing them in the setup() of a looping program 
  will cause them to only have an effect the first time through the loop. 
  */
  lights();
  /*
  Sets the width of the stroke used for lines, points, and the border around shapes. 
  All widths are set in units of pixels. 
  */
  strokeWeight(3);
  background(0);
  
  if(video.available()){ // Return true when a new video frame is available to read.
    video.read();        // Reads the current video frame
    /*
    Loads a snapshot of the current display window into the pixels[] array. This function must 
    always be called before reading from or writing to pixels[]. Subsequent changes to display 
    window will not be reflected in pixels until loadPixels is called again.
    */ 
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
    /*
    Pushes the current transformation matrix onto the matrix stack.
    The pushMatrix() function saves the current coordinate system to the stack and 
    popMatrix() restore the prior coordinate system.
    
    push and pop Matrix are use in conjuction with the other transformation functions
    and may be embedded to control the scope of the transformation.
    */
    pushMatrix();
    /* 
    Move image with the mouse:
    
    translate: Specifies an amount to displace objects within the display window. The 
    x parameter specifies left/right translation, the y parameter specifies up/down 
    translation, and the z parameter specifies translations toward/away from the screen.
    */ 
    translate(width, height, 0);
    
    //Rotates around the y-axis and x-axis the amount specified by the angle parameter.
    rotateY(radians(mouseX-(width))); 
    rotateX(radians(-(mouseY-(height))));
    translate(-width, -height, 0);
    
    for(int y = 0; y < video.height; y+= 1){
      /*
      Using the beginShape() and endShape() functions allow creating more complex forms. 
      beginShape() begins recording vertices for a shape and endShape() stops recording. 
      The value of the kind parameter tells it which types of shapes to create from the 
      provided vertices. With no mode specified, the shape can be any irregular polygon. 
      */
      beginShape();
      for(int x = 0; x < video.width; x+= 1){
        
        int pixelValue = video.pixels[x + (y*video.width)];
        /* 
        Sets the color used to draw lines and borders around shapes. This color is either 
        specified in terms of the RGB or HSB.
        
        stroke(hue value, saturation value, brightness value, opacity of the stroke)
        */
        stroke(red(pixelValue), green(pixelValue), blue(pixelValue), 255);
        /*
        All shapes are constructed by connecting a series of vertices.
        vertex() is used to specify the vertex coordinates for points, lines, triangles, 
        quads, and polygons. It is used exclusively within the beginShape() and endShape() 
        functions.
        
        vertex(x, y, z)
        */
        vertex (x*5, y*5, (brightness(pixelValue)*2)-100);         
      } 
      endShape();
    }
    endPGL();
    popMatrix();
    } 
}
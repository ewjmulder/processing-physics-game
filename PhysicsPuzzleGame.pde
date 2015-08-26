/**
 * Physics based game inspired by the 90's game 'The Incredible Machine'.<br />
 * (C) Erik Mulder 2015 - Apache Licence 2.0
 */
import org.jbox2d.util.nonconvex.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.testbed.*;
import org.jbox2d.collision.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.p5.*;
import org.jbox2d.dynamics.*;

public class Util {

  public static final int GRID_SIZE = 20;

  // Should be set before any util methods are called that need this.
  public static Physics physics;
  
//  public static 

}
 
boolean debug = true;

Level currentLevel;

// The physics engine.
Physics physics; 

// a handler that will detect collisions
CollisionDetector detector; 

AudioCenter audioCenter;

// this is used to remember that the user 
// has triggered the audio on iOS... see mousePressed below
boolean userHasTriggeredAudio = false;

void setup() {
  console.log("setup");
  size(1000, 700);
  frameRate(60);
  audioCenter = new AudioCenter(new Maxim(this));

  /*
   * Set up a physics world. This takes the following parameters:
   * 
   * parent The PApplet this physics world should use
   * screenW The screen width where the physics world is in
   * screenH The screen height where the physics world is in
   * gravX The x component of gravity, in meters/sec^2
   * gravY The y component of gravity, in meters/sec^2
   * screenAABBWidth The world's width, in pixels - should be significantly larger than the area you intend to use
   * screenAABBHeight The world's height, in pixels - should be significantly larger than the area you intend to use
   * borderBoxWidth The containing box's width - should be smaller than the world width, so that no object can escape
   * borderBoxHeight The containing box's height - should be smaller than the world height, so that no object can escape
   * pixelsPerMeter Pixels per physical meter
   */
  physics = new Physics(this, 700, 700, 0, -10, width*2, height*2, 700, 700, 100);
  Util.physics = physics;
  // This overrides the debug render of the physics engine with the method gameRenderer
  if (!debug) {
    physics.setCustomRenderingMethod(this, "gameRenderer");
  }
  physics.setDensity(10.0);
  
  currentLevel = new Level(1, "Demo", "This is a description", loadImage("background/distribution_center.jpg"));
  currentLevel.addFixedItem(new Item(ItemType.WOODEN_BEAM, 4, 16));
  currentLevel.addFixedItem(new Item(ItemType.WOODEN_BEAM, 15, 16));
  currentLevel.addFixedItem(new Item(ItemType.SOCCER_BALL, 14, 6));


//  woodenBeamImage = loadImage("items/wooden_beam.png");
//  ballImage = loadImage("items/soccer_ball.png");


  // circle parameters are center x,y and radius
  //droid = physics.createCircle(400, 100, ballSize/2);

  // sets up the collision callbacks
  detector = new CollisionDetector (physics, this);

/*  droidSound = maxim.loadFile("droid.wav");
  wallSound = maxim.loadFile("wall.wav");

  droidSound.setLooping(false);
  droidSound.volume(0.25);
  wallSound.setLooping(false);
  wallSound.volume(0.25);
  // now an array of crate sounds
  crateSounds = new AudioPlayer[crates.length];
  for (int i=0;i<crateSounds.length;i++) {
    crateSounds[i] = maxim.loadFile("crate2.wav");
    crateSounds[i].setLooping(false);
    crateSounds[i].volume(0.25);
  }*/
}

void draw() {
  // Draw the background image over the whole screen.
  image(currentLevel.getBackgroundImage(), 0, 0, width, height);

  // Render the game world based on the data in the physics engine.
  gameRenderer(physics.getWorld());
}

/** on iOS, the first audio playback has to be triggered
* directly by a user interaction
* so the first time they tap the screen, 
* we play everything once
* we could be nice and mute it first but you can do that... 
*/
void mousePressed() {
  if (!userHasTriggeredAudio) {
    //player.play();
    userHasTriggeredAudio = true;
  }
}

void mouseDragged()
{

}

// when we release the mouse, apply an impulse based 
// on the distance from the droid to the catapult
void mouseReleased()
{
  Vec2 impulse = new Vec2();
  impulse.set(startPoint);
  impulse = impulse.sub(droid.getWorldCenter());
  impulse = impulse.mul(50);
  droid.applyImpulse(impulse, droid.getWorldCenter());
}

// this function renders the physics scene.
// this can either be called automatically from the physics
// engine if we enable it as a custom renderer or 
// we can call it from draw
void gameRenderer(World world) {
  stroke(0);
  
  for (Item staticItem : currentLevel.getFixedItems()) {
    Body staticBody = staticItem.getBody();
    Vec2 position = physics.worldToScreen(staticBody.getWorldCenter());
    float angle = physics.getAngle(staticBody);
    pushMatrix();
    translate(position.x, position.y);
    rotate(-radians(angle));
    image(staticItem.getImage(), -staticItem.getScreenWidth() / 2, -staticItem.getScreenHeight() / 2, staticItem.getScreenWidth(), staticItem.getScreenHeight());
    popMatrix();
  }
/*
  // get the droids position and rotation from
  // the physics engine and then apply a translate 
  // and rotate to the image using those values
  // (then do the same for the crates)
  Vec2 screenDroidPos = physics.worldToScreen(droid.getWorldCenter());
  float droidAngle = physics.getAngle(droid);
  pushMatrix();
  translate(screenDroidPos.x, screenDroidPos.y);
  rotate(-radians(droidAngle));
  image(ballImage, -ballSize / 2, -ballSize / 2, ballSize, ballSize);
  popMatrix();


  Vec2 worldCenter = woodenBeam.getWorldCenter();
  Vec2 cratePos = physics.worldToScreen(worldCenter);
  float crateAngle = physics.getAngle(woodenBeam);
  pushMatrix();
  translate(cratePos.x, cratePos.y);
  rotate(-crateAngle);
  image(woodenBeamImage, -100, -10, 200, 20);
  popMatrix();*/

}

// This method gets called automatically when 
// there is a collision
void collision(Body b1, Body b2, float impulse)
{/*
  if ((b1 == droid && b2.getMass() > 0)
    || (b2 == droid && b1.getMass() > 0))
  {
    if (impulse > 1.0)
    {
      score += 1;
    }
  }
  
  if (impulse > 15.0){ //only play a sound if the force is strong enough ... otherwise we get too many sounds playing at once
  
    // test for droid
    if (b1.getMass() == 0 || b2.getMass() == 0) {// b1 or b2 are walls
      // wall sound
      //println("wall "+(impulse / 1000));
      wallSound.cue(0);
      wallSound.speed(impulse / 1000);// 
      wallSound.play();
    }
    if (b1 == droid || b2 == droid) { // b1 or b2 are the droid
      // droid sound
      //println("droid");
      droidSound.cue(0);
      droidSound.speed(impulse / 1000);
      droidSound.play();
    }
    for (int i=0;i<crates.length;i++) {
      if (b1 == crates[i] || b2 == crates[i]) {// its a crate
        crateSounds[i].cue(0);
        crateSounds[i].speed(0.25 + (impulse / 250));// 10000 as the crates move slower??
        crateSounds[i].play();
      }
    }
  
  }*/
  //
}


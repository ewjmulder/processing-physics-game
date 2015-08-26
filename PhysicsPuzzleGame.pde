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

// Utility class to share general information about the game to all classes.
public class Util {
  // The grid size of the game (in pixels).
  public static final int GRID_SIZE = 20;

  // Should be set before any util methods are called that need this.
  public static Physics physics;
}
 
// Main Game Controller.
GameController gameController;
// Audio center to play sounds.
AudioCenter audioCenter;
// The physics engine.
Physics physics;
// A handler that will detect collisions
CollisionDetector detector; 
// Whether or not to draw the debug shapes.
boolean debug;


// The current level that is played.
Level currentLevel;
//TODO: userHasTriggeredAudio -> for iOS

void setup() {
  console.log("setup");
  gameController = new GameController();
  
  // Initialize general settings.
  debug = true;
  
  size(1000, 700);
  frameRate(gameController.getFrameRate());

  audioCenter = new AudioCenter(new Maxim(this));
  //TODO: Add sounds to AudioCenter
  //audioCenter.addSound(SoundType.PING, "sfx/ping.wav");

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
  // Set the physics object on the Util, so it can be used by other classes.
  Util.physics = physics;
  // This overrides the debug render of the physics engine with the method gameRenderer
  if (!debug) {
    physics.setCustomRenderingMethod(this, "gameRenderer");
    //TODO: Enable/disable debug, for disabling use: unsetCustomRenderingMethod
  }
  // Density of the objects.
  //TODO: vary per item.
  physics.setDensity(10.0);
  
  // Create the current level.
  //TODO: list of levels to go through with one a current level.
  Inventory inventory = new Inventory();
  inventory.add(ItemType.WOODEN_BEAM, 3);
  inventory.add(ItemType.GOAL);
  inventory.add(ItemType.DIAGONAL_BEAM, 10);
  inventory.add(ItemType.SOCCER_BALL, 2);

  Level level1 = new Level(1, "Demo", "This is a description", loadImage("background/distribution_center.jpg"), inventory);
  level1.addFixedItem(new Item(ItemType.DIAGONAL_BEAM, 10, 20));
  level1.addFixedItem(new Item(ItemType.SOCCER_BALL, 12, 16));
  level1.addFixedItem(new Item(ItemType.GOAL, 32, 18));

  gameController.addLevel(level1);

  currentLevel = gameController.getLevel(1);

  // Set up the collision callbacks
  detector = new CollisionDetector(physics, this);
}

// Get the physics engine step size in seconds (or a fraction of that).
float getStepSize() {
  return gameController.getStepSize();
}

void draw() {
  // Draw the background image over the whole screen.
  image(currentLevel.getBackgroundImage(), 0, 0, width, height);

  if (currentLevel != null) {
    drawInventory();  
  } else {
    drawMenu();
  }

  // Render the game world based on the data in the physics engine.
  gameRenderer(physics.getWorld());
}

void drawInventory() {
  int playingFieldWidth = 700;
  int marginLeft = 30;
  int marginTop = 50;
  int itemMargin = 25;
  PFont font = createFont("Arial", 16, true);
  textFont(font, 24);
  text("Inventory", playingFieldWidth + marginLeft, marginTop);
  int inventoryX = playingFieldWidth + marginLeft;
  int inventoryY = marginTop + itemMargin;
  for (ItemType itemType : currentLevel.getInventory().getAllTypes()) {
    text("" + currentLevel.getInventory().getAmountInInventory(itemType), inventoryX, inventoryY + itemType.getImage().height / 2);
    image(itemType.getImage(), inventoryX + 30, inventoryY);
    inventoryY += itemType.getImage().height + itemMargin;
  }
}

/** on iOS, the first audio playback has to be triggered
* directly by a user interaction
* so the first time they tap the screen, 
* we play everything once
* we could be nice and mute it first but you can do that... 
*/
void mousePressed() {
  gameController.togglePlay();
  /*
  if (!userHasTriggeredAudio) {
    //player.play();
    userHasTriggeredAudio = true;
  }*/
}

void mouseDragged()
{

}

// when we release the mouse, apply an impulse based 
// on the distance from the droid to the catapult
void mouseReleased()
{
/*
  Vec2 impulse = new Vec2();
  impulse.set(startPoint);
  impulse = impulse.sub(droid.getWorldCenter());
  impulse = impulse.mul(50);
  droid.applyImpulse(impulse, droid.getWorldCenter());
  */
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
    float angle = physics.getAngle(staticBody) - degrees(staticBody.getAngle());
    pushMatrix();
    translate(position.x, position.y);
    rotate(-radians(angle));
    image(staticItem.getImage(), -staticItem.getScreenWidth() / 2, -staticItem.getScreenHeight() / 2, staticItem.getScreenWidth(), staticItem.getScreenHeight());
    popMatrix();
  }
}

// This method gets called automatically when 
// there is a collision
void collision(Body b1, Body b2, float impulse)
{
  /*
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


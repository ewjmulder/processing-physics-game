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

// Control buttons
PImage play, play_bw, pause, pause_bw, stop, stop_bw, fastForward, fastForward_bw, rewind, rewind_bw;
int playX, playY, pauseX, pauseY, stopX, stopY, fastForwardX, fastForwardY, rewindX, rewindY;

// Data needed for dragging.
Item itemDragged = null;
int itemMargin = 10;
int itemBoxSize = 75;
int inventoryItem1TopLeftX;
int inventoryItem1TopLeftY;

//TODO: userHasTriggeredAudio -> for iOS

//FIXME: Somehow the polygon - circle bug is still lingering. Not really clear when it is triggered. Possible workaround: detect and immediately fix? Or js debugging for hardcore box2d lovers...

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
  inventory.add(ItemType.WOODEN_BEAM, 2);

  Level level1 = new Level(1, "Demo", "This is a description", loadImage("background/distribution_center.jpg"), inventory);
  level1.addFixedItem(new Item(ItemType.DIAGONAL_BEAM, 1, 4));  
  Item ball = new Item(ItemType.SOCCER_BALL, 2, 1);
  Item goal = new Item(ItemType.GOAL, 28, 5);
  level1.addFixedItem(ball);
  level1.addFixedItem(goal);
  level1.setGoalCollision(ball, goal);

  gameController.addLevel(level1);

  gameController.playLevel(1);

  // Set up the collision callbacks
  detector = new CollisionDetector(physics, this);
  
  int buttonSpacing = 50;
  int buttonY = 40;
  
  playX = 700 + 40;
  playY = buttonY;
  play = loadImage("buttons/play.png");
  play_bw = loadImage("buttons/play_bw.png");
  
  pauseX = playX + buttonSpacing;
  pauseY = buttonY;
  pause = loadImage("buttons/pause.png");
  pause_bw = loadImage("buttons/pause_bw.png");

  stopX = pauseX + buttonSpacing;
  stopY = buttonY;
  stop = loadImage("buttons/stop.png");
  stop_bw = loadImage("buttons/stop_bw.png");

  fastForwardX = stopX + buttonSpacing;
  fastForwardY = buttonY;
  fastForward = loadImage("buttons/fast_forward.png");
  fastForward_bw = loadImage("buttons/fast_forward_bw.png");

  rewindX = fastForwardX + buttonSpacing;
  rewindY = buttonY;
  rewind = loadImage("buttons/rewind.png");
  rewind_bw = loadImage("buttons/rewind_bw.png");
}

// Get the physics engine step size in seconds (or a fraction of that).
float getStepSize() {
  return gameController.getStepSize();
}

// Get the physics engine number of iterations per step.
float getIterationsPerStep() {
  return gameController.getIterationsPerStep();
}

void draw() {
  if (gameController.isPlaying()) {
    // Draw the background image over the whole screen.
    image(gameController.getCurrentLevel().getBackgroundImage(), 0, 0, width, height);
    drawInventory();  
  } else {
    drawMenu();
  }
  
  if (itemDragged != null) {
    image(itemDragged.getImage(), getGridX(mouseX) * Util.GRID_SIZE, getGridY(mouseY) * Util.GRID_SIZE);
  }


  // Render the game world based on the data in the physics engine.
  gameRenderer(physics.getWorld());
}

int getGridX(int screenX) {
  return (int)(screenX / Util.GRID_SIZE);
}

int getGridY(int screenY) {
  return (int)(screenY / Util.GRID_SIZE);
}

void drawInventory() {
  int playingFieldWidth = 700;
  noStroke();
  fill(255, 200);
  rect(playingFieldWidth, 0, 300, 700);

  imageMode(CENTER);
  if (gameController.canPlay()) {
    image(play, playX, playY);
  } else {
    image(play_bw, playX, playY);
  }
  if (gameController.canPause()) {
    image(pause, pauseX, pauseY);
  } else {
    image(pause_bw, pauseX, pauseY);
  }
  if (gameController.canStop()) {
    image(stop, stopX, stopY);
  } else {
    image(stop_bw, stopX, stopY);
  }
  if (gameController.canRewind()) {
    image(rewind, rewindX, rewindY);
  } else {
    image(rewind_bw, rewindX, rewindY);
  }
  if (gameController.canFastForward()) {
    image(fastForward, fastForwardX, fastForwardY);
  } else {
    image(fastForward_bw, fastForwardX, fastForwardY);
  }
  imageMode(CORNER);

  int marginLeft = 25;
  int marginTop = 150;
  PFont font = createFont("Arial", 16, true);
  textFont(font, 24);
  fill(0);
  text("Inventory", playingFieldWidth + marginLeft, marginTop);
  int inventoryX = playingFieldWidth + marginLeft;
  int inventoryY = marginTop + itemMargin;
  inventoryItem1TopLeftX = inventoryX + 35;
  inventoryItem1TopLeftY = inventoryY;
  for (ItemType itemType : gameController.getCurrentLevel().getInventory().getAllTypes()) {
    fill(0);
    text("" + gameController.getCurrentLevel().getInventory().getAmountInInventory(itemType), inventoryX, inventoryY + itemBoxSize / 2 + 10);
    noFill();
    stroke(0);
    strokeWeight(3);
    rect(inventoryX + 35, inventoryY, itemBoxSize, itemBoxSize);
    PImage img = itemType.getImage();
    float imageWidth, imageHeight;
    if (img.width > img.height) {
      imageWidth = itemBoxSize;
      imageHeight = img.height / img.width * itemBoxSize;
    } else {
      imageWidth = img.width / img.height * itemBoxSize;
      imageHeight = itemBoxSize;
    }
    image(img, inventoryX + 35 + (itemBoxSize - imageWidth) / 2, inventoryY + (itemBoxSize - imageHeight) / 2, imageWidth, imageHeight);
    inventoryY += itemBoxSize + itemMargin;
  }
}

void drawMenu() {
  //TODO: menu
}

/** on iOS, the first audio playback has to be triggered
* directly by a user interaction
* so the first time they tap the screen, 
* we play everything once
* we could be nice and mute it first but you can do that... 
*/
void mousePressed() {
  int buttonRadius = 23;
  if (dist(mouseX, mouseY, playX, playY) <= buttonRadius) {
    gameController.play();
  }
  if (dist(mouseX, mouseY, pauseX, pauseY) <= buttonRadius) {
    gameController.pause();
  }
  if (dist(mouseX, mouseY, stopX, stopY) <= buttonRadius) {
    gameController.stop();
  }
  if (dist(mouseX, mouseY, rewindX, rewindY) <= buttonRadius) {
    gameController.rewind();
  }
  if (dist(mouseX, mouseY, fastForwardX, fastForwardY) <= buttonRadius) {
    gameController.fastForward();
  }
  if (mouseX >= 0 && mouseX <= 700) {
    gameController.togglePlay();
  }

  if (gameController.isPlaying()) {
    Inventory inventory = gameController.getCurrentLevel().getInventory();
    for (int itemIndex = 0; itemIndex < inventory.countTypes(); itemIndex++) {
      if (mouseX >= inventoryItem1TopLeftX  &&
          mouseX <= inventoryItem1TopLeftX + itemBoxSize &&
          mouseY >= inventoryItem1TopLeftY + itemIndex * (itemBoxSize + itemMargin) &&
          mouseY <= inventoryItem1TopLeftY + itemIndex * (itemBoxSize + itemMargin) + itemBoxSize) {
        ItemType itemType = inventory.getAllTypes().get(itemIndex);        
        if (inventory.getAmountInInventory(itemType) > 0) {
          itemDragged = inventory.use(itemType);
        }
      }
    }
  }
  /*
  if (!userHasTriggeredAudio) {
    //player.play();
    userHasTriggeredAudio = true;
  }*/
}

void mouseDragged() {
  
}

// when we release the mouse, apply an impulse based 
// on the distance from the droid to the catapult
void mouseReleased() {
  if (itemDragged != null) {
    int gridX = getGridX(mouseX);
    int gridY = getGridY(mouseY);
    console.log("gridX: " + gridX);
    console.log("itemDragged.getGridWidth(): " + itemDragged.getGridWidth());
    console.log("gridY: " + gridY);
    console.log("itemDragged.getGridHeight(): " + itemDragged.getGridHeight());
    if (gridX + itemDragged.getGridWidth() < 35 && gridY + itemDragged.getGridHeight() < 35) {
      itemDragged.setPlaceOnGrid(gridX, gridY);
    } else {
      // Not in playing field, return to inventory.
      gameController.getCurrentLevel().getInventory().stopUsing(itemDragged);
    }
    // Either way, the dragging is done.
    itemDragged = null;
  }
}

// this function renders the physics scene.
// this can either be called automatically from the physics
// engine if we enable it as a custom renderer or 
// we can call it from draw
void gameRenderer(World world) {
  stroke(0);
  
  for (Item staticItem : gameController.getCurrentLevel().getItemsInSmulation()) {
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
void collision(Body body1, Body body2, float impulse) {
  Item item1 = gameController.getItem(body1);
  Item item2 = gameController.getItem(body2);
  if (item1 != null && item2 != null) {
    if (gameController.getCurrentLevel().isGoalCollision(item1, item2)) {
      console.log("Yippie, goal reached!");
    }
  }
  
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


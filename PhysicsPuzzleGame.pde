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
// Whether the curtain opening is still in progress.
//boolean curtainOpen = false; //SANDBOX
boolean curtainOpen = true; //SANDBOX
boolean curtainMoving = false;
int curtainProgress = 0;
PImage curtainLeft, curtainRight, logo;

int initMillis;
//boolean audioFirstLevelStarted = false; //SANDBOX
boolean audioFirstLevelStarted = true; //SANDBOX
boolean wonTheGame = false;

// Control buttons
PImage play, play_bw, pause, pause_bw, stop, stop_bw, fastForward, fastForward_bw, rewind, rewind_bw;
int playX, playY, pauseX, pauseY, stopX, stopY, fastForwardX, fastForwardY, rewindX, rewindY;
// Other buttons
PImage reset, reset_bw, debug, debug_bw, menu, menu_bw;
int resetX, resetY, debugX, debugY, menuX, menuY;


// Data needed for dragging.
Item itemDragged = null;
int dragAnchorDeltaX = 0;
int dragAnchorDeltaY = 0;
int itemMargin = 10;
int itemBoxSize = 75;
int inventoryItem1TopLeftX;
int inventoryItem1TopLeftY;

int levelCompletedStart = 0;
boolean levelCompleted = false;

//TODO: userHasTriggeredAudio -> for iOS

//FIXME: Somehow the polygon - circle bug is still lingering. Not really clear when it is triggered. Possible workaround: detect and immediately fix? Or js debugging for hardcore box2d lovers...

void setup() {
  console.log("setup");
  gameController = new GameController(this);

  size(1000, 700);
  frameRate(gameController.getFrameRate());

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

  // Density of the objects.
  //TODO: vary per item.
  physics.setDensity(10.0);

  gameController.init();    

  initMillis = millis();

  audioCenter = new AudioCenter(new Maxim(this));
  audioCenter.addSound(SoundType.MUSIC_LEVEL_1, "sound/level1.wav");
  audioCenter.addSound(SoundType.MUSIC_LEVEL_2, "sound/level2.wav");
  audioCenter.addSound(SoundType.MUSIC_LEVEL_3, "sound/level3.wav");
  audioCenter.addSound(SoundType.HIT_WOOD, "sound/hit_wood.wav");
  audioCenter.addSound(SoundType.HIT_TRAMPOLINE, "sound/hit_trampoline.wav");
  audioCenter.addSound(SoundType.CHEERING, "sound/cheering.wav");
  audioCenter.addSound(SoundType.YOU_WON, "sound/you_won.wav");
  audioCenter.addSound(SoundType.YOU_WON_CHEERING, "sound/you_won_cheering.wav");
  
  LevelDefinitions.addLevelsToGameController(gameController);

//  gameController.playLevel(1); //SANDBOX
  gameController.playLevel(4); //SANDBOX

  // Set up the collision callbacks
  detector = new CollisionDetector(physics, this);
  
  curtainLeft = loadImage("menu/curtain_left.png");
  curtainRight = loadImage("menu/curtain_right.png");
  logo = loadImage("menu/logo.png");
  
  int buttonSpacing = 50;
  int buttonY = 40;
  int buttonRow2Y = 40 + 50;
  
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

  resetX = 700 + 40;
  resetY = buttonRow2Y;
  reset = loadImage("buttons/reset.png");
  reset_bw = loadImage("buttons/reset_bw.png");

  debugX = resetX + buttonSpacing;
  debugY = buttonRow2Y;
  debug = loadImage("buttons/debug.png");
  debug_bw = loadImage("buttons/debug_bw.png");

  menuX = debugX + buttonSpacing;
  menuY = buttonRow2Y;
  menu = loadImage("buttons/menu.png");
  menu_bw = loadImage("buttons/menu_bw.png");
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
  }
  drawMenu();
  
  if (itemDragged != null) {
    int imageX = getGridX(mouseX - dragAnchorDeltaX) * Util.GRID_SIZE;
    int imageY = getGridY(mouseY - dragAnchorDeltaY) * Util.GRID_SIZE;
    image(itemDragged.getImage(), imageX, imageY);
    if (isDragOverOtherItem()) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      line(imageX, imageY, imageX + itemDragged.getImage().width, imageY + itemDragged.getImage().height);
      line(imageX + itemDragged.getImage().width, imageY, imageX, imageY + itemDragged.getImage().height);
    }
  }

  // Render the game world based on the data in the physics engine.
  gameRenderer(physics.getWorld());
  
  if (levelCompleted) {
    if (millis() - levelCompletedStart > 3000) {
      levelCompleted = false;
      gameController.stop();
      gameController.reset();
      audioCenter.stopSound(gameController.getCurrentLevel().getBackgroundMusic());
      int levelCompletedNumber = gameController.getCurrentLevel().getNumber();
      if (levelCompletedNumber < 3) {
        gameController.playLevel(levelCompletedNumber + 1);
        audioCenter.playSound(gameController.getCurrentLevel().getBackgroundMusic(), true);
      } else {
        closeCurtain();
        wonTheGame = true;
        audioCenter.playSound(SoundType.YOU_WON);
        audioCenter.playSound(SoundType.YOU_WON_CHEERING);
      }
    }
  }

  if (!audioFirstLevelStarted && millis() - initMillis > 2000) {
    if (audioCenter.isPlaying(gameController.getCurrentLevel().getBackgroundMusic())) {
      audioFirstLevelStarted = true;
    } else {
      audioCenter.playSound(gameController.getCurrentLevel().getBackgroundMusic(), true);
    }
  }

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
  if (gameController.canReset()) {
    image(reset, resetX, resetY);
  } else {
    image(reset_bw, resetX, resetY);
  }
  if (gameController.canDebug()) {
    image(debug, debugX, debugY);
  } else {
    image(debug_bw, debugX, debugY);
  }
  if (gameController.canMenu()) {
    image(menu, menuX, menuY);
  } else {
    image(menu_bw, menuX, menuY);
  }
  imageMode(CORNER);

  int marginLeft = 25;
//  int marginTop = 300; //SANDBOX
  int marginTop = 150; //SANDBOX
  PFont font = createFont("Arial", 16, true);
  fill(0);
  //SANDBOX
  /*
  textFont(font, 40);
  text("Level " + gameController.getCurrentLevel().getNumber(), playingFieldWidth + marginLeft, 180);
  textFont(font, 16);
  text("Goal: " + gameController.getCurrentLevel().getDescription(), playingFieldWidth + marginLeft, 220);
  */
  textFont(font, 24);
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

void closeCurtain() {
  if (curtainOpen && !curtainMoving) {
    curtainMoving = true;
  }
}

void drawMenu() {
  int leftX = curtainOpen ? -500 : 0;
  int rightX = curtainOpen ? 1000 : 500;
  if (curtainMoving) {
    if (curtainOpen) {
      leftX += curtainProgress;
      rightX -= curtainProgress;
    } else {
      leftX -= curtainProgress;
      rightX += curtainProgress;
    }
    curtainProgress += 6;
    if (curtainProgress >= 500) {
      curtainOpen = !curtainOpen;
      curtainProgress = 0;
      curtainMoving = false;
    }
  }
  if (!curtainOpen || curtainMoving) {
    image(curtainLeft, leftX, 0, 500, 700);
    image(curtainRight, rightX, 0, 500, 700);
  }
  if (!curtainOpen && !curtainMoving) {
    image(logo, 100, 50);
  }
}

void mousePressed() {
  if (!curtainOpen && !curtainMoving) {
    curtainMoving = true;
    if (wonTheGame) {
      wonTheGame = false;
      audioFirstLevelStarted = false;
      gameController.playLevel(1);
    }
  } else {
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
    if (dist(mouseX, mouseY, resetX, resetY) <= buttonRadius) {
      gameController.reset();
    }
    if (dist(mouseX, mouseY, debugX, debugY) <= buttonRadius) {
      gameController.toggleDebug();
    }
    if (dist(mouseX, mouseY, menuX, menuY) <= buttonRadius) {
      closeCurtain();
    }
    if (mouseX >= 0 && mouseX <= 700) {
      boolean clickOnPlaceableItem = false;
      if (!gameController.isRunning()) {
        for (Item item : gameController.getCurrentLevel().getInventory().getItemsInUse()) {
          Vec2 screenPosition = new Vec2(item.getPlacedGridX() * Util.GRID_SIZE, item.getPlacedGridY() * Util.GRID_SIZE);
          int topLeftX = screenPosition.x;
          int topLeftY = screenPosition.y;
          if (mouseX >= topLeftX && mouseX <= topLeftX + item.getImage().width
              && mouseY >= topLeftY && mouseY <= topLeftY + item.getImage().height) {
            clickOnPlaceableItem = true;
            itemDragged = item;
            dragAnchorDeltaX = mouseX - topLeftX;
            dragAnchorDeltaY = mouseY - topLeftY;
            break;
          }
        }
      }
      if (!clickOnPlaceableItem) {
        gameController.togglePlay();
      }
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
  }
}

void mouseDragged() {
  
}

void mouseReleased() {
  if (itemDragged != null) {
    int gridX = getGridX(mouseX - dragAnchorDeltaX);
    int gridY = getGridY(mouseY - dragAnchorDeltaY);
    boolean insidePlayingField = gridX + itemDragged.getGridWidth() <= 35 && gridY + itemDragged.getGridHeight() <= 35;
    if (!isDragOverOtherItem() && insidePlayingField) {
      itemDragged.setPlaceOnGrid(gridX, gridY);
    } else {
      if (itemDragged.isPlaced()) {
        // Currently placed.
        if (!insidePlayingField) {
          // Dragging to the right means put back in inventory.
          gameController.getCurrentLevel().getInventory().stopUsing(itemDragged);
        } else {
          // Ignore drag.
        }
      } else {
        // Not in playing field, return to inventory.
        gameController.getCurrentLevel().getInventory().stopUsing(itemDragged);
      }
    }
    // Either way, the dragging is done.
    itemDragged = null;
    dragAnchorDeltaX = 0;
    dragAnchorDeltaY = 0;
  }
}

boolean isDragOverOtherItem() {
  boolean dragOverOtherItem = false;
  if (itemDragged != null) {
    int draggedGridX = getGridX(mouseX - dragAnchorDeltaX);
    int draggedGridY = getGridY(mouseY - dragAnchorDeltaY);
    int draggedGridWidth = itemDragged.getGridWidth();
    int draggedGridHeight = itemDragged.getGridHeight();
    for (Item item : gameController.getCurrentLevel().getItemsInSimulation()) {
      if (item != itemDragged) {
        int gridX = item.getPlacedGridX();
        int gridY = item.getPlacedGridY();
        int gridWidth = item.getGridWidth();
        int gridHeight = item.getGridHeight();
        if (draggedGridX + draggedGridWidth > gridX &&
            draggedGridY + draggedGridHeight > gridY &&
            draggedGridX < gridX + gridWidth &&
            draggedGridY < gridY + gridHeight) {
          dragOverOtherItem = true;
          break;  
        }
      }
    }
  }
  return dragOverOtherItem;
}

// this function renders the physics scene.
// this can either be called automatically from the physics
// engine if we enable it as a custom renderer or 
// we can call it from draw
void gameRenderer(World world) {
  stroke(0);
  
  if (curtainOpen && !curtainMoving) {
    for (Item item : gameController.getCurrentLevel().getItemsInSimulation()) {
      if (item != itemDragged) {
        Body body = item.getBody();
        Vec2 position = physics.worldToScreen(body.getWorldCenter());
        float angle = physics.getAngle(body) - degrees(body.getAngle());
        pushMatrix();
        translate(position.x, position.y);
        rotate(-radians(angle));
        image(item.getImage(), -item.getScreenWidth() / 2, -item.getScreenHeight() / 2, item.getScreenWidth(), item.getScreenHeight());
        popMatrix();
      }
    }
  }
}

// This method gets called automatically when there is a collision
void collision(Body body1, Body body2, float impulse) {
  Item item1 = gameController.getItem(body1);
  Item item2 = gameController.getItem(body2);
  if (item1 != null && item2 != null) {
    if (gameController.getCurrentLevel().isGoalCollision(item1, item2)) {
      levelCompleted = true;
      levelCompletedStart = millis();
      audioCenter.playSound(SoundType.CHEERING);
    }
    if (item1.getType() == ItemType.TRAMPOLINE || item2.getType() == ItemType.TRAMPOLINE) {
      Item trampoline, ball;
      if (item1.getType() == ItemType.TRAMPOLINE) {
        trampoline = item1;
        ball = item2;
      } else {
        trampline = item2;
        ball = item1;
      }
      int ballBottomY = physics.worldToScreen(ball.getBody().getWorldCenter()).y + (ball.getScreenHeight() / 2);
      int trampolineTopY = physics.worldToScreen(trampoline.getBody().getWorldCenter()).y - (trampoline.getScreenHeight() / 2);
      if (ballBottomY <= trampolineTopY) {
        //TODO: make relative to current y speed.
        Vec2 impulse = new Vec2(0, -12);
        ball.getBody().applyImpulse(impulse, ball.getBody().getWorldCenter());
        audioCenter.playSound(SoundType.HIT_TRAMPOLINE);
      }
    }
    if (item1.getType() == ItemType.WOODEN_BEAM || item2.getType() == ItemType.WOODEN_BEAM ||
        item1.getType() == ItemType.DIAGONAL_BEAM || item2.getType() == ItemType.DIAGONAL_BEAM ||
        item1.getType() == ItemType.DIAGONAL_BEAM_REVERSED || item2.getType() == ItemType.DIAGONAL_BEAM_REVERSED) {
      audioCenter.playSound(SoundType.HIT_WOOD);
    }
  }
}


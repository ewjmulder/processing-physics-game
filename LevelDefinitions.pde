public class LevelDefinitions {

  public static void addLevelsToGameController(GameController gameController) {
//    gameController.addLevel(createLevel1()); //SANDBOX
//    gameController.addLevel(createLevel2()); //SANDBOX
//    gameController.addLevel(createLevel3()); //SANDBOX
    gameController.addLevel(createLevel4());
  }
  
  private static Level createLevel1() {
    Inventory inventory = new Inventory();
    inventory.add(ItemType.WOODEN_BEAM, 2);

    Level level = new Level(1, SoundType.MUSIC_LEVEL_1, "Tutorial", "Hit the target\nwith the soccer ball.", loadImage("background/level1.jpg"), inventory);
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 0, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 10, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 20, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 25, 34));

    Item ball = new Item(ItemType.SOCCER_BALL, 2, 1);
    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM, 1, 4));
    Item goal = new Item(ItemType.GOAL, 28, 5);
    level.addFixedItem(ball);
    level.addFixedItem(goal);
    level.setGoalCollision(ball, goal);
    return level;
  }    

  private static Level createLevel2() {
    Inventory inventory = new Inventory();
    inventory.add(ItemType.DIAGONAL_BEAM_REVERSED, 3);
    inventory.add(ItemType.DIAGONAL_BEAM, 2);

    Level level = new Level(2, SoundType.MUSIC_LEVEL_2, "Rolling down", "Hit the target\nwith the bowling ball.", loadImage("background/level2.jpg"), inventory);
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 0, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 10, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 20, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 25, 34));

    Item ball = new Item(ItemType.BOWLING_BALL, 31, 1);
//    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM_REVERSED, 30, 4));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 20, 8));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 13, 8));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 7, 8));

//    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM, 1, 10));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 6, 14));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 13, 14));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 16, 14));

//    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM_REVERSED, 26, 16));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 16, 20));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 10, 20));

//    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM, 4, 22));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 8, 26));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 12, 26));

//    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM_REVERSED, 25, 24));

    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM, 12, 29));
    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM_REVERSED, 20, 29));
    Item goal = new Item(ItemType.GOAL, 17, 31);
    level.addFixedItem(ball);
    level.addFixedItem(goal);
    level.setGoalCollision(ball, goal);
    return level;
  }    

  private static Level createLevel3() {
    Inventory inventory = new Inventory();
    inventory.add(ItemType.TRAMPOLINE, 2);

    Level level = new Level(3, SoundType.MUSIC_LEVEL_3, "Jump!", "Hit the target\nwith the bowling ball.", loadImage("background/level3.png"), inventory);
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 0, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 10, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 20, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 25, 34));

    Item ball = new Item(ItemType.BOWLING_BALL, 2, 1);
    level.addFixedItem(new Item(ItemType.DIAGONAL_BEAM, 1, 4));
    Item goal = new Item(ItemType.GOAL, 31, 1);
    level.addFixedItem(ball);
    level.addFixedItem(goal);
    level.setGoalCollision(ball, goal);
    return level;
  }    

  private static Level createLevel4() {
    Inventory inventory = new Inventory();
    inventory.add(ItemType.SOCCER_BALL, 5);
    inventory.add(ItemType.BOWLING_BALL, 5);
    inventory.add(ItemType.WOODEN_BEAM, 5);
    inventory.add(ItemType.DIAGONAL_BEAM, 5);
    inventory.add(ItemType.DIAGONAL_BEAM_REVERSED, 5);
    inventory.add(ItemType.TRAMPOLINE, 5);

    Level level = new Level(4, null, "Sandbox", "Just play around", loadImage("background/level2.jpg"), inventory);
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 0, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 10, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 20, 34));
    level.addFixedItem(new Item(ItemType.WOODEN_BEAM, 25, 34));

    level.setGoalCollision(null, null);
    return level;
  }    

}


public class SoundType {

  public static final SoundType MUSIC_LEVEL_1 = new SoundType("Music level 1");
  public static final SoundType MUSIC_LEVEL_2 = new SoundType("Music level 2");
  public static final SoundType MUSIC_LEVEL_3 = new SoundType("Music level 3");
  public static final SoundType CHEERING = new SoundType("Cheering");
  public static final SoundType YOU_WON = new SoundType("You won");
  public static final SoundType YOU_WON_CHEERING = new SoundType("You won cheering");
  public static final SoundType HIT_WOOD = new SoundType("Hit wood");
  public static final SoundType HIT_TRAMPOLINE = new SoundType("Hit trampoline");
 
  private String name;
  
  private SoundType(String name) {
    this.name = name;
  }
  
  public String toString() {
    return this.name;
  }
  
}

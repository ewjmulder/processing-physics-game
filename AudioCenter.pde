public class AudioCenter {

  private Maxim maxim;
  private Map<SoundType, AudioPlayer> playerMap;

  public AudioCenter(Maxim maxim) {
    this.maxim = maxim;
    this.playerMap = new HashMap<SoundType, AudioPlayer>();
  }
  
  //TODO: "Background" music (per level?)
  
  public void addSound(SoundType soundType, String path) {
    Player player = maxim.loadFile(path);
    player.setLooping(false);
    this.playerMap.put(soundType, player);
  }

  public void playSound(SoundType soundType) {
    AudioPlayer player = this.playerMap.get(soundType);
    if (player == null) {
      console.error("No player for sound type: " + soundType);
    }
    player.cue(0);
    player.play();
  }
  
}

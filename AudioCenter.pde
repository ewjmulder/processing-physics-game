public class AudioCenter {

  private Maxim maxim;
  private Map<SoundType, AudioPlayer> playerMap;

  public AudioCenter(Maxim maxim) {
    this.maxim = maxim;
    this.playerMap = new HashMap<SoundType, AudioPlayer>();
  }
  
  public void addSound(SoundType soundType, String path) {
    Player player = maxim.loadFile(path);
    player.setLooping(false);
    this.playerMap.put(soundType, player);
  }

  public void playSound(SoundType soundType) {
    playSound(soundType, false);
  }
  
  public void isPlaying(SoundType soundType) {
    return this.playerMap.get(soundType).isPlaying();
  }

  public void playSound(SoundType soundType, boolean loop) {
    AudioPlayer player = this.playerMap.get(soundType);
    if (player == null) {
      console.error("No player for sound type: " + soundType);
    }
    player.setLooping(loop);
    player.cue(0);
    player.play();
  }

  public void stopSound(SoundType soundType) {
    AudioPlayer player = this.playerMap.get(soundType);
    if (player == null) {
      console.error("No player for sound type: " + soundType);
    }
    player.stop();
  }
  
}

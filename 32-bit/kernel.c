void start() {
  short* video_memory = (short*)0xb8000;
  *video_memory = (0xf << 8) | 'X';
  for(;;);
}
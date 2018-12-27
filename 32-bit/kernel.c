void main() {
  char* video_memory = (char*)0xb8000;
  video_memory[1] = 'Z';
  video_memory[2] = 0x0f;
  video_memory[3] = 'K';
  video_memory[4] = 0x0f;
  video_memory[5] = 'X';
  video_memory[6] = 0x0f;
  video_memory[7] = 'X';
  video_memory[8] = 0x0f;
  video_memory[9] = 'X';
  video_memory[10] = 0x0f;
}

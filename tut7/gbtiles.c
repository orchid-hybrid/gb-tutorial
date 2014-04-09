#include <stdio.h>
#include <stdlib.h>

#include "sinistar_mouth.xpm"

// this program converts a 4 color bitmap image into game boy character/tile data

int pixel(int row, int column) {
  char c = image[5+row][column];
  if(c == image[1][0]) return 0;
  if(c == image[2][0]) return 1;
  if(c == image[3][0]) return 2;
  if(c == image[4][0]) return 3;
  puts("ERROR");
  return 0;
}

void tile(int tx, int ty) {
  int x,y;
  int b1,b2;
  
  printf("db ");
  for(y = 0; y < 8; y++) {
    b1 = 0;
    b2 = 0;
    for(x = 0; x < 8; x++) {
      b1 |= (pixel(ty+y,tx+x)&1)<<(7-x);
      b2 |= ((pixel(ty+y,tx+x)>>1)&1)<<(7-x);
    }
    printf("$%.2X,$%.2X", b1, b2);
    if(y != 7) printf(",");
    else puts("");
  }
}

int main(void) {
  int tx, ty;
  
  int w,h,colors,charspp;
  
  //puts("remember to order the colors (white, light, dark, black) in the xpm");
  
  if((4 != sscanf(image[0], "%d %d %d %d", &w, &h, &colors, &charspp))) {
    puts("invalid xpm");
    return EXIT_FAILURE;
  }
  if(w%8 || h%8) {
    puts("image size must be a multiple of 8");
    return EXIT_FAILURE;
  }
  if(colors != 4) {
    puts("image data must be one four color");
    return EXIT_FAILURE;
  }
  if(charspp != 1) {
    puts("image data must be one char per pixel");
    return EXIT_FAILURE;
  }
  
  for(ty = 0; ty < h/8; ty++) {
    for(tx = 0; tx < w/8; tx++) {
      tile(tx*8, ty*8);
    }
  }
  
  return EXIT_SUCCESS;
}

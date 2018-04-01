#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main( int argc, char *argv[] )
{
  FILE *fp;
  char cpuBuffer[1035];
  char memBuffer[1035];
  int done = 0;

  /* Open the command for reading. */
  // -n1 : only run once; other stuff: for formatting to make parsing easier
  fp = popen("top -n1 -stats 'cpu,command'", "r");
  if (fp == NULL) {
    printf("Failed to run command\n" );
    exit(1);
  }

  /* Read the output a line at a time - output it. */
  while ((done < 4) && (fgets(cpuBuffer, sizeof(cpuBuffer)-1, fp) != NULL)) {
    done++;
  }
  while ((done < 7) && (fgets(memBuffer, sizeof(cpuBuffer)-1, fp) != NULL)) {
    done++;
  }

  /* close */
  pclose(fp);

  char physMemGig[5];
  char physMemMeg[10];
  int memIndex = 0;
  int memBufferIndex = 9; //first mem reading
  while(memBuffer[memBufferIndex] != 'G'){
    physMemGig[memIndex++] = memBuffer[memBufferIndex++];
  }
  memIndex = 0;
  //Navigate to last reading
  while(memBuffer[memBufferIndex] != ','){
    memBufferIndex++;
  }
  memBufferIndex += 2;
  while(memBuffer[memBufferIndex] != 'M'){
    physMemMeg[memIndex++] = memBuffer[memBufferIndex++];
  }

  int physMemUsed, physMemFree;
  physMemUsed = atoi(physMemGig);
  physMemFree = atoi(physMemMeg);

  printf("Physical memory in use: %dG\n", physMemUsed);
  printf("Physical memory not in use: %dM\n", physMemFree);

  char user[10];
  char sys[10];
  char idle[10];
  int index = 0;
  int cpuBufferIndex = 11; //get it to the first cpu reading
  while(cpuBuffer[cpuBufferIndex] != '%'){
    user[index++] = cpuBuffer[cpuBufferIndex++];
  }
  cpuBufferIndex += 8; //second cpu reading
  index = 0;
  while(cpuBuffer[cpuBufferIndex] != '%'){
    sys[index++] = cpuBuffer[cpuBufferIndex++];
  }
  cpuBufferIndex += 7; //third cpu reading
  index = 0;
  while(cpuBuffer[cpuBufferIndex] != '%'){
    idle[index++] = cpuBuffer[cpuBufferIndex++];
  }

  float userF, sysF;
  userF = (float)atof(user);
  sysF = (float)atof(sys);
  float inUse = userF + sysF;
  float idleF = (float)atof(idle);

  printf("CPU in use: %.2f%%\n", inUse);
  printf("CPU idle: %.2f%%\n", idleF);

  return 0;
}

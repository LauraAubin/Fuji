#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main( int argc, char *argv[] )
{
  FILE *fp;
  char cpuBuffer[300];
  int done = 0;
  int selectedPIDI = 10740;
  char selectedPID[10];
  sprintf(selectedPID, "%d", selectedPIDI);

  char command[50] = "ps -p ";
  strcat(command, selectedPID);
  strcat(command, " -o %cpu");
  /* Open the command for reading. */
  // -n1 : only run once
  fp = popen(command, "r");
  if (fp == NULL) {
    printf("Failed to run command\n" );
    exit(1);
  }

  /* Read the output a line at a time - output it. */
  while ((done < 2) && (fgets(cpuBuffer, sizeof(cpuBuffer)-1, fp) != NULL)) {
    done++;
  }

  /* close */
  pclose(fp);

  char cpuUsage[10];
  int cpuIndex = 0;
  int cpuBufferIndex = 2;
  for(int i = 0; i < 3; i++){
    cpuUsage[cpuIndex++] = cpuBuffer[cpuBufferIndex++];
  }

  float cpuUsageF;
  cpuUsageF = (float)atof(cpuUsage);
  printf("CPU used by PID %s: %.1f%%\n", selectedPID, cpuUsageF);

  return 0;
}

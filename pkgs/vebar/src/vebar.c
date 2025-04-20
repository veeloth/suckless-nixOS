#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

#define COMMAND_BEGGINING "/bin/sh -c \"xsetroot -name \\\"\0"
#define COMMAND_ENDING "\\\"\"\0"

void printb (char * bar)
  {
  char command[255] = COMMAND_BEGGINING;
  strcat(&command, bar);
  strcat(command, COMMAND_ENDING);
  system(command);
  };

int main ()
  {
  char * bar = " $(date +%Y.%m.%d\\ %H:%M) ";
  printb(bar);//print the bar at startup

  //this section is meant to align the clock w the actual time, so it updates at 12:01:00 rather than, for example, 12:01:37
  time_t t = time(NULL);
  struct tm tm = *localtime(&t);//get current time
  sleep(60 - tm.tm_sec);//wait what's left of the current minute

  //this section updates the bar every minute
  while (1)
    {
    printb(bar);
    sleep(60);
    }

  return 0;
  };

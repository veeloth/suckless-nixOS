#include <stdlib.h>
#include <unistd.h>
#include <time.h>

int main ()
  {
  system("/bin/sh -c \"xsetroot -name \\\" $(date +%Y.%m.%d\\ %H:%M) \\\"\"");//update date

  //this section is meant to align the clock w the actual time, so it updates at 12:01:00 rather than, for example, 12:01:37
  time_t t = time(NULL);
  struct tm tm = *localtime(&t);//get current time
  sleep(60 - tm.tm_sec);//wait what's left of the current minute

  //this section updates the time every minute
  while (1)
    {
    system("/bin/sh -c \"xsetroot -name \\\" $(date +%Y.%m.%d\\ %H:%M) \\\"\"");
    sleep(60);
    }
  return 0;
  };

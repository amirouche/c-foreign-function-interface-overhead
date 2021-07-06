#include <stdio.h>
#include <time.h>
#include "libfrob.h"

long long current_timestamp()
{
    struct timespec monotime;
    clock_gettime(CLOCK_MONOTONIC, &monotime);
    long long milliseconds = monotime.tv_sec * 1000 + monotime.tv_nsec / 1000000;

    return milliseconds;
}


void run(int count)
{
    long long start = current_timestamp();
    long long end;

    int x = 0;
    while (count != 0) {
      x = frob(x);
      count = count - 1;
    }

    printf("%lld\n", current_timestamp() - start);
}

int main(int argc, char** argv)
{
    if (argc == 1) {
        printf("First arg is required \n");
        return 1;
    }

    int count = atoi(argv[1]);
    if (count <= 0 || count > 2000000000) {
        printf("Must be a positive number not exceeding 2 billion.\n");
        return 1;
    }

    // start immediately
    run(count);

    return 0;
}

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

todo: ## Things that should be done
	@grep -nR --color=always  --before-context=2  --after-context=2 TODO .

xxx: ## Things that require attention
	@grep -nR --color=always --before-context=2  --after-context=2 XXX .

check: ## Run tests
	pytest -p no:warnings -vvv tests.py

libfrob: libfrob.c
	gcc -c -fPIC libfrob.c -o libfrob.o
	gcc -shared libfrob.o -o libfrob.so

python: libfrob
	python3 build.py
	LD_LIBRARY_PATH=$(PWD) LD_PRELOAD=libfrob.so /usr/bin/time python3 frob.py $(ITERATION)

pypy: libfrob
	pypy3 build.py
	LD_LIBRARY_PATH=$(PWD) LD_PRELOAD=libfrob.so /usr/bin/time pypy3 frob.py $(ITERATION)

c: libfrob.c frob.c
	gcc -o frob libfrob.c frob.c
	/usr/bin/time ./frob $(ITERATION)

clean:
	rm *.so *.o

all: clean python pypy c chez

chez-debian:
	LD_LIBRARY_PATH=$(PWD) LD_PRELOAD=libfrob.so /usr/bin/time /usr/bin/scheme --optimize-level 3 --program frob.scm $(ITERATION)

chez-local-a6le:
	LD_LIBRARY_PATH=$(PWD) LD_PRELOAD=libfrob.so /usr/bin/time ~/src/scheme/chez/a6le/bin/scheme -b ~/src/scheme/chez/a6le/boot/a6le/petite.boot -b ~/src/scheme/chez/a6le/boot/a6le/scheme.boot --optimize-level 3 --program frob.scm $(ITERATION)

chez-local-ta6le:
	LD_LIBRARY_PATH=$(PWD) LD_PRELOAD=libfrob.so /usr/bin/time ~/src/scheme/chez/ta6le/bin/scheme -b ~/src/scheme/chez/ta6le/boot/ta6le/petite.boot -b ~/src/scheme/chez/ta6le/boot/ta6le/scheme.boot --optimize-level 3 --program frob.scm $(ITERATION)

ITERATION=1000000

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

todo: ## Things that should be done
	@grep -nR --color=always  --before-context=2  --after-context=2 TODO .

xxx: ## Things that require attention
	@grep -nR --color=always --before-context=2  --after-context=2 XXX .

libfrob: libfrob.c
	gcc -c -fPIC libfrob.c -o libfrob.o
	gcc -shared libfrob.o -o libfrob.so

python: libfrob
	python3 build.py
	LD_PRELOAD=./libfrob.so python3 frob.py $(ITERATION)

pypy: libfrob
	pypy3 build.py
	LD_PRELOAD=./libfrob.so pypy3 frob.py $(ITERATION)

c: libfrob libfrob.c frob.c
	gcc -o frob libfrob.c frob.c
	./frob $(ITERATION)

clean:
	rm -rf *.so *.o

all: clean python pypy c chez only-chez ## Run benchmarks

chez:
	/usr/bin/scheme --optimize-level 3 --program frob.scm $(ITERATION)

only-chez:
	/usr/bin/scheme --optimize-level 3 --program frob-chez.scm $(ITERATION)

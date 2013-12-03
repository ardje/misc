filenodes.so: filenodes.c
	$(CC) -Wall filenodes.c -shared -fpic $(shell pkg-config lua5.2 --cflags) -llua5.2 -o filenodes.so

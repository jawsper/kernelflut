#
# Copyright (c) 2015 - 2016 DisplayLink (UK) Ltd.
#

OBJ = evdi/library/libevdi.so thinkpad_edid.o kernelflut.o
DEPS = kernelflut.h
CFLAGS := -I. -Ievdi/library -std=gnu99 $(CFLAGS)

.PHONY: build
build: kernelflut

kernelflut: $(OBJ)
	$(CC) -o "$@" $^ $(CFLAGS) $(LIBS)

thinkpad_edid.o: thinkpad.edid
	ld -r -b binary -o "$@" "$<"
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data,contents "$@" "$@"

%.o: %.c $(DEPS)
	$(CC) -c -o "$@" "$<" $(CFLAGS)

evdi/library/libevdi.so:
	make -C evdi/library

.PHONY: clean
clean:
	rm -f kernelflut *.o
	make -C evdi/library clean
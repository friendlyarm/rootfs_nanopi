include ../MCONFIG

OBJS=daemon.o setproctitle.o isexpired.o vis.o

all: libsupport.a

%.o: %.c
	$(CC) $(CFLAGS) -DHASSETPROCTITLE $< -c

libsupport.a: $(OBJS)
	arm-linux-ar -cruv $@ $^
	arm-linux-ranlib $@

install: ;
install-bin: ;
clean:
	rm -f *.o libsupport.a

setproctitle.o: setproctitle.h
daemon.o: daemon.h

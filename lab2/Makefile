AS = /usr/bin/nasm
LD = /usr/bin/ld

ASFLAGS = -g -f elf64 -D SORT_MODE=$(SORT_MODE)
LDFLAGS = -static

SRCS = lab.s
OBJS = $(SRCS:.s=.o)

EXE = lab
SORT_MODE ?= 1
all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@

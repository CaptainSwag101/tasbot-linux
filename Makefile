
# Makefile made by tom7.
# XXXX
# sigbovik
.PHONY: default all outdir fceu clean veryclean cleantas

default: outdir fceu marionet.pb.cc marionet.pb.h learnfun playfun

all: outdir fceu marionet.pb.cc marionet.pb.h learnfun playfun tasbot emu_test objective_test weighted-objectives_test pinviz sigbovik

OUTDIR=build

# -fno-strict-aliasing
CXXFLAGS=-Wall -Wno-deprecated -Wno-sign-compare -I/usr/local/include
OPT=-g -O0

# for 64-bit building on linux
CXX=g++
CC=g++
SDLARCH=x64

# not using the one in protobuf/src because it doesn't work?
PROTOC=protoc

# -Wl,--subsystem,console

PROTO_HEADERS=marionet.pb.h
PROTO_OBJECTS=marionet.pb.o


# If you don't have SDL, you can leave these out, and maybe it still works.
CCNETWORKING= -DMARIONET=1 -I SDL/include -ISDL_net/
LINKSDL=-lSDL
LINKNETWORKING= $(LINKSDL) -lSDL_net
LINKPROTO= -lprotobuf
NETWORKINGOBJECTS= SDL_net/SDLnet.o SDL_net/SDLnetTCP.o SDL_net/SDLnetUDP.o SDL_net/SDLnetselect.o $(PROTO_OBJECTS)

#PROTOBUFOBJECTS=$(wildcard protobuf/src/*.o)

# PROFILE=-pg
PROFILE=

# enable link time optimizations?
# FLTO=-flto

INCLUDES=-I"cc-lib" -I "cc-lib/city"

CPPFLAGS := $(CCNETWORKING) -DPSS_STYLE=1 -DDUMMY_UI -DHAVE_ASPRINTF -Wno-write-strings -m64 $(OPT) -DHAVE_ALLOCA -DNOWINSTUFF $(INCLUDES) $(PROFILE) --std=gnu++11
#  CPPFLAGS=-DPSS_STYLE=1 -DDUMMY_UI -DHAVE_ASPRINTF -Wno-write-strings -m64 -O -DHAVE_ALLOCA -DNOWINSTUFF $(PROFILE) -g

CCLIBOBJECTS := cc-lib/util.o cc-lib/arcfour.o cc-lib/base/stringprintf.o cc-lib/city/city.o cc-lib/textsvg.o cc-lib/stb_image.o

SDLUTILOBJECTS := sdlutil-lite.o

FCEUDIR := fceu/src

BOARDSOBJECTS := $(wildcard $(FCEUDIR)/boards/*.o)

UTILSOBJECTS := $(wildcard $(FCEUDIR)/utils/*.o)

#LUAOBJECTS := $(wildcard $(FCEUDIR)/lua/src/*.o)

# main binary
# PALETTESOBJECTS := $(FCEUDIR)/palettes/conv.o

INPUTOBJECTS := $(wildcard $(FCEUDIR)/input/*.o)

FCEUOBJECTS := $(wildcard $(FCEUDIR)/*.o)

# $(FCEUDIR)/drivers/common/config.o $(FCEUDIR)/drivers/common/configSys.o
DRIVERS_COMMON_OBJECTS := $(wildcard $(FCEUDIR)/drivers/common/*.o)

EMUOBJECTS := $(FCEUOBJECTS) $(MAPPEROBJECTS) $(UTILSOBJECTS) $(FIROBJECTS) $(PALLETESOBJECTS) $(BOARDSOBJECTS) $(INPUTOBJECTS) $(DRIVERS_COMMON_OBJECTS)

#included in all tests, etc.
BASEOBJECTS := $(CCLIBOBJECTS) $(NETWORKINGOBJECTS) $(PROTOBUFOBJECTS)

TASBOT_OBJECTS := headless-driver.o SDL_dummy_main.o netutil.o simplefm2.o emulator.o basis-util.o objective.o weighted-objectives.o motifs.o util.o

# note you need to build libpng first, in the subdirectory libpng.
# This makefile does not build the .o files for you.
PNG_OBJECTS := libpng/png.o libpng/pngerror.o libpng/pngget.o libpng/pngmem.o libpng/pngpread.o libpng/pngread.o libpng/pngrio.o libpng/pngrtran.o libpng/pngrutil.o libpng/pngset.o libpng/pngtrans.o libpng/pngwio.o libpng/pngwrite.o libpng/pngwtran.o libpng/pngwutil.o

pngsave.o: pngsave.cc pngsave.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INCLUDES) -Ilibpng -c pngsave.cc -o $@

PNGSAVE_OBJECTS := pngsave.o $(PNG_OBJECTS)

OBJECTS := $(BASEOBJECTS) $(EMUOBJECTS) $(TASBOT_OBJECTS)

%.pb.cc: %.proto
	$(PROTOC) $< --cpp_out=.

%.pb.h: %.proto
	$(PROTOC) $< --cpp_out=.

# without static, can't find lz or lstdcxx maybe?
LFLAGS := -m64 $(LINKPROTO) $(LINKNETWORKING) -llua -lz -lm $(OPT) $(PROFILE)
# -Wl,--subsystem,console
# -static -fwhole-program
# -static

# LPNGFLAGS = -Llibpng -m64 -Wl,--subsystem,console $(LINKNETWORKING) -lpng -lz $(OPT) $(PROFILE) -static

fceu:
	cd fceu && scons SYSTEM_LUA=1 . && cd ..

learnfun: $(OBJECTS) learnfun.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

playfun: $(OBJECTS) playfun.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

# XXX never implemented this.
#showfun: outdir $(OBJECTS) showfun.o
#	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

tasbot: $(OBJECTS) tasbot.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

scopefun: $(OBJECTS) $(PNGSAVE_OBJECTS) scopefun.o wave.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

pinviz: $(OBJECTS) $(PNGSAVE_OBJECTS) pinviz.o wave.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

emu_test: $(OBJECTS) emu_test.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

objective_test: $(BASEOBJECTS) objective.o objective_test.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

sigbovik: $(OBJECTS) sigbovik.o $(SDLUTILOBJECTS)
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

weighted-objectives_test: $(BASEOBJECTS) weighted-objectives.o weighted-objectives_test.o util.o
	$(CXX) $^ -o $(OUTDIR)/$@ $(LFLAGS)

test: emu_test objective_test weighted-objectives_test
	time ./emu_test
	time ./objective_test
	time ./weighted-objectives_test

FORCE:
	mkdir -p $(OUTDIR)

clean:
	cd fceu && scons -c . && cd ..
	rm -f $(OUTDIR)/* *.o $(EMUOBJECTS) $(CCLIBOBJECTS) gmon.out

veryclean: clean cleantas

cleantas:
	rm -f prog*.fm2 deepest.fm2 heuristicest.fm2

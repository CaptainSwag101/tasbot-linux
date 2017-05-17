
# Makefile made by tom7.
# XXXX
# sigbovik
.PHONY: default all outdir clean veryclean cleantas

default: outdir marionet.pb.cc marionet.pb.h learnfun playfun

all: outdir marionet.pb.cc marionet.pb.h learnfun playfun tasbot emu_test objective_test weighted-objectives_test pinviz sigbovik

OUTDIR=build

# mlton executes this:
# x86_64-w64-mingw32-gcc -std=gnu99 -c -Ic:\program files (x86)\mlton\lib\mlton\targets\x86_64-w64-mingw32\include -IC:/Program Files (x86)/MLton/lib/mlton/include -O1 -fno-common -fno-strict-aliasing -fomit-frame-pointer -w -m64 -o C:\Users\Tom\AppData\Local\Temp\file17jU3c.o x6502.c

# -fno-strict-aliasing
CXXFLAGS=-Wall -Wno-deprecated -Wno-sign-compare -I/usr/local/include
OPT=-g -O3

# for 64 bits on linux
CXX=g++
CC=g++
SDLARCH=x64

# not using the one in protobuf/src because it doesn't work?
PROTOC=protoc

# -Wl,--subsystem,console

PROTO_HEADERS=marionet.pb.h
PROTO_OBJECTS=marionet.pb.o


# If you don't have SDL, you can leave these out, and maybe it still works.
CCNETWORKING= -DMARIONET=1 -I SDL/include -I SDL_net
LINKSDL=-lSDL
LINKNETWORKING= $(LINKSDL)
LINKPROTO= -lprotobuf
SDLOPATH=SDL/build
#SDLOBJECTS=$(SDLOPATH)/*.o
# For some reason this compiles as 32-bit? But it's unused.
# $(SDLOPATH)/version.o
NETWORKINGOBJECTS= $(SDLOBJECTS) SDL_net/SDLnet.o SDL_net/SDLnetTCP.o SDL_net/SDLnetUDP.o SDL_net/SDLnetselect.o SDL_dummy_main.o netutil.o $(PROTO_OBJECTS)

#PROTOBUFOBJECTS=protobuf/src/code_generator.o protobuf/src/coded_stream.o protobuf/src/common.o protobuf/src/cpp_enum.o protobuf/src/cpp_enum_field.o protobuf/src/cpp_extension.o protobuf/src/cpp_field.o protobuf/src/cpp_file.o protobuf/src/cpp_generator.o protobuf/src/cpp_helpers.o protobuf/src/cpp_message.o protobuf/src/cpp_message_field.o protobuf/src/cpp_primitive_field.o protobuf/src/cpp_service.o protobuf/src/cpp_string_field.o protobuf/src/descriptor.o protobuf/src/descriptor.pb.o protobuf/src/descriptor_database.o protobuf/src/dynamic_message.o protobuf/src/extension_set.o protobuf/src/extension_set_heavy.o protobuf/src/generated_message_reflection.o protobuf/src/generated_message_util.o protobuf/src/gzip_stream.o protobuf/src/importer.o protobuf/src/java_enum.o protobuf/src/java_enum_field.o protobuf/src/java_extension.o protobuf/src/java_field.o protobuf/src/java_file.o protobuf/src/java_generator.o protobuf/src/java_helpers.o protobuf/src/java_message.o protobuf/src/java_message_field.o protobuf/src/java_primitive_field.o protobuf/src/java_service.o protobuf/src/java_string_field.o protobuf/src/message.o protobuf/src/message_lite.o protobuf/src/once.o protobuf/src/parser.o protobuf/src/plugin.o protobuf/src/plugin.pb.o protobuf/src/printer.o protobuf/src/python_generator.o protobuf/src/reflection_ops.o protobuf/src/repeated_field.o protobuf/src/service.o protobuf/src/structurally_valid.o protobuf/src/strutil.o protobuf/src/subprocess.o protobuf/src/substitute.o protobuf/src/text_format.o protobuf/src/tokenizer.o protobuf/src/unknown_field_set.o protobuf/src/wire_format.o protobuf/src/wire_format_lite.o protobuf/src/zero_copy_stream.o protobuf/src/zero_copy_stream_impl.o protobuf/src/zero_copy_stream_impl_lite.o protobuf/src/zip_writer.o

# PROFILE=-pg
PROFILE=

# enable link time optimizations?
# FLTO=-flto
# FLTO=

INCLUDES=-I "cc-lib" -I "cc-lib/city"

#  -DNOUNZIP
CPPFLAGS= $(CCNETWORKING) -DPSS_STYLE=1 -DDUMMY_UI -DHAVE_ASPRINTF -Wno-write-strings -m64 $(OPT) -DHAVE_ALLOCA -DNOWINSTUFF $(INCLUDES) $(PROFILE) $(FLTO) --std=c++11
#  CPPFLAGS=-DPSS_STYLE=1 -DDUMMY_UI -DHAVE_ASPRINTF -Wno-write-strings -m64 -O -DHAVE_ALLOCA -DNOWINSTUFF $(PROFILE) -g

CCLIBOBJECTS=cc-lib/util.o cc-lib/arcfour.o cc-lib/base/stringprintf.o cc-lib/city/city.o cc-lib/textsvg.o cc-lib/stb_image.o

SDLUTILOBJECTS=sdlutil-lite.o

# utils/unzip.o removed -- needs lz
FCEUDIR=fceu

MAPPEROBJECTS=$(FCEUDIR)/mappers/24and26.o $(FCEUDIR)/mappers/51.o $(FCEUDIR)/mappers/69.o $(FCEUDIR)/mappers/77.o $(FCEUDIR)/mappers/40.o $(FCEUDIR)/mappers/6.o $(FCEUDIR)/mappers/71.o $(FCEUDIR)/mappers/79.o $(FCEUDIR)/mappers/41.o $(FCEUDIR)/mappers/61.o $(FCEUDIR)/mappers/72.o $(FCEUDIR)/mappers/80.o $(FCEUDIR)/mappers/42.o $(FCEUDIR)/mappers/62.o $(FCEUDIR)/mappers/73.o $(FCEUDIR)/mappers/85.o $(FCEUDIR)/mappers/46.o $(FCEUDIR)/mappers/65.o $(FCEUDIR)/mappers/75.o $(FCEUDIR)/mappers/emu2413.o $(FCEUDIR)/mappers/50.o $(FCEUDIR)/mappers/67.o $(FCEUDIR)/mappers/76.o $(FCEUDIR)/mappers/mmc2and4.o

UTILSOBJECTS=$(FCEUDIR)/utils/ConvertUTF.o $(FCEUDIR)/utils/general.o $(FCEUDIR)/utils/memory.o $(FCEUDIR)/utils/crc32.o $(FCEUDIR)/utils/guid.o $(FCEUDIR)/utils/endian.o $(FCEUDIR)/utils/md5.o $(FCEUDIR)/utils/xstring.o $(FCEUDIR)/utils/unzip.o

# main binary
# PALETTESOBJECTS=palettes/conv.o

BOARDSOBJECTS=$(FCEUDIR)/boards/01-222.o $(FCEUDIR)/boards/32.o $(FCEUDIR)/boards/gs-2013.o $(FCEUDIR)/boards/103.o $(FCEUDIR)/boards/33.o $(FCEUDIR)/boards/h2288.o $(FCEUDIR)/boards/106.o $(FCEUDIR)/boards/34.o $(FCEUDIR)/boards/karaoke.o $(FCEUDIR)/boards/108.o $(FCEUDIR)/boards/3d-block.o $(FCEUDIR)/boards/kof97.o $(FCEUDIR)/boards/112.o $(FCEUDIR)/boards/411120-c.o $(FCEUDIR)/boards/konami-qtai.o $(FCEUDIR)/boards/116.o $(FCEUDIR)/boards/43.o $(FCEUDIR)/boards/ks7012.o $(FCEUDIR)/boards/117.o $(FCEUDIR)/boards/57.o $(FCEUDIR)/boards/ks7013.o $(FCEUDIR)/boards/120.o $(FCEUDIR)/boards/603-5052.o $(FCEUDIR)/boards/ks7017.o $(FCEUDIR)/boards/121.o $(FCEUDIR)/boards/68.o $(FCEUDIR)/boards/ks7030.o $(FCEUDIR)/boards/12in1.o $(FCEUDIR)/boards/8157.o $(FCEUDIR)/boards/ks7031.o $(FCEUDIR)/boards/15.o $(FCEUDIR)/boards/82.o $(FCEUDIR)/boards/ks7032.o $(FCEUDIR)/boards/151.o $(FCEUDIR)/boards/8237.o $(FCEUDIR)/boards/ks7037.o $(FCEUDIR)/boards/156.o $(FCEUDIR)/boards/830118C.o $(FCEUDIR)/boards/ks7057.o $(FCEUDIR)/boards/164.o $(FCEUDIR)/boards/88.o $(FCEUDIR)/boards/le05.o $(FCEUDIR)/boards/168.o $(FCEUDIR)/boards/90.o $(FCEUDIR)/boards/lh32.o $(FCEUDIR)/boards/17.o $(FCEUDIR)/boards/91.o $(FCEUDIR)/boards/lh53.o $(FCEUDIR)/boards/170.o $(FCEUDIR)/boards/95.o $(FCEUDIR)/boards/malee.o $(FCEUDIR)/boards/175.o $(FCEUDIR)/boards/96.o $(FCEUDIR)/boards/mmc1.o $(FCEUDIR)/boards/176.o $(FCEUDIR)/boards/99.o $(FCEUDIR)/boards/mmc3.o $(FCEUDIR)/boards/177.o $(FCEUDIR)/boards/__dummy_mapper.o $(FCEUDIR)/boards/mmc5.o $(FCEUDIR)/boards/178.o $(FCEUDIR)/boards/a9711.o $(FCEUDIR)/boards/n-c22m.o $(FCEUDIR)/boards/179.o $(FCEUDIR)/boards/a9746.o $(FCEUDIR)/boards/n106.o $(FCEUDIR)/boards/18.o $(FCEUDIR)/boards/ac-08.o $(FCEUDIR)/boards/n625092.o $(FCEUDIR)/boards/183.o $(FCEUDIR)/boards/addrlatch.o $(FCEUDIR)/boards/novel.o $(FCEUDIR)/boards/185.o $(FCEUDIR)/boards/ax5705.o $(FCEUDIR)/boards/onebus.o $(FCEUDIR)/boards/186.o $(FCEUDIR)/boards/bandai.o $(FCEUDIR)/boards/pec-586.o $(FCEUDIR)/boards/187.o $(FCEUDIR)/boards/bb.o $(FCEUDIR)/boards/sa-9602b.o $(FCEUDIR)/boards/189.o $(FCEUDIR)/boards/bmc13in1jy110.o $(FCEUDIR)/boards/sachen.o $(FCEUDIR)/boards/193.o $(FCEUDIR)/boards/bmc42in1r.o $(FCEUDIR)/boards/sc-127.o $(FCEUDIR)/boards/199.o $(FCEUDIR)/boards/bmc64in1nr.o $(FCEUDIR)/boards/sheroes.o $(FCEUDIR)/boards/208.o $(FCEUDIR)/boards/bmc70in1.o $(FCEUDIR)/boards/sl1632.o $(FCEUDIR)/boards/222.o $(FCEUDIR)/boards/bonza.o $(FCEUDIR)/boards/smb2j.o $(FCEUDIR)/boards/225.o $(FCEUDIR)/boards/bs-5.o $(FCEUDIR)/boards/subor.o $(FCEUDIR)/boards/228.o $(FCEUDIR)/boards/cityfighter.o $(FCEUDIR)/boards/super24.o $(FCEUDIR)/boards/230.o $(FCEUDIR)/boards/dance2000.o $(FCEUDIR)/boards/supervision.o $(FCEUDIR)/boards/232.o $(FCEUDIR)/boards/datalatch.o $(FCEUDIR)/boards/t-227-1.o $(FCEUDIR)/boards/234.o $(FCEUDIR)/boards/deirom.o $(FCEUDIR)/boards/t-262.o $(FCEUDIR)/boards/235.o $(FCEUDIR)/boards/dream.o $(FCEUDIR)/boards/tengen.o $(FCEUDIR)/boards/244.o $(FCEUDIR)/boards/edu2000.o $(FCEUDIR)/boards/tf-1201.o $(FCEUDIR)/boards/246.o $(FCEUDIR)/boards/famicombox.o $(FCEUDIR)/boards/transformer.o $(FCEUDIR)/boards/252.o $(FCEUDIR)/boards/fk23c.o $(FCEUDIR)/boards/vrc2and4.o $(FCEUDIR)/boards/253.o $(FCEUDIR)/boards/ghostbusters63in1.o $(FCEUDIR)/boards/vrc7.o $(FCEUDIR)/boards/28.o $(FCEUDIR)/boards/gs-2004.o $(FCEUDIR)/boards/yoko.o

INPUTOBJECTS=$(FCEUDIR)/input/arkanoid.o $(FCEUDIR)/input/ftrainer.o $(FCEUDIR)/input/oekakids.o $(FCEUDIR)/input/suborkb.o $(FCEUDIR)/input/bworld.o $(FCEUDIR)/input/hypershot.o $(FCEUDIR)/input/powerpad.o $(FCEUDIR)/input/toprider.o $(FCEUDIR)/input/cursor.o $(FCEUDIR)/input/mahjong.o $(FCEUDIR)/input/quiz.o $(FCEUDIR)/input/zapper.o $(FCEUDIR)/input/fkb.o $(FCEUDIR)/input/mouse.o $(FCEUDIR)/input/shadow.o

FCEUOBJECTS=$(FCEUDIR)/asm.o $(FCEUDIR)/cart.o $(FCEUDIR)/cheat.o $(FCEUDIR)/conddebug.o $(FCEUDIR)/config.o $(FCEUDIR)/debug.o $(FCEUDIR)/drawing.o $(FCEUDIR)/emufile.o $(FCEUDIR)/fceu.o $(FCEUDIR)/fds.o $(FCEUDIR)/file.o $(FCEUDIR)/filter.o $(FCEUDIR)/ines.o $(FCEUDIR)/input.o $(FCEUDIR)/movie.o $(FCEUDIR)/netplay.o $(FCEUDIR)/nsf.o $(FCEUDIR)/oldmovie.o $(FCEUDIR)/palette.o $(FCEUDIR)/ppu.o $(FCEUDIR)/sound.o $(FCEUDIR)/state.o $(FCEUDIR)/unif.o $(FCEUDIR)/video.o $(FCEUDIR)/vsuni.o $(FCEUDIR)/wave.o $(FCEUDIR)/x6502.o

# $(FCEUDIR)/drivers/common/config.o $(FCEUDIR)/drivers/common/configSys.o
DRIVERS_COMMON_OBJECTS=$(FCEUDIR)/drivers/common/args.o $(FCEUDIR)/drivers/common/nes_ntsc.o $(FCEUDIR)/drivers/common/cheat.o $(FCEUDIR)/drivers/common/scale2x.o  $(FCEUDIR)/drivers/common/scale3x.o $(FCEUDIR)/drivers/common/scalebit.o $(FCEUDIR)/drivers/common/hq2x.o $(FCEUDIR)/drivers/common/vidblit.o $(FCEUDIR)/drivers/common/hq3x.o

EMUOBJECTS=$(FCEUOBJECTS) $(MAPPEROBJECTS) $(UTILSOBJECTS) $(FIROBJECTS) $(PALLETESOBJECTS) $(BOARDSOBJECTS) $(INPUTOBJECTS) $(DRIVERS_COMMON_OBJECTS)

#included in all tests, etc.
BASEOBJECTS=$(CCLIBOBJECTS) $(NETWORKINGOBJECTS) $(PROTOBUFOBJECTS)

TASBOT_OBJECTS=headless-driver.o simplefm2.o emulator.o basis-util.o objective.o weighted-objectives.o motifs.o util.o

# note you need to build libpng first, in the subdirectory libpng.
# This makefile does not build the .o files for you.
PNG_OBJECTS=libpng/png.o libpng/pngerror.o libpng/pngget.o libpng/pngmem.o libpng/pngpread.o libpng/pngread.o libpng/pngrio.o libpng/pngrtran.o libpng/pngrutil.o libpng/pngset.o libpng/pngtrans.o libpng/pngwio.o libpng/pngwrite.o libpng/pngwtran.o libpng/pngwutil.o

pngsave.o: pngsave.cc pngsave.h
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INCLUDES) -Ilibpng -c pngsave.cc -o $@

PNGSAVE_OBJECTS=pngsave.o $(PNG_OBJECTS)

OBJECTS=$(BASEOBJECTS) $(EMUOBJECTS) $(TASBOT_OBJECTS)

%.pb.cc: %.proto
	$(PROTOC) $< --cpp_out=.

%.pb.h: %.proto
	$(PROTOC) $< --cpp_out=.

# without static, can't find lz or lstdcxx maybe?
LFLAGS= -m64 $(LINKPROTO) $(LINKNETWORKING) -lz $(OPT) $(FLTO) $(PROFILE)
# -Wl,--subsystem,console
# -static -fwhole-program
# -static

# LPNGFLAGS = -Llibpng -m64 -Wl,--subsystem,console $(LINKNETWORKING) -lpng16 -lz $(OPT) $(FLTO) $(PROFILE) -static

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
	rm -f $(OUTDIR)/* *.o $(EMUOBJECTS) $(CCLIBOBJECTS) gmon.out

veryclean: clean cleantas

cleantas:
	rm -f prog*.fm2 deepest.fm2 heuristicest.fm2

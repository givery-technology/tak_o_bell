
OBJS = 
TARGETS = main dev

OBJ_MAINS = main.o $(OBJS)
OBJ_DEV = dev.o $(OBJS)

CXXFLAGS = -I/usr/include/opencv2 -I/usr/include/opencv -L/usr/local/lib -lopencv_highgui -lopencv_core -lopencv_features2d -lopencv_imgproc -lopencv_objdetect -lopencv_stitching -lopencv_legacy -lyaml-cpp

CXX_OPTIMIZE_FLAGS = -O2 -pg

.PHONEY: all clean
all: output dev

debug: CXX_OPTIMIZE_FLAGS = -O0 -g
debug: output dev

clean:
	$(RM) $(OBJS)

output: $(OBJ_MAINS)
	$(CXX) -Wall $(CXX_OPTIMIZE_FLAGS) -o out $(OBJ_MAINS) $(CXXFLAGS)

dev: $(OBJ_DEV)
	$(CXX) -Wall $(CXX_OPTIMIZE_FLAGS) -o dev $(OBJ_DEV) $(CXXFLAGS)

main.o: src/main.cpp
	$(CXX) $(CXX_OPTIMIZE_FLAGS) -c $< $(CXXFLAGS)

dev.o: src/dev.cpp
	$(CXX) $(CXX_OPTIMIZE_FLAGS) -c $< $(CXXFLAGS)

# DO NOT DELETE

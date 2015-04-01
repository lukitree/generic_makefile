# project name
EXEC	=	project_name

# compiler
CXX		=	clang++
# compiler flags
CXXFLAGS=	-c -std=c++11 -Weverything
CXXFLAGS_DBG=	$(CXXFLAGS) -g3 -DDEBUG
CXXFLAGS+=	-DNDEBUG

# linker
LINKER	=	$(CC) -o
# linker flags
LDFLAGS	=

# directory structure
OBJDIR	=	build
SRCDIR	=	src
INCDIR	=	inc
BINDIR	=	bin
DBGDIR	=	debug

SOURCES	:=	$(wildcard $(SRCDIR)/*.cpp)
OBJECTS	:=	$(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
DBGOBJ	:=	$(SOURCES:$(SRCDIR).%.cpp=$(DBGOBJ)/%.o)
INCLUDES:=	$(SOURCES:$(SRCDIR)/%.cpp=$(DBGDIR)/%.hpp)

#RELEASE SECTION 
.PHONY: all clean clean-all run build directories

all: $(BINDIR)/$(EXEC)

clean:
	-rm $(OBJDIR)/*.o

clean-all: clean
	-rm $(BINDIR)/$(EXEC)*
	-rm -rf debug

directories:
	mkdir -p $(OBJDIR) $(SRCDIR) $(BINDIR) $(INCDIR)

run: $(BINDIR)/$(EXEC)
	$(BINDIR)/$(EXEC)

build: $(OBJECTS)

$(BINDIR)/$(EXEC): $(OBJECTS)
	$(LINKER) $@$(OBJECTS) $(LDFLAGS) 

$(OBJECTS): directories $(OBJDIR)/%.o : $(SRCDIR)/%.cpp $(INCDIR)/%.hpp
	$(CC) $(CFLAGS) $< -o $@

#DEBUG SECTION
.PHONY: debug debug-run  directories-debug

directories-debug: directories
	mkdir -p $(DBGDIR)

debug-run: $(DBGDIR)/$(EXEC)

debug: directories-debug $(BINDIR)/$(EXEC)
	gdb $(BINDIR)/$(EXEC)

$(DBGDIR)/$(EXEC): directories-debug

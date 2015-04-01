# project name
EXEC	=	project_name

# compiler
CXX		=	clang++

# compiler flags
CXXFLAGS=	-c -std=c++11 -Weverything -MMD -g3 -DDEBUG

# directory structure
OBJDIR	=	build
SRCDIR	=	src
BINDIR	=	bin
INCDIR	=	include

SOURCES	:=	$(wildcard $(SRCDIR)/*.cpp)
OBJECTS	:=	$(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
DEPENDS	:=	$(OBJECTS:$(OBJDIR)/%.o=$(OBJDIR)/%.d)

# linker
LINKER	=	$(CC) -o

# linker flags
LDFLAGS	= -I$(INCDIR)/

$(BINDIR)/$(EXEC): $(OBJECTS)
	$(LINKER) $@ $(OBJECTS) $(LDFLAGS) 

$(OBJECTS): directories $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	$(CC) $(CFLAGS) $< -o $@

-include $(DEPENDS)

.PHONY: all clean clean-all run debug build directories

all: $(BINDIR)/$(EXEC)

clean:
	-rm $(OBJDIR)/*.o

clean-all: 
	-rm -rf $(BINDIR)
	-rm -rf $(OBJDIR)
	-rm -rf $(DBGDIR)

directories:
	mkdir -p $(OBJDIR) $(SRCDIR) $(BINDIR) $(INCDIR)

run: $(BINDIR)/$(EXEC)
	$(BINDIR)/$(EXEC)

debug: $(BINDIR)/$(EXEC)
	gdb $(BINDIR)/$(EXEC)*

build: directories $(OBJECTS)

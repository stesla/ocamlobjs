PROGRAM=ocamlobjs

OBJS=${shell cat .objs}
XOBJS=${OBJS:.cmo=.cmx}

TEST_OBJS=${shell cat .test_objs}
TEST_XOBJS=${TEST_OBJS:.cmo=.cmx}

# Commands
OCAMLC=ocamlfind ocamlc
OCAMLOPT=ocamlfind ocamlopt
OCAMLDEP=ocamlfind ocamldep
INCLUDES=-I src
TEST_INCLUDES=-package oUnit -linkpkg -I tests
OCAMLFLAGS=${INCLUDES} str.cma
OCAMLOPTFLAGS=${INCLUDES} str.cmxa

# Definitions for building byte-compiled executables
all: bin/byte/${PROGRAM}

test: bin/byte/tests
	bin/byte/tests

bin/byte/${PROGRAM}: ${OBJS}
	${OCAMLC} -o $@ ${OCAMLFLAGS} ${OBJS}

bin/byte/tests: INCLUDES += ${TEST_INCLUDES}
bin/byte/tests: ${TEST_OBJS}
	${OCAMLC} -o $@ ${OCAMLFLAGS} ${TEST_OBJS}

# Targets for building native-compiled executables
opt: bin/opt/${PROGRAM}

test-opt: bin/opt/tests
	bin/opt/tests

bin/opt/${PROGRAM}: ${XOBJS}
	${OCAMLOPT} -o $@ ${OCAMLOPTFLAGS} ${XOBJS}

bin/opt/tests: INCLUDES += ${TEST_INCLUDES}
bin/opt/tests: ${TEST_XOBJS}
	${OCAMLOPT} -o $@ ${OCAMLOPTFLAGS} ${TEST_XOBJS}

# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	${OCAMLC} ${OCAMLFLAGS} -c $<

.mli.cmi:
	${OCAMLC} ${OCAMLFLAGS} -c $<

.ml.cmx:
	${OCAMLOPT} ${OCAMLOPTFLAGS} -c $<

# Clean up
.PHONY: clean
clean:
	rm -f bin/byte/* bin/opt/*
	find . -name '*.cm[iox]' -exec rm {} \;
	find . -name '*.o' -exec rm {} \;

# Dependencies
.PHONY: depend objs
depend: SOURCES=${shell find . -name '*.ml*' -print | sed -e s#./##}
depend:
	${OCAMLDEP} ${INCLUDES} -I src -I tests ${SOURCES} > .depend

objs: bin/byte/${PROGRAM}
	bin/byte/${PROGRAM} src/main.cmo < .depend > .objs
	bin/byte/${PROGRAM} tests/suite.cmo < .depend > .test_objs

include .depend

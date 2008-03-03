PROGRAM=ocamlobjs

OBJS=src/main.cmo
XOBJS=${OBJS:.cmo=.cmx}

TEST_OBJS=tests/testCase.cmo tests/test_deps.cmo tests/suite.cmo
TEST_XOBJS=${TEST_OBJS:.cmo=.cmx}

# Commands
OCAMLC=ocamlfind ocamlc
OCAMLOPT=ocamlfind ocamlopt
OCAMLDEP=ocamlfind ocamldep
INCLUDES=
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
.PHONY: depend
depend:
	${OCAMLDEP} ${INCLUDES} -I src -I tests *.mli *.ml > .depend

include .depend

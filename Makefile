PROGRAM=ocamlobjs

OBJS=
PROGRAM_OBJS=src/main.cmo
TEST_OBJS=tests/testCase.cmo tests/test_deps.cmo tests/suite.cmo

# Commands
OCAMLC=ocamlfind ocamlc
OCAMLOPT=ocamlfind ocamlopt
OCAMLDEP=ocamlfind ocamldep
INCLUDES=-package oUnit -linkpkg -I tests
OCAMLFLAGS=${INCLUDES} str.cma
OCAMLOPTFLAGS=${INCLUDES} str.cmxa

all: bin/byte/${PROGRAM}
opt: bin/opt/${PROGRAM}

test: bin/byte/tests
	bin/byte/tests
test-opt: bin/opt/tests
	bin/opt/tests

bin/byte/${PROGRAM}: ${OBJS} ${PROGRAM_OBJS}
	${OCAMLC} -o $@ ${OCAMLFLAGS} ${OBJS} ${PROGRAM_OBJS}
bin/byte/tests: ${PROGRAM_OBJS} ${TEST_OBJS}
	${OCAMLC} -o $@ ${OCAMLFLAGS} ${OBJS} ${TEST_OBJS}


# Definitions for native code compiled executables.
OPT_OBJS=${OBJS:.cmo=.cmx}
PROGRAM_OPT_OBJS=${PROGRAM_OBJS:.cmo=.cmx}
TEST_OPT_OBJS=${TEST_OBJS:.cmo=.cmx}

bin/opt/${PROGRAM}: ${OPT_OBJS} ${PROGRAM_OPT_OBJS}
	${OCAMLOPT} -o $@ ${OCAMLOPTFLAGS} ${OBJS} ${PROGRAM_OPT_OBJS}
bin/opt/tests: ${PROGRAM_OPT_OBJS} ${TEST_OPT_OBJS}
	${OCAMLOPT} -o $@ ${OCAMLOPTFLAGS} ${OPT_OBJS} ${TEST_OPT_OBJS}

# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	${OCAMLC} ${OCAMLFLAGS} -c $<

.mli.cmi:
	${OCAMLC} ${OCAMLFLAGS} -c $<

.ml.cmx:
	${OCAMLOPT} ${OCAMLOPTFLAGS} -c $<

# Clean up
clean:
	rm -f bin/byte/* bin/opt/*
	find . -name '*.cm[iox]' -exec rm {} \;
	find . -name '*.o' -exec rm {} \;

# Dependencies
depend:
	${OCAMLDEP} ${INCLUDES} -I src -I tests *.mli *.ml > .depend

include .depend

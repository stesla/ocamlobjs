PROGRAM=ocamlobjs

MAIN_OBJS=src/main.cmo
TEST_OBJS=

# Commands
OCAMLC=ocamlc
OCAMLOPT=ocamlopt
OCAMLDEP=ocamldep
INCLUDES=str.cma
OCAMLFLAGS=${INCLUDES}
OCAMLOPTFLAGS=${INCLUDES}

all: ${PROGRAM}

${PROGRAM}: ${MAIN_OBJS}
	${OCAMLC} -o bin/byte/${PROGRAM} ${OCAMLFLAGS} ${MAIN_OBJS}
tests: ${MAIN_OBJS} ${TEST_OBJS}
	${OCAMLC} -o bin/byte/tests ${OCAMLFLAGS} ${MAIN_OBJS} ${TEST_OBJS}

# Definitions for native code compiled executables.
MAIN_OPT_OBJS=${MAIN_OBJS:.cmo=.cmx}
TEST_OPT_OBJS=${TEST_OBJS:.cmo=.cmx}

${PROGRAM}-opt: ${MAIN_OPT_OBJS}
	${OCAMLOPT} -o bin/opt/${PROGRAM} ${OCAMLOPTFLAGS} ${MAIN_OPT_OBJS}
tests-opt: ${MAIN_OPT_OBJS} ${TEST_OPT_OBJS}
	${OCAMLOPT} -o bin/opt/$tests ${OCAMLOPTFLAGS} ${MAIN_OPT_OBJS} ${TEST_OPT_OBJS}

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
	${OCAMLDEP} ${INCLUDES} *.mli *.ml > .depend

include .depend

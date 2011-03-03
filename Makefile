all:
	ocamlbuild printfection.cma

install:
	ocamlfind install printfection META _build/printfection.cma _build/printfection.cmi 

remove: 
	ocamlfind remove printfection

tt: 
	ocamlbuild test.byte

psql:
	ocamlbuild psql.byte

clean:
	ocamlbuild -clean



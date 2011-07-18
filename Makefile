all:
	ocamlbuild printfection.cmo

install:
	ocamlfind install printfection META _build/printfection.cm*

remove: 
	ocamlfind remove printfection

tt: 
	ocamlbuild test.byte

psql:
	ocamlbuild psql.byte

clean:
	ocamlbuild -clean



all:
	make fetch
	make generate

generate:
	tuist generate
	xed .

fetch:
	tuist fetch

clean:
	rm -rf BookStore.xc*
	rm -rf Derived/

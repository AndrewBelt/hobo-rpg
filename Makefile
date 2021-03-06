
SRCS = \
	src/util.coffee \
	src/gui.coffee \
	src/actions.coffee \
	src/main.coffee

all: index.html style.css game.js

%.html: %.jade
	jade -P $^

%.css: %.less
	lessc $^ > $@

game.js: $(SRCS)
	coffee -cj $@ $^

clean:
	rm -fv index.html style.css game.js

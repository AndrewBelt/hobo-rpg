
SRCS = \
	src/util.coffee \
	src/gui.coffee \
	src/actions.coffee \
	src/main.coffee

all: index.html style.css game.js

%.html: %.haml
	haml $^ > $@

%.css: %.less
	lessc $^ > $@

game.js: $(SRCS)
	coffee -bcj $@ $^

clean:
	rm -fv index.html style.css game.js
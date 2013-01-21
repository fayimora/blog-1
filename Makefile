JADE 			= $(shell find server client -name "*.jade")
HTML 			= $(JADE:.jade=.html)
TEMPLATES = $(JADE:.jade=.js)

COFFEE = $(shell find client -name "*.coffee")
JS 		 = $(COFFEE:.coffee=.js)

STYL = $(shell find client -name "*.styl")
CSS  = $(STYL:.styl=.css)

build: $(JS) $(CSS) $(HTML) $(TEMPLATES)
	@component build --dev

%.css: %.styl
	stylus -u nib $<

%.html: %.jade
	jade -P < $< --path $< > $@

%.js: %.html
	component convert $<

%.js: %.coffee
	coffee -bc $<

clean:
	rm -rf $(JS) $(CSS) $(HTML) $(TEMPLATES) build

.PHONY: clean
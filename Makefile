JADE 			= $(shell find server client -name "*.jade")
HTML 			= $(JADE:.jade=.html)
TEMPLATES = $(JADE:.jade=.js)

COFFEE = $(shell find client -name "*.coffee")
JS 		 = $(COFFEE:.coffee=.js)

STYL = $(shell find client -name "*.styl")
CSS  = $(STYL:.styl=.css)

build: $(JS) $(CSS) $(HTML) $(TEMPLATES)
	@component build --dev

prod: build
	uglifyjs --no-mangle build/build.js > build/build.tmp.js
	cat build/build.tmp.js > build/build.js
	rm build/build.tmp.js

deps:
	npm install
	component install
	pip install -r requirements.txt
	git clone https://github.com/kelonye/helpers.git

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

.PHONY: clean prod deps
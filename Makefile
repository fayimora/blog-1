start: node_modules components
	@./node_modules/node_hooks/node_modules/.bin/coffee server

node_modules:
	@npm install

components:
	@./node_modules/node_hooks/node_modules/.bin/component install

clean:
	@rm -rf build

.PHONY: clean start
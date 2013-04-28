start: node_modules components
	@supervisor -q -w server/ --extensions 'coffee|jade' server/

node_modules:
	@npm install

components:
	@./node_modules/node_hooks/node_modules/.bin/component install --dev

clean:
	@rm -rf build

.PHONY: clean start
.PONY: build deps help publish

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Compile the elm application into a javascript file and create the package structure.
	mkdir -p package/ContextViewer
	cp -r src/js/ContextRecorder package
	elm-make src/elm/ContextViewer/App.elm --output package/ContextViewer/index.js
	cp src/css/index.css package/ContextViewer/index.css

deps: ## Download the Elm dependencies.
	elm-package install -y

publish: build ## Publish the NPM package into the public registry.
	cd package
	npm publish

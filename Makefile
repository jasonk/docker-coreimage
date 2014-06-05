NAME ?= jasonk/coreimage
VERSION ?= 0.0.7

IMAGEFILES = $(shell find * -type f)

.PHONY: all test tag release

all: build

.build.$(VERSION): $(IMAGEFILES)
	docker build -t $(NAME):$(VERSION) --rm .
	@touch $@

build: .build.$(VERSION)

test: build
	docker run -v $(PWD)/test-suite:/test-suite -t -i --rm $(NAME):$(VERSION)

run: build
	docker run -i -t --rm $(NAME):$(VERSION)

latest: build
	docker tag $(NAME):$(VERSION) $(NAME):latest

tag: test
	git tag release-$(VERSION)
	git push rel-$(VERSION)

push: test
	docker push $(NAME)

clean:
	rm -f .build.*

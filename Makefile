NAME ?= jasonk/coreimage
VERSION ?= 0.0.3

IMAGEFILES = $(shell find image -type f)

.PHONY: all test tag release

all: build

.build.%: $(IMAGEFILES)
	docker build --no-cache -t $(NAME):$@ --rm image
	@touch .build.$@

build: .build.$(VERSION)

test: build
	docker run -v $(PWD)/test-suite:/test-suite -t -i --rm $(NAME):$(VERSION)

latest: build
	docker tag $(NAME):$(VERSION) $(NAME):latest

tag: test
	git tag release-$(VERSION)
	git push rel-$(VERSION)

push: test
	docker push $(NAME)

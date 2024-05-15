# track the build timestamp in Dockerfile.build so the Dockerfile is rebuilt when dependencies change
Dockerfile.build: Dockerfile Gemfile Gemfile.lock
	docker build -t jekyll-docker .
	touch $@

clean:
	rm Dockerfile.build

RUN_ARGS=--rm -it --volume "$(PWD):/src" jekyll-docker

serve: Dockerfile.build
	@docker run \
		-p 4000:4000 \
		$(RUN_ARGS) \
		bundle exec jekyll serve --host 0.0.0.0 --watch --force_polling

shell: Dockerfile.build
	@docker run $(RUN_ARGS) /bin/sh

PRODUCTION_BUILD_DIR := _build/production/$(shell date +%s)
deploy: Dockerfile.build
	@docker run \
		$(RUN_ARGS) \
		/bin/bash -c ' \
		mkdir -p $(PRODUCTION_BUILD_DIR); \
		cp _config.yml /tmp/_config.yml; \
		echo "baseurl: https://www.christophermanning.org" >> /tmp/_config.yml;  \
		jekyll build --destination $(PRODUCTION_BUILD_DIR) --config /tmp/_config.yml;  \
		'

	cp CNAME $(PRODUCTION_BUILD_DIR)
	touch $(PRODUCTION_BUILD_DIR)/.nojekyll

	cd $(PRODUCTION_BUILD_DIR) && \
		git init && \
		git config user.name "Christopher Manning" && \
		git config user.email "" && \
		git add . && \
		git commit -m "Site updated at $(shell TZ=UTC date -Iseconds)" && \
		git log | head && \
		git remote add origin git@github.com:christophermanning/christophermanning.github.io.git && \
		git push origin main --force


build:
	docker build -t jekyll .

serve: build
	docker run --rm \
		-p 4000:4000 \
		--volume="$(PWD):/src" \
		-it jekyll \
		bundle exec jekyll serve --host 0.0.0.0 --watch --force_polling

PRODUCTION_BUILD_DIR := _build/production/$(shell date +%s)
deploy: build
	docker run --rm \
		--volume="$(PWD):/src" \
		-it jekyll \
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


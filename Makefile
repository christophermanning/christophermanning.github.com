NAME=jekyll-docker

# track the build timestamp in Dockerfile.build so the Dockerfile is rebuilt when dependencies change
Dockerfile.build: Dockerfile Gemfile Gemfile.lock
	docker build -t ${NAME} .
	touch $@

clean:
	rm Dockerfile.build

RUN_ARGS=--rm -it --volume "$(PWD):/src" ${NAME}

up: Dockerfile.build
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

# run commands with send-keys so the window returns to a shell when the command exits
dev:
	-tmux kill-session -t "${NAME}"
	tmux new-session -s "${NAME}" -d -n vi
	tmux send-keys -t "${NAME}:vi" "vi" Enter
	tmux new-window -t "${NAME}" -n shell "/bin/zsh"
	tmux new-window -t "${NAME}" -n build
	tmux send-keys -t "${NAME}:build" "make up" Enter
	tmux select-window -t "${NAME}:vi"
	tmux attach-session -t "${NAME}"

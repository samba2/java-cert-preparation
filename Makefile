image:
	docker build --tag jupyter-java - < Dockerfile

notebook:
	docker run \
	--rm \
	-p 8888:8888 \
	--mount type=bind,source=$(shell pwd)/notebook,target=/home/jupyter \
	jupyter-java

sync:
	git fetch --tags --prune && \
	git merge FETCH_HEAD && \
	git add --all && \
	git commit --message="auto-added changes" && \
	git push

clean:
	docker image rm jupyter-java	

.PHONY: notebook
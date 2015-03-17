all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build       - build the debmon image"
	@echo "   2. make quickstart  - start debmon"
	@echo "   3. make stop        - stop debmon"
	@echo "   4. make logs        - view logs"
	@echo "   5. make purge       - stop and remove the container"

build:
	@docker build --tag=debmon .

quickstart:
	@echo "Starting debmon..."
	@docker run --name=debmon-demo -d -p 11080:80 \
		-v /var/run/docker.sock:/run/docker.sock \
		-v $(shell which docker):/bin/docker \
		${USER}/debmon:latest >/dev/null
	@echo "Please be patient. This could take a while..."
	@echo "debmon will be available at http://localhost:11080"
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping debmon..."
	@docker stop debmon-demo >/dev/null

purge: stop
	@echo "Removing stopped container..."
	@docker rm debmon-demo >/dev/null

logs:
	@docker logs -f debmon-demo

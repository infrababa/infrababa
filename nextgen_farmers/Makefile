# NextGen Farmers Hub - Makefile
# Convenient shortcuts for common Docker Compose operations

.PHONY: help build up down start stop restart logs ps clean backup restore health

help: ## Show this help message
	@echo 'NextGen Farmers Hub - Make Commands'
	@echo ''
	@echo 'Usage:'
	@echo '  make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build Docker images
	docker-compose build

up: ## Start all services
	docker-compose up -d

down: ## Stop and remove all services
	docker-compose down

start: ## Start existing services
	docker-compose start

stop: ## Stop services without removing
	docker-compose stop

restart: ## Restart all services
	docker-compose restart

logs: ## View logs from all services
	docker-compose logs -f

ps: ## Show running services
	docker-compose ps

shell: ## Open shell in backend container
	docker-compose exec erpnext-backend bash

migrate: ## Run database migrations
	docker-compose exec erpnext-backend bench --site $${SITE_NAME:-nextgenfarmershub.com} migrate

clear-cache: ## Clear application cache
	docker-compose exec erpnext-backend bench --site $${SITE_NAME:-nextgenfarmershub.com} clear-cache

rebuild: ## Rebuild and restart services
	docker-compose build
	docker-compose up -d

clean: ## Remove all containers, volumes, and images
	docker-compose down -v --rmi all

backup: ## Run backup script
	./docker/scripts/backup-to-s3.sh

restore: ## Run restore script
	./docker/scripts/restore-from-s3.sh

health: ## Run health check
	./docker/scripts/health-check.sh

monitoring-up: ## Start with monitoring enabled
	docker-compose --profile monitoring up -d

monitoring-down: ## Stop monitoring services
	docker-compose --profile monitoring down

dev: ## Start in development mode
	cp docker-compose.override.yml.example docker-compose.override.yml
	docker-compose up

prod: ## Deploy to production
	@echo "Deploying to production..."
	@read -p "Are you sure? [y/N]: " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose pull && \
		docker-compose up -d && \
		docker-compose exec erpnext-backend bench --site $${SITE_NAME:-nextgenfarmershub.com} migrate && \
		docker-compose exec erpnext-backend bench --site $${SITE_NAME:-nextgenfarmershub.com} clear-cache; \
	fi

update: ## Update application from git and restart
	git pull
	docker-compose build
	docker-compose up -d
	docker-compose exec erpnext-backend bench --site $${SITE_NAME:-nextgenfarmershub.com} migrate
	docker-compose exec erpnext-backend bench --site $${SITE_NAME:-nextgenfarmershub.com} clear-cache

stats: ## Show resource usage statistics
	docker stats --no-stream

volumes: ## List all volumes
	docker volume ls | grep nextgen

prune: ## Remove unused Docker resources
	docker system prune -af --volumes

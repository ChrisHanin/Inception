# Variables
NAME = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_DIR = /home/chris/data
WP_DIR = $(DATA_DIR)/wordpress
DB_DIR = $(DATA_DIR)/mariadb

# Colors
GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

# Default target
all: create_dirs up

# Create data directories
create_dirs:
	@echo "$(GREEN)Creating data directories...$(RESET)"
	@mkdir -p $(WP_DIR)
	@mkdir -p $(DB_DIR)
	@echo "$(GREEN)✔ Directories created$(RESET)"

# Build and start containers
up: create_dirs
	@echo "$(GREEN)Building and starting containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d --build
	@echo "$(GREEN)✔ Inception is running$(RESET)"

# Stop containers
down:
	@echo "$(RED)Stopping containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN)✔ Containers stopped$(RESET)"

# Stop containers without removing
stop:
	@echo "$(RED)Stopping containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) stop
	@echo "$(GREEN)✔ Containers stopped$(RESET)"

# Start stopped containers
start:
	@echo "$(GREEN)Starting containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) start
	@echo "$(GREEN)✔ Containers started$(RESET)"

# Clean containers and images
clean: down
	@echo "$(RED)Removing containers and images...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down --rmi all --volumes
	@echo "$(GREEN)✔ Cleaned$(RESET)"

# Full clean: remove everything including data
fclean: clean
	@echo "$(RED)Removing data directories...$(RESET)"
	@sudo rm -rf $(DATA_DIR)
	@echo "$(RED)Removing all Docker resources...$(RESET)"
	@docker system prune -af --volumes 2>/dev/null || true
	@echo "$(GREEN)✔ Full clean complete$(RESET)"

# Rebuild everything
re: fclean all

# Show status
status:
	@docker ps -a
	@echo ""
	@docker volume ls
	@echo ""
	@docker network ls

# Show logs
logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

.PHONY: all create_dirs up down stop start clean fclean re status logs

# ###########################
# make        # Construye y lanza todo
# make down   # Para los contenedores
# make clean  # Borra contenedores e imágenes
# make fclean # Borra TODO (incluidos volúmenes)
# make re     # Rebuild completo
#
# ###########################

NAME = inception

COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down --rmi all

fclean:
	$(COMPOSE) down --rmi all -v

re: fclean all

.PHONY: all down clean fclean re

# ###########################
# make        # Construye y lanza todo
# make down   # Para los contenedores
# make clean  # Borra contenedores e imágenes
# make fclean # Borra TODO (incluidos volúmenes)
# make re     # Rebuild completo
# ###########################
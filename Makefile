DIR="./srcs/docker-compose.yml"

up:
	@docker compose -f $(DIR) up --build -d

down:
	@docker compose -f $(DIR) down

fclean:
	@docker system prune -af
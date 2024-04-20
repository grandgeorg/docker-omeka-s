# Docker for Omeka-S

This repository contains a Dockerfile for building a Docker image for [Omeka-S](https://omeka.org/s/), a next-generation web publishing platform for institutions interested in connecting digital cultural heritage collections with other resources online.

It also contains a `docker-compose.yml` file for running the Omeka-S Docker container with MariaDB database server and PHPMyAdmin database management tool.

## Configuration

Rename the `.env.example` file to `.env` and update the environment variables with your own values.

### Using Secrets

If you want to use secrets for the password variables, you must create `secrets/DB_PASSWORD.txt` and `secrets/DB_ROOT_PASSWORD.txt` and use `docker-compose-secrets.yml` file to run with Docker compose (see below). Then in your `.env` file, you will only need the following variables:

- `COMPOSE_PROJECT_NAME`
- `DB_NAME`
- `DB_USERNAME`
- `OMEKA_S_VERSION`

## Usage

### Test

To test the Docker compose file, you can use the following command:

```bash
docker compose config
```

To test the Docker compose file with secrets `docker-compose-secrets.yml`, you can use the following command:

```bash
docker compose -f docker-compose-secrets.yml config
```

### Run

To run the Docker compose file, you can use the following command:

```bash
docker compose up -d
```

To run the Docker compose file with secrets `docker-compose-secrets.yml`, you can use the following command:

```bash
docker compose -f docker-compose-secrets.yml up -d
```

Assuming you set `COMPOSE_PROJECT_NAME=oms-1` the output should look like this:

```
⠋ Network oms-1-omeka-s-network     Created
⠋ Volume "oms-1_omeka-s-db"         Created
⠋ Volume "oms-1_omeka-s"            Created
✔ Container oms-1-omeka-s-db-1      Started
✔ Container oms-1-omeka-s-pma-1     Started
✔ Container oms-1-omeka-s-app-1     Started
```

### Stop

To stop the Omeka-S Docker container, you can use the following command:

```bash
docker compose down
```

### Remove

To remove the Omeka-S Docker container, you can use the following command:

```bash
docker compose down --volumes
```

### Access

To access the Omeka-S web interface, open your web browser and navigate to `http://localhost:8000`.

To access the PHPMyAdmin web interface, open your web browser and navigate to `http://localhost:8080`.

### Build

You don't have to build the Omeka-S Docker image, as it is available on [Docker Hub](https://hub.docker.com/r/solarbaypilot/omeka-s). 
However, if you want to build the image yourself, first make sure to change the namespace in the `docker-compose.yml` file to your own namespace. 

```yaml
# ...
services:
  # ...
  omeka-s-app:
    image: <YOUR_NAMESPACE>/omeka-s
```

Then you can build the image with the following command:

```bash
docker compose build
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
# Docker for Omeka-S

This repository contains a Dockerfile for building a Docker image for [Omeka-S](https://omeka.org/s/), a next-generation web publishing platform for institutions interested in connecting digital cultural heritage collections with other resources online.

It also contains a `docker-compose.yml` file for running the Omeka-S Docker container with MariaDB database server and PHPMyAdmin database management tool.

## Configuration

Rename the `.env.example` file to `.env` and update the environment variables with your own values.

### Using Secrets

If you want to use secrets for the password variables, you must create `secrets/MYSQL_PASSWORD.txt` and `secrets/MYSQL_ROOT_PASSWORD.txt` and use `docker-compose-secrets.yml` file to run with Docker compose (see below). Then in your `.env` file, you will only need following variables:

- `MYSQL_DATABASE`
- `MYSQL_USER`
- `OMEKA_S_VERSION`

## Usage

To build the Omeka-S Docker image, you can use the following command:

```bash
docker compose build
```

To run the Omeka-S Docker container, you can use the following command:

```bash
docker compose up -d
```

To run the Docker compose file with secrets `docker-compose-secrets.yml`, you can use the following command:

```bash
docker compose -f docker-compose-secrets.yml up -d
```

To stop the Omeka-S Docker container, you can use the following command:

```bash
docker compose down
```

To access the Omeka-S web interface, open your web browser and navigate to `http://localhost:8000`.

To access the PHPMyAdmin web interface, open your web browser and navigate to `http://localhost:8080`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
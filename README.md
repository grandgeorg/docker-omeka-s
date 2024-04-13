# Docker for Omeka-S

This repository contains a Dockerfile for building a Docker image for [Omeka-S](https://omeka.org/s/), a next-generation web publishing platform for institutions interested in connecting digital cultural heritage collections with other resources online.

It also contains a `docker-compose.yml` file for running the Omeka-S Docker container with MariaDB database server and PHPMyAdmin database management tool.

## Configuration

Rename the `.env.example` file to `.env` and update the environment variables with your own values.

## Usage

To build the Omeka-S Docker image, you can use the following command:

```bash
docker compose build
```

To run the Omeka-S Docker container, you can use the following command:

```bash
docker compose up -d
```

To stop the Omeka-S Docker container, you can use the following command:

```bash
docker compose down
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
sudo podman inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bliss_redis

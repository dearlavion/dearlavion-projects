## You can trigger it from the GitHub UI like this:

    deploy_service	rebuild_nginx	What happens
    auth	false	Builds & deploys Auth service
    core	false	Builds & deploys Core service
    web-ui	true	Builds Web UI + rebuilds Nginx container
    nginx	true	Only redeploys Nginx container
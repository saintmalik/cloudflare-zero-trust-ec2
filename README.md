# cloudflare-zero-trust-ec2

## Build your cloudflared image and push to ecr or whichever container repository you are using.

``cd cloudflared``

``docker buildx build --platform linux/arm64 -t $YOUR_CONTAINER_REGISTRY/$YOUR_CONTAINER_REPOSITORY:$IMAGE_TAG  -f Dockerfile.tunnel . --push``
# Backend

## Required environment variables
```
FRONTEND_ADDRESS="http://localhost:80"
```

## To start backend
```
node index.js
```

## Docker
```
docker build \
-t backend \
--build-arg GIT_USERNAME="zekicaneksi" \
--build-arg GIT_PAT="abc123123123" \
.
```

```
docker run -d --name backend -p 3000:3000 \
--env FRONTEND_ADDRESS="http://localhost:80" \
backend
```
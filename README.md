
# Docker Compose Commands for Email Server

## Build and Run Containers:
```bash
docker-compose up -d --build
```

## Check the Status of Supervisor:
```bash
docker-compose exec mailserver supervisorctl status
```

## Send a Test Email:
```bash
docker-compose exec mailserver bash -c "echo 'This is a test email' | mail -s 'Test Subject' testuser@localhost"
```

## List Mail for the Test User:
```bash
docker-compose exec mailserver ls -l /var/mail/testuser
```

## Read Mail for the Test User:
```bash
docker-compose exec mailserver cat /var/mail/testuser
```

# Kubernetes Commands for Email Server

## Read Mail for the Test User in Kubernetes Pod:
```bash
kubectl exec -it email-server-bd8857ff-skt49 -- cat /var/mail/testuser
```

## Send a Test Email in Kubernetes Pod:
```bash
kubectl exec -it email-server-bd8857ff-skt49 -- bash -c "echo 'This is a test email' | mail -s 'Test Subject' testuser@localhost"
```

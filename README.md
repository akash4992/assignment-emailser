docker-compose up -d --build
docker-compose exec mailserver supervisorctl status
docker-compose exec mailserver bash -c "echo 'This is a test email' | mail -s 'Test Subject' testuser@localhost"
docker-compose exec mailserver ls -l /var/mail/testuser
docker-compose exec mailserver cat /var/mail/testuser
kubectl exec -it email-server-bd8857ff-skt49  -- cat /var/mail/testuser
kubectl exec -it email-server-bd8857ff-skt49 -- bash -c "echo 'This is a test email' | mail -s 'Test Subject' testuser@localhost"
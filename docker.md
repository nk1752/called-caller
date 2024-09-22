sudo docker run --entrypoint flexctl \
 -v "$(pwd)/flex-reg":/registration -u $UID mulesoft/flex-gateway \
 registration create \
 --client-id=b95726291f564ae2942ac2c4ecc46311 \
 --client-secret=59dB6D7A84bd442bAfE7422233a82902 \
 --environment=2c6f18bb-03e2-4874-a489-7216df5b5bc2 \
 --connected=true \
 --organization=a6ea8ce7-6d5f-41ee-a802-5505e8833854 \
 --output-directory=/registration \
 nk-gateway

docker run --entrypoint flexctl \
-v "$(pwd)":/renew \
-v <path-to-registration-directory>:/registration \
-u $UID mulesoft/flex-gateway \
registration renew \
--client-id=<your-client-id> \
--client-secret=<your-client-secret> \
--output-directory=/renew \
<path-to-registration-file-in-container>

docker exec -u $UID <container-name-or-id> flexctl registration inspect
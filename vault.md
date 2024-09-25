export VAULT_ADDR="https://nk1752-cluster-public-vault-55c83db1.9e78ed07.z1.hashicorp.cloud:8200";
export VAULT_NAMESPACE="admin"

export VAULT_TOKEN=$(curl -s --header "X-Vault-Namespace: $VAULT_NAMESPACE" \
    --request POST --data '{"role_id": "10e4832f-e504-1732-97d2-5aa1410c9c81", "secret_id": "9ff611aa-0856-8117-3cd2-4d7d62cccee3"}' \
     $VAULT_ADDR/v1/auth/approle/login | jq -r '.auth.client_token' )

     curl -s --header "X-Vault-Token: $VAULT_TOKEN" \
    --header "X-Vault-Namespace: $VAULT_NAMESPACE" \
    $VAULT_ADDR/v1/secret/data/sample-secret | jq -r ".data"
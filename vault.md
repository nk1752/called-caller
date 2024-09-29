# vault

## login

export VAULT_ADDR="https://nk1752-cluster-public-vault-55c83db1.9e78ed07.z1.hashicorp.cloud:8200";
export VAULT_NAMESPACE="admin"

export VAULT_TOKEN=$(curl -s --header "X-Vault-Namespace: $VAULT_NAMESPACE" \
    --request POST --data '{"role_id": "10e4832f-e504-1732-97d2-5aa1410c9c81", "secret_id": "9ff611aa-0856-8117-3cd2-4d7d62cccee3"}' \
     $VAULT_ADDR/v1/auth/approle/login | jq -r '.auth.client_token' )

     curl -s --header "X-Vault-Token: $VAULT_TOKEN" \
    --header "X-Vault-Namespace: $VAULT_NAMESPACE" \
    $VAULT_ADDR/v1/secret/data/sample-secret | jq -r ".data"

## service principal

client_id= RRhPGhGrjPiELAqGpKQEUFkbYtSTzver
client_service=hM05-TMclo7Tr1UYmxN2gIM2khRwZ3rcVQvEO-hKp5VcgC6bqR0K1YaPYyu3bQvM

Before a client can interact with Vault, it must authenticate against an auth method to acquire a token. This token has policies attached so that the behavior of the client can be governed.  We will enable and configure AppRole auth method.

As with secrets engines and policies, auth methods are tied to a namespace. The auth method enabled on the admin namespace is only available to the admin namespace and generates a token available to use against the admin namespace.

> vault read auth/approle/role/actionsapp/role-id
role_id=48b28a05-6cb2-359c-80f5-4f39548c3eb0

> vault write -force auth/approle/role/actionsapp/secret-id
Key                Value                               
secret_id          24a18eea-e494-2f19-6816-2305eb114a63
secret_id_accessor 7ddba078-5eae-f90d-c1c5-fb88719e12ac
secret_id_num_uses 0                                   
secret_id_ttl  

$ tee payload_login.json <<"EOF"
{
  "role_id": "48b28a05-6cb2-359c-80f5-4f39548c3eb0",
  "secret_id": "24a18eea-e494-2f19-6816-2305eb114a63"
}
EOF

## Authenticate with Vault using the AppRole auth method

> curl --request POST \
    --header "X-Vault-Namespace: admin" \
    --data @payload_login.json \
    $VAULT_ADDR/v1/auth/approle/login | jq -r ".auth"

## cleanup

> unset VAULT_TOKEN

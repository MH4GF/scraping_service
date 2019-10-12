#!/bin/sh

yaml_vault decrypt src/config/encrypted_secrets.yml -o src/config/secrets.yml \
  --cryptor=aws-kms \
  --aws-region=ap-northeast-1 \
  --aws-kms-key-id=$AWS_KMS_KEY_ID \
  --aws-access-key-id=$AWS_ACCESS_KEY_ID \
  --aws-secret-access-key=$AWS_SECRET_ACCESS_KEY


#!/usr/bin/env bash

file="qrcode.png"

vault write \
  -field=barcode \
  /identity/mfa/method/totp/admin-generate \
  method_id="$(terraform output -raw method_id)" \
  entity_id="$(terraform output -raw entity_id)" \
  | base64 -d > $file

open $file
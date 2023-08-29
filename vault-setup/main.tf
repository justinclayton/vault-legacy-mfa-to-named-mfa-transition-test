provider "vault" {
  address = "http://127.0.0.1:8200"
}

# Enable the userpass auth method
resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

# Create a user in the userpass auth method
resource "vault_generic_endpoint" "alice_user" {
  depends_on = [vault_auth_backend.userpass]
  path = "auth/userpass/users/alice"

  data_json = jsonencode({
    password = "malice"
  })

  lifecycle {
    ignore_changes = [data_json]
  }
}

# Create entity and alias for user
resource "vault_identity_entity" "alice" {
  depends_on = [vault_generic_endpoint.alice_user]
  name = "alice"
}

resource "vault_identity_entity_alias" "alice" {
  name           = "alice"
  canonical_id   = vault_identity_entity.alice.id
  mount_accessor = vault_auth_backend.userpass.accessor
}

# assuming google authenticator for this test
resource "vault_identity_mfa_totp" "totp" {
  algorithm    = "SHA256"
  issuer       = "vault"
}

# Overwrite the default TOTP configuration because method_name is not yet supported by vault_identity_mfa_totp :_(
resource "vault_generic_endpoint" "totp_config" {
  depends_on = [vault_identity_mfa_totp.totp]
  path = "identity/mfa/method/totp/${vault_identity_mfa_totp.totp.method_id}"

  data_json = jsonencode({
    issuer = "vault"
    method_name = "vault-demo-2fa"
  })

  lifecycle {
    ignore_changes = [data_json]
  }
}

# create login enforcement to bind totp mfa to userpass auth method
resource "vault_identity_mfa_login_enforcement" "totp" {
  name = "totp_enforcement"
  mfa_method_ids = [
    vault_identity_mfa_totp.totp.method_id,
  ]
  auth_method_accessors = [
    vault_auth_backend.userpass.accessor,
  ]
}

output "method_id" {
  value = vault_identity_mfa_totp.totp.method_id
}

output "entity_id" {
  value = vault_identity_entity.alice.id
}
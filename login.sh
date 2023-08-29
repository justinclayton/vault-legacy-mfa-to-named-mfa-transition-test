#!/usr/bin/env bash

passcode=$1

# Function for legacy mfa login method (=<1.10)
legacy_mfa_login() {
  vault login \
  -method=userpass \
  -path=vault-demo-2fa \
  username=alice \
  password=malice \
  passcode="${passcode}"
}

# Function for named mfa login method (>=1.13)
named_mfa_login() {
  vault login \
  -method=userpass \
  -mfa=vault-demo-2fa:"${passcode}" \
  username=alice \
  password=malice
}

main() {
  # Try first login method
  legacy_mfa_login

  # Check if the login was successful
  if [ $? -eq 0 ]; then
    echo "Login with first method successful."
  else
    echo "Login with Legacy MFA method failed. Attempting Named MFA method..."
    named_mfa_login
    
    # Check if the second login method was successful
    if [ $? -eq 0 ]; then
      echo "Login with named MFA method successful."
    else
      echo "Both methods failed. Exiting."
      exit 1
    fi
  fi
}

main
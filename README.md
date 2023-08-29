# Vault Legacy MFA to Named MFA Transition Test

This repository is meant to facilitate testing of the resilience of a conditional login script that is used to transition from Vault's Legacy MFA system to the current Login MFA system.

# Usage

`$ make vault-server`

Sets up a Vault Enterprise server using Docker (provided you have *your own* license file)

`$ make vault-setup`

Enables the userpass auth method, creates a user for testing, and configures Login MFA using TOTP

`$ make qrcode`

Goes through the QR-code-based setup for the user to connect Google Authenticator to their Vault entity

`$ ./login.sh <one time passcode>`

Tests the login script, which will try the Legacy MFA login method first, and then the newer Login MFA method if the Legacy MFA method fails.

# Todo

* Create a second Vault server of an old version where Legacy MFA is present (>=1.10), configure a user with Legacy MFA, and test the login script against that server as well. This will allow the script to be tested against both Legacy MFA and Login MFA in a single test run.

# Cleanup

`$ make clean`
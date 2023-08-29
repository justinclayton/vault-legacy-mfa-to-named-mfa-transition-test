default: vault-server

.PHONY: vault-server
vault-server:
	cd vault-server && \
	terraform init && \
	terraform apply -auto-approve
	###############################################
	# Vault server is ready. Now, grab the root
	# token from the container output and store it:
	#
	# export VAULT_TOKEN=...
	#
	# Then, to configure Vault, run:
	#
	# make vault-setup
	###############################################

.PHONY: vault-setup
vault-setup:
	cd vault-setup && \
	terraform init && \
	terraform apply -auto-approve
	###############################################
	# Vault configured. Now, to generate a QR code
	# to use with Google Authenticator, run:
	#
	# make qrcode
	###############################################

qrcode: qrcode.png

qrcode.png:
	cd vault-setup && \
	./generate-qr-code.sh
	###############################################
	# Scan this code with Google Authenticator to
	# finish setting up TOTP MFA for the test user.
	# 
	# Now you can test the login script like so:
	# 
	# ./login.sh <one_time_passcode>
	###############################################
	

clean: clean-vault-setup clean-vault-server
	rm -f vault-setup/qrcode.png

clean-vault-setup:
	cd vault-setup && \
	terraform destroy -auto-approve

clean-vault-server:
	cd vault-server && \
	terraform destroy -auto-approve
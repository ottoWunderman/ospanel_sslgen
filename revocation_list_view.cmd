@echo OFF
setlocal

call env_vars.cmd

openssl crl -in ca/revoked.crl -text -noout

pause
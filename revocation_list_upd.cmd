@echo OFF
setlocal

call env_vars.cmd

if not exist "ca\index.txt" (
type nul > ca\index.txt
)
if not exist "ca\crlnumber" (
echo 01> ca\crlnumber
)

openssl ca -gencrl -verbose -config ca/trusted.cnf -cert ca/trusted.crt -keyfile ca/trusted.key -out ca/revoked.crl

openssl crl -in ca/revoked.crl -text -noout

pause
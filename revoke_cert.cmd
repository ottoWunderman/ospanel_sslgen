@echo OFF
setlocal

call env_vars.cmd

set /p dname=Enter domain name to revoke: || set dname=test

if not exist "ca/index.txt" (
type nul >"ca/index.txt"
)

if exist "%CERTS_PATH%\%dname%.crt" (
	openssl ca -verbose -config ca/trusted.cnf -cert ca/trusted.crt -keyfile ca/trusted.key -revoke %CERTS_PATH%\%dname%.crt

	openssl ca -gencrl -verbose -config ca/trusted.cnf -name ca -cert ca/trusted.crt -keyfile ca/trusted.key -out ca/revoked.crl

	copy /Y ".\ca\revoked.crl" "..\..\domains\localhost"
)
openssl crl -in ca/revoked.crl -text -noout

pause
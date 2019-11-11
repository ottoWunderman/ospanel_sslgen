@echo OFF
setlocal

call env_vars.cmd

echo Generating OCSP response...
for /f "tokens=*" %%G in ('dir /b %CERTS_PATH%\*.crt') do (
	echo Certificate '%%G' checking...
	openssl ocsp -issuer ca/trusted.crt -CAfile ca/trusted.crt -cert %CERTS_PATH%\%%G -url http://localhost:%ocsp_port%/ -text
)

pause
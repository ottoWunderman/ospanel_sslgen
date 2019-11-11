@echo OFF
setlocal

call env_vars.cmd

echo Running OCSP server...
openssl ocsp -index ca/index.txt -CA ca/trusted.crt -rsigner ca/trusted.crt -rkey ca/trusted.key -port 0.0.0.0:%ocsp_port%

pause
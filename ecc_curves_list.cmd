@echo OFF
setlocal

call env_vars.cmd

openssl ecparam -list_curves>ecc_curves.txt

pause
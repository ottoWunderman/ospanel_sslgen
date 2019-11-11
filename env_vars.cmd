@echo OFF
set OPENSSL_CONF=..\..\modules\http\Apache_2.4-PHP_7.2-7.3-x64\conf\openssl.cnf
set PATH=%PATH%;..\..\modules\http\Apache_2.4-PHP_7.2-7.3-x64\bin
set CERTS_PATH=..

set days=730
set key_bits=2048
set ecc_curve_name=prime256v1
set pass=1
set ocsp_port=8888
define NUKE
⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣀⣀⠀⠀⣀⣤⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\\
⠀⠀⠀⣀⣠⣤⣤⣾⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣶⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀\\
⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀\\
⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⡀⠀\\
⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀\\
⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠁⠀\\
⠀⠀⠻⢿⡿⢿⣿⣿⣿⣿⠟⠛⠛⠋⣀⣀⠙⠻⠿⠿⠋⠻⢿⣿⣿⠟⠀⠀⠀⠀\\
⠀⠀⠀⠀⠀⠀⠈⠉⣉⣠⣴⣷⣶⣿⣿⣿⣿⣶⣶⣶⣾⣶⠀⠀⠀⠀⠀⠀⠀⠀\\
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠋⠈⠛⠿⠟⠉⠻⠿⠋⠉⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀\\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣷⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\\
⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣤⣤⣶⣿⣿⣷⣦⣤⣤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀\\
⠀⠀⠀⠀⢰⣿⠛⠉⠉⠁⠀⠀⠀⢸⣿⣿⣧⠀⠀⠀⠀⠉⠉⠙⢻⣷⠀⠀⠀⠀\\
⠀⠀⠀⠀⠀⠙⠻⠷⠶⣶⣤⣤⣤⣿⣿⣿⣿⣦⣤⣤⣴⡶⠶⠟⠛⠁⠀⠀⠀⠀\\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\\
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀\\
endef
export NUKE

CURL_SOURCE = https://github.com/curl/curl/archive/refs/tags/curl-8_7_1.tar.gz
OPENSSL_SOURCE = https://github.com/openssl/openssl/archive/refs/tags/openssl-3.3.0.tar.gz
RUSTLS_SOURCE = https://github.com/rustls/rustls-ffi/archive/refs/tags/v0.12.2.tar.gz
POSTGRES_SOURCE = https://ftp.postgresql.org/pub/source/v16.2/postgresql-16.2.tar.gz
CONCORD_SOURCE = https://github.com/Cogmasters/concord/archive/refs/tags/v2.2.1.tar.gz

WGET_CMD = wget -N -q --show-progress

NUM_CPUS ?= 2

BINARY_DIR = $(shell realpath ./binary)

CFLAGS = 

CONCORD_FLAGS = ""

BOT_FLAGS = '-ldiscord -lcurl -lrustls'

PACKAGE_DIR = ./packages

CC = gcc

all:
	$(MAKE) download
	$(MAKE) build
	
download:
	@echo "Downloading dependencies..."
	@echo "Downloading libCURL..."
	$(WGET_CMD) $(CURL_SOURCE) -O $(PACKAGE_DIR)/curl.tar.gz
	@echo "Downloading OpenSSL..."
	$(WGET_CMD) $(OPENSSL_SOURCE) -O $(PACKAGE_DIR)/openssl.tar.gz 
	@echo "Downloading rustls..."
	$(WGET_CMD) $(RUSTLS_SOURCE) -O $(PACKAGE_DIR)/rustls.tar.gz
	@echo "Downloading PostgreSQL..."
	$(WGET_CMD) $(POSTGRES_SOURCE) -O $(PACKAGE_DIR)/postgres.tar.gz
	@echo "Downloading Concord..."
	$(WGET_CMD) $(CONCORD_SOURCE) -O $(PACKAGE_DIR)/concord.tar.gz

nuke:
	rm -rf packages/* binary/*
	echo "*\n!.gitignore" >> ./packages/.gitignore
	echo "*\n!.gitignore" >> ./binary/.gitignore
	@echo "$$NUKE"


build:
	@echo "Building dependencies..."
	$(MAKE) build-openssl
	$(MAKE) build-rustls
	$(MAKE) build-libcurl
	$(MAKE) build-postgres
	$(MAKE) build-concord

build-openssl:
	@echo "Building OpenSSL..."
	@cd ./packages/ ; \
	tar zxf openssl.tar.gz \
	--one-top-level=openssl \
	--strip-components=1 ; \
	cd openssl ; \
	./config --static -static no-shared -DPEDANTIC \
	--prefix=$(BINARY_DIR) \
	--openssldir=$(BINARY_DIR) ; \
	$(MAKE) -j$(NUM_CPUS) ; \
	$(MAKE) install
	@echo "Done building OpenSSL..."
	

build-rustls:
	@echo "Building rustls..."
	@cd ./packages/ ; \
	tar zxf rustls.tar.gz \
	--one-top-level=rustls \
	--strip-components=1 ; \
	cd rustls ; \
	$(MAKE) -j$(NUM_CPUS) ; \
	$(MAKE) install DESTDIR=$(BINARY_DIR)
	@echo "Done building rustls" 

build-libcurl:
	@echo "Building libCURL..."
	@cd ./packages/ ; \
	tar zxf curl.tar.gz \
	--one-top-level=curl \
	--strip-components=1 ; \
	cd curl ; \
	autoreconf -fi ; \
	./configure --with-rustls=$(BINARY_DIR) \
	--prefix=$(BINARY_DIR) \
	--enable-optimize \
	--enable-warnings \
	--enable-werror \
	--disable-websockets \
	--disable-docs \
	--disable-manual \
	--disable-dependency-tracking \
	--disable-aws \
	--disable-ntlm \
	--disable-ntlm-wb \
	--disable-tls-srp \
	--disable-doh \
	--disable-hsts \
	--disable-ftp \
	--disable-file \
	--disable-ldap \
	--disable-ldaps \
	--disable-rtsp \
	--disable-proxy \
	--disable-dict \
	--disable-telnet \
	--disable-pop3 \
	--disable-tftp \
	--disable-imap \
	--disable-smb \
	--disable-smtp \
	--disable-gopher \
	--disable-mqtt \
	--disable-sspi ; \
	$(MAKE) -j$(NUM_CPUS) ; \
	$(MAKE) install
	@echo "Done building libCURL..."

build-postgres:
	@echo "Building PostgreSQL..."
	@cd ./packages ; \
	tar zxf postgres.tar.gz \
	--one-top-level=postgres \
	--strip-components=1 ; \
	cd postgres ; \
	CFLAGS="-O3 -fPIC" ./configure \
	--prefix=$(BINARY_DIR) \
	--with-includes=$(BINARY_DIR)/include \
	--with-libraries="$(BINARY_DIR)/lib $(BINARY_DIR)/lib64" \
	--without-icu --without-readline --without-zlib ; \
	BUILD_IN_SOURCE=1 $(MAKE) MAKELEVEL=0 -j$(NUM_CPUS) ; \
	$(MAKE) install
	@echo "Done building PostgreSQL..."

build-concord:
	@echo "Building Concord..."
	@cd ./packages ; \
	tar xzf concord.tar.gz \
	--one-top-level=concord \
	--strip-components=1 ; \
	cd concord ; \
	CFLAGS="-I$(BINARY_DIR)/include -DCCORD_SIGINTCATCH -fPIC -O3 -static" \
	LDFLAGS="-L$(BINARY_DIR)/lib -L$(BINARY_DIR)/lib64" \
	$(MAKE) -j$(NUM_CPUS) ; \
	PREFIX=$(BINARY_DIR) $(MAKE) install
	@echo "Done building Concord..."

bot:
	@echo "Building bot..."
	CFLAGS = $(CFLAGS) \
	LDFLAGS = $(LDFLAGS) \
	
	$(CC) -o main src/main.c

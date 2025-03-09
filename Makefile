.ONESHELL:

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

# Directory definitions
BINARY_DIR = $(shell realpath ./binary)
PACKAGE_DIR = $(shell realpath ./packages)
VAR_DIR = $(shell realpath ./var)


# Package definitions
CURL_SOURCE = https://github.com/curl/curl/archive/refs/tags/curl-8_7_1.tar.gz
CURL_TAR = $(PACKAGE_DIR)/curl.tar.gz

OPENSSL_SOURCE = https://github.com/openssl/openssl/archive/refs/tags/openssl-3.3.0.tar.gz
OPENSSL_TAR = $(PACKAGE_DIR)/openssl.tar.gz
OPENSSL_CONFIGURE_CMD = ./config --static -static no-docs no-tests no-deprecated no-shared --prefix=$(BINARY_DIR) --openssldir=$(BINARY_DIR)

POSTGRES_SOURCE = https://ftp.postgresql.org/pub/source/v16.2/postgresql-16.2.tar.gz
POSTGRES_TAR = $(PACKAGE_DIR)/postgres.tar.gz

CONCORD_GIT = git@github.com:Cogmasters/concord.git


WGET_CMD = wget -N -q --show-progress
NUM_CPUS ?= $(shell nproc)


# Compiler flags
CFLAGS := -I$(BINARY_DIR)/include
LDFLAGS := -L$(BINARY_DIR)/lib -L$(BINARY_DIR)/lib64
CONCORD_FLAGS := -DCCORD_SIGINTCATCH -fPIC -O3 --static -static
BOT_FLAGS := -ldiscord -lcurl -lssl -lcrypto -fPIC -O3 --static -static
CC := gcc

all:
	@echo "Available targets: download, build, nuke"
	@echo "Use 'make download' to download dependencies"
	@echo "Use 'make build' to build all components"
	@echo "Use 'make bot' to build the bot"
	@echo "Use 'make nuke' clean everything"

download:
	@echo "Downloading dependencies..."
	
	if [ ! -f $(VAR_DIR)/LIBCURL_SRC ]; then
		echo "Downloading libCURL..."
		$(WGET_CMD) $(CURL_SOURCE) -O $(CURL_TAR)
		touch $(VAR_DIR)/LIBCURL_SRC
	else
		echo "libCURL source already exists."
	fi
	
	if [ ! -f $(VAR_DIR)/OPENSSL_SRC ]; then
		echo "Downloading OpenSSL..."
		$(WGET_CMD) $(OPENSSL_SOURCE) -O $(OPENSSL_TAR)
		touch $(VAR_DIR)/OPENSSL_SRC
	else
		echo "OpenSSL source already exists."
	fi
	
	if [ ! -f $(VAR_DIR)/POSTGRES_SRC ]; then
		echo "Downloading PostgreSQL..."
		$(WGET_CMD) $(POSTGRES_SOURCE) -O $(POSTGRES_TAR)
		touch $(VAR_DIR)/POSTGRES_SRC
	else
		echo "PostgreSQL source already exists."
	fi

nuke:
	@echo "Cleaning $(PACKAGE_DIR) $(BINARY_DIR) $(VAR_DIR)"
	@echo "$$NUKE"
	rm -rf $(PACKAGE_DIR)/* $(BINARY_DIR)/* $(VAR_DIR)/*

build: build-openssl build-libcurl build-postgres build-concord
	@echo "All dependencies built successfully!"

build-openssl:
	@echo "Building OpenSSL..."
	
	if [ ! -f $(VAR_DIR)/OPENSSL_EXTRACT ]; then
		mkdir -p $(PACKAGE_DIR)/openssl
		tar zxf $(OPENSSL_TAR) \
		--one-top-level=$(PACKAGE_DIR)/openssl \
		--strip-components=1
		touch $(VAR_DIR)/OPENSSL_EXTRACT
	else
		echo "OpenSSL was already extracted"
	fi
	
	if [ ! -f $(VAR_DIR)/OPENSSL_CONFIGURED ]; then
		cd $(PACKAGE_DIR)/openssl
		$(OPENSSL_CONFIGURE_CMD)
		$(MAKE) -j$(NUM_CPUS)
		$(MAKE) -j$(NUM_CPUS) install
		touch $(VAR_DIR)/OPENSSL_CONFIGURED
		echo "Done building OpenSSL..."
	else
		echo "OpenSSL was already built"
	fi

build-libcurl:
	@echo "Building libCURL..."
	
	mkdir -p $(PACKAGE_DIR)/curl
	cd $(PACKAGE_DIR)/
	tar zxf $(CURL_TAR) \
	--one-top-level=curl \
	--strip-components=1
	
	cd curl
	autoreconf -fi
	./configure --prefix=$(BINARY_DIR) --with-openssl=$(BINARY_DIR) \
	--disable-debug \
	--disable-curldebug \
	--disable-symbol-hiding \
	--disable-rt \
	--disable-ech \
	--disable-dependency-tracking \
	--disable-websockets \
	--disable-docs \
	--disable-manual \
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
	--disable-sspi \
	--disable-threaded-resolver \
	--disable-alt-svc \
	--disable-headers-api \
	--enable-shared=no
	
	$(MAKE) -j$(NUM_CPUS)
	$(MAKE) install
	@echo "Done building libCURL..."

build-postgres:
	@echo "Building PostgreSQL..."
	
	mkdir -p $(PACKAGE_DIR)/postgres
	cd $(PACKAGE_DIR)
	tar zxf $(POSTGRES_TAR) \
	--one-top-level=postgres \
	--strip-components=1
	
	cd postgres
	CFLAGS="-O3 -fPIC --static -static" ./configure \
	--prefix=$(BINARY_DIR) \
	--with-includes=$(BINARY_DIR)/include \
	--with-libraries="$(BINARY_DIR)/lib $(BINARY_DIR)/lib64" \
	--without-icu --without-readline --without-zlib
	
	BUILD_IN_SOURCE=1 $(MAKE) MAKELEVEL=0 -j$(NUM_CPUS)
	$(MAKE) install
	@echo "Done building PostgreSQL..."

build-concord:
	@echo "Building Concord..."
	cd $(PACKAGE_DIR)
	git clone $(CONCORD_GIT) -b dev	
	cd concord
	CFLAGS="-I$(BINARY_DIR)/include -DCCORD_SIGINTCATCH -fPIC -O3 -static --static" \
	LDFLAGS="-L$(BINARY_DIR)/lib -L$(BINARY_DIR)/lib64" \
	$(MAKE) -j$(NUM_CPUS)
	
	PREFIX=$(BINARY_DIR) $(MAKE) install
	@echo "Done building Concord..."

bot:
	@echo "Building bot..."
	$(CC) -o main src/main.c $(CFLAGS) $(LDFLAGS) -O3 $(CONCORD_FLAGS) $(BOT_FLAGS)
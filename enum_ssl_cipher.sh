#!/usr/bin/env bash

# logging
G="\033[1;32m"  # GREEN
Y="\033[1;33m"  # YELLOW
R="\033[1;31m"  # RED
NC="\033[0m"    # NO COLOR

# OpenSSL requires the port number.
SERVER=$1
DELAY=1
ciphers=$(openssl ciphers 'ALL:eNULL' | sed -e 's/:/ /g')
tls_versions=(tls1 tls1_1 tls1_2 tls1_3)

declare -a cipher_tls1=()
declare -a cipher_tls1_1=()
declare -a cipher_tls1_2=()
declare -a cipher_tls1_3=()

echo Obtaining cipher list from $(openssl version).

for tls_version in ${tls_versions[@]}; do
    for cipher in ${ciphers[@]}
        do
        echo -n Testing $tls_version: $cipher...
        result=$(echo -n | openssl s_client "-$tls_version" -cipher "$cipher" -connect $SERVER 2>&1)
        
        if [[ "$result" =~ ":error:" ]] ; then
            error=$(echo -n $result | cut -d':' -f6)
            printf "${Y}NO ($error)${NC}\n"
        else
            if [[ "$result" =~ "Cipher is ${cipher}" ]] ; then
                printf "${G}YES${NC}\n"

                case "$tls_version" in
                    "tls1")
                        cipher_tls1+=("$cipher")
                        ;;
                    "tls1_1")
                        cipher_tls1_1+=("$cipher")
                        ;;
                    "tls1_2")
                        cipher_tls1_2+=("$cipher")
                        ;;
                    "tls1_3")
                        cipher_tls1_3+=("$cipher")
                        ;;
                    *)
                        echo "Error: unknown TLS version: ($tls_version)" >&2
                        exit 1
                        ;;
                esac
            else
                printf "${Y}No cipher match ${NC}\n"
                #echo $result
            fi
        fi
        #sleep $DELAY
    done
done

echo "Cipher TLS1.0 supported: ${cipher_tls1[@]}"
echo "Cipher TLS1.1 supported: ${cipher_tls1_1[@]}"
echo "Cipher TLS1.2 supported: ${cipher_tls1_2[@]}"
echo "Cipher TLS1.3 supported: ${cipher_tls1_3[@]}"
#!/bin/bash

if [ "$#" -gt 0 ]; then
    # Inicialização do container
    if [ $1 = "run" ]; then
        echo 'Inicializando container...'
        docker-compose up
    fi
    # Abrir terminal em modo interativo
    if [ $1 = "bash" ]; then
        echo 'Terminal do container aberto em modo interativo'
        echo 'Para sair digite exit'
        docker exec -it pg_container /bin/bash
    fi
    # Povoar servidor postgres com os arquivos tabela.sql e inserts.sql
    if [ $1 = "pop" ]; then
        echo 'Populando servidor...'
        docker exec -it pg_container /bin/bash -c \
        "cd files/ && \
        psql -U root -d test_db -f ./tabelas.sql && \
        psql -U root -d test_db -f ./inserts.sql"
        echo "Dados inseridos com sucesso."
    fi
    # Restaurando tabelas para o estado original
    if [ $1 = "reset" ]; then
        echo 'Removendo tabelas do servidor...'
        docker exec -it pg_container /bin/bash -c \
        "psql -U root -d test_db -c \
        \"DROP SCHEMA IF EXISTS public CASCADE; \
        CREATE SCHEMA IF NOT EXISTS public;\""

        echo 'Adicionando novamente...'
        docker exec -it pg_container /bin/bash -c \
        "cd files/ && \
        psql -U root -d test_db -f ./tabelas.sql && \
        psql -U root -d test_db -f ./inserts.sql"
        echo 'Tabelas restauradas'
    fi    
    if [ $1 = "stop" ]; then
        echo 'Finalizando execução...'
        docker-compose stop
    fi
fi
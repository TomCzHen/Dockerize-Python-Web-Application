#!/usr/bin/env bash

retry_times=0
sleep_sec=5

check_database_uri() {
    local database_uri="${DATABASE_DRIVER}://${DATABASE_USER}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_NAME}"

    if [[ -z "${database_uri}" ]]; then
        echo "SQLALCHEMY_DATABASE_URI not set or empty"
        exit 1
    fi

    python -c "from sqlalchemy import create_engine;engine = create_engine('${database_uri}');conn=engine.connect();conn.execute('SELECT 1');conn.close()"

}

main() {

    if [[ ${1} = "uwsgi" && ${#} = 1 ]];then

        until check_database_uri; do
            if [[ ${retry_times} -lt 3 ]]; then
                >&2 echo "Database server is unavailable - retry after ${sleep_sec} sec"
                retry_times=$((${retry_times} + 1))
                sleep ${sleep_sec}
            else
                exit 1
            fi
        done
    fi

    exec $@
}

main "$@"
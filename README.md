# Setup for config_server

## Create a Virtualenv

    mkdir config_server
    cd config_server
    virtualenv venv
    source venv/bin/activate

## Install Dependencies

    pip3 install flask

## Test

    export FLASK_APP=config_server export FLASK_ENV=development
    flask run


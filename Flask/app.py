#!/usr/bin/env python3
from flask import Flask
from model import db
from flask import render_template
from os import environ

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f"{environ['DATABASE_DRIVER']}://" \
    f"{environ['DATABASE_USER']}:{environ['DATABASE_PASSWORD']}@" \
    f"{environ['DATABASE_HOST']}:{environ['DATABASE_PORT']}/{environ['DATABASE_NAME']}"

db.init_app(app)


@app.route("/")
def hello():
    info = db.session.execute('SELECT version();').first()
    return render_template('index.jinja2', info=info)

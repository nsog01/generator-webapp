from flask import Flask, redirect, url_for
from flask_restful import Api
from flask_jwt import JWT

from apispec import APISpec
from marshmallow import Schema, fields
from apispec.ext.marshmallow import MarshmallowPlugin
from flask_apispec.extension import FlaskApiSpec
from flask_apispec.views import MethodResource
from flask_apispec import marshal_with, doc, use_kwargs


from security import authenticate, identity
from resources.user import UserRegister
{%- for key in data %}
from resources.{{key['name']}} import {{key['name']}}, {{key['name']}}List
{%- endfor %}

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['PROPAGATE_EXCEPTIONS'] = True
app.secret_key = 'foobar'
app.config.update({
    'APISPEC_SPEC': APISpec(
        title='Webapp-generator',
        version='v1',
        plugins=[MarshmallowPlugin()],
        openapi_version='2.0.0'
    ),
    'APISPEC_SWAGGER_URL': '/swagger/',  # URI to access API Doc JSON
    'APISPEC_SWAGGER_UI_URL': '/swagger-ui/'  # URI to access UI of API Doc
})

api = Api(app)


@app.before_first_request
def create_tables():
    db.create_all()


jwt = JWT(app, authenticate, identity)  


{%- for key in data %}
api.add_resource({{key['name']}}List, '/{{key['name']|lower}}s')
api.add_resource({{key['name']}}, '/{{key['name']|lower}}/<int:id>', '/{{key['name']|lower}}/')
{%- endfor %}
api.add_resource(UserRegister, '/register')

docs = FlaskApiSpec(app)
{%- for key in data %}
docs.register({{key['name']}}List)
docs.register({{key['name']}})
{%- endfor %}

@app.route('/')
def index():
    return redirect(url_for('flask-apispec.swagger-ui'))
    

if __name__ == '__main__':
    from db import db
    db.init_app(app)
    app.run(port=5000, debug=True)

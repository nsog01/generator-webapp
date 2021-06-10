from flask import Flask
from flask_restful import Api
from flask_jwt import JWT

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
api = Api(app)


@app.before_first_request
def create_tables():
    db.create_all()


jwt = JWT(app, authenticate, identity)  


{%- for key in data %}
api.add_resource({{key['name']}}List, '/{{key['name']|lower}}s')
api.add_resource({{key['name']}}, '/{{key['name']|lower}}/<int:id>')
{%- endfor %}
api.add_resource(UserRegister, '/register')

if __name__ == '__main__':
    from db import db
    db.init_app(app)
    app.run(port=5000, debug=True)

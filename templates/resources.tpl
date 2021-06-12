from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from models.{{data['name']}} import {{data['name']}}Model
from apiModels.{{data['name']}} import {{data['name']}}ApiModel

from apispec import APISpec
from marshmallow import Schema, fields
from apispec.ext.marshmallow import MarshmallowPlugin
from flask_apispec.extension import FlaskApiSpec
from flask_apispec.views import MethodResource
from flask_apispec import marshal_with, doc, use_kwargs
from marshmallow import Schema, fields

api_response_schema = {{data['name']}}ApiModel()

class {{data['name']}}(MethodResource, Resource):
    parser = reqparse.RequestParser()
    {%- for key in data['properties']%}
    {%- if data['properties'][key]['required'] | upper == 'TRUE'%}
    parser.add_argument('{{key}}',
                        type={{dic[data['properties'][key]['type']]}},
                        required=True,
                        help="Ce champ ne peut être vide"
                        )
    {%- endif%}
    {%- endfor %}
    
    @doc(description='GET {{data['name'] | upper}}', tags=['{{data['name'] | upper}}'])
    @use_kwargs({{data['name']}}ApiModel, location=('json'))
    @marshal_with(api_response_schema) 
    def get(self, id):
        item = {{data['name']}}Model.find_by_id(id)
        if item:
            return item.json(), 200
        return {'message': 'non trouvé(e)'}, 404

    @doc(description='POST {{data['name'] | upper}}', tags=['{{data['name'] | upper}}'])
    @use_kwargs({{data['name']}}ApiModel, location=('json'))
    @marshal_with(api_response_schema) 
    def post(self):
        data = {{data['name']}}.parser.parse_args()
        item = {{data['name']}}Model(**data)
        try:
            item.save_to_db()
        except:
            return {"message": "erreur insertion"}, 500
        return item.json(), 201

    @doc(description='DELETE {{data['name'] | upper}}', tags=['{{data['name'] | upper}}'])
    @use_kwargs({{data['name']}}ApiModel, location=('json'))
    @marshal_with(api_response_schema) 
    def delete(self, id):
        item = {{data['name']}}Model.find_by_id(id)
        if item:
            item.delete_from_db()
            return {'message': 'supprimé(e)'}
        return {'message': 'non trouvé(e)'}, 404
    
    @doc(description='PUT {{data['name'] | upper}}', tags=['{{data['name'] | upper}}'])
    @use_kwargs({{data['name']}}ApiModel, location=('json'))
    @marshal_with(api_response_schema) 
    def put(self, id):
        pass


class {{data['name']}}List(Resource):
    def get(self):
        return {'{{data['name']}}': list(map(lambda x: x.json(), {{data['name']}}Model.query.all()))}

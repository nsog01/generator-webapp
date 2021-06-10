from flask_restful import Resource, reqparse
from flask_jwt import jwt_required
from models.{{data['name']}} import {{data['name']}}Model


class {{data['name']}}(Resource):
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
    def get(self, id):
        item = {{data['name']}}Model.find_by_id(id)
        if item:
            return item.json(), 200
        return {'message': 'non trouvé(e)'}, 404


    def post(self, id):
        if {{data['name']}}Model.find_by_id(id):
            return {'message': "déjà existant(e)"}, 400
        data = {{data['name']}}.parser.parse_args()
        item = {{data['name']}}Model(**data)
        try:
            item.save_to_db()
        except:
            return {"message": "erreur insertion"}, 500
        return item.json(), 201

    def delete(self, id):
        item = {{data['name']}}Model.find_by_id(id)
        if item:
            item.delete_from_db()
            return {'message': 'supprimé(e)'}
        return {'message': 'non trouvé(e)'}, 404

    def put(self, id):
        pass


class {{data['name']}}List(Resource):
    def get(self):
        return {'{{data['name']}}': list(map(lambda x: x.json(), {{data['name']}}Model.query.all()))}

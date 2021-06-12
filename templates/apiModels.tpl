from marshmallow import Schema, fields

class {{data['name']}}ApiModel(Schema):
    id = fields.Integer()
    {%- for key in data['properties']%}
    {{key}} = fields.{{data['properties'][key]['type']}}()
    {%- endfor %}

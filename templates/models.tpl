from db import db


class {{data['name']}}Model(db.Model):
    __tablename__ = '{{data['name']}}'
    id = db.Column(db.Integer, primary_key=True)
    {%- for key in data['properties']%}
    {{key}} = db.Column(db.{{data['properties'][key]['type']}}, unique={{data['properties'][key]['unique']|title}}, nullable={{not data['properties'][key]['required']|title}})
    {%- endfor %}
    
    def __init__(self, {%for key in data['properties']%}{{key}}{%if not loop.last %}, {%endif%} {%- endfor %}):
        {%- for key in data['properties']%}
        self.{{key}} = {{key}}
        {%- endfor %}


    def json(self):
        return { 'id':self.id,
        {%-for key in data['properties']%}
        '{{key}}':self.{{key}}{%if not loop.last %},{%endif%}
        {%- endfor %} 
        }
         
    @classmethod    
    def find_by_id(cls, id):
        return cls.query.filter_by(id=id).first()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()

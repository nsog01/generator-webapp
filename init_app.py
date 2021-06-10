import os.path
import json


schema_folder = './schema/'
models_folder = './models/'
templates_folder = './templates/'
app_template_file = 'app.tpl'



def charger_fichier(nomfichier):
   with open(nomfichier,'r') as fp:
     r = fp.read()
   return r


ll = [json.loads(charger_fichier(schema_folder+name)) for name in os.listdir(schema_folder)]
from jinja2 import Environment, FileSystemLoader

env = Environment(loader=FileSystemLoader(templates_folder))

template = env.get_template(app_template_file)
with open('app.py', "w") as fh:
  fh.write(template.render(data=ll))

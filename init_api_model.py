import os.path
import json


schema_folder = './schema/'
apiModel_folder = './apiModels/'
templates_folder = './templates/'
apiModel_template_file = 'apiModels.tpl'


def charger_fichier(nomfichier):
   with open(nomfichier,'r') as fp:
     r = fp.read()
   return r


ll = [json.loads(charger_fichier(schema_folder+name)) for name in os.listdir(schema_folder)]

from jinja2 import Environment, FileSystemLoader

env = Environment(loader=FileSystemLoader(templates_folder))

for i in range(len(ll)):
  template = env.get_template(apiModel_template_file)
  with open(apiModel_folder+ll[i]['name']+'.py', "w") as fh:
     fh.write(template.render(data=ll[i]))

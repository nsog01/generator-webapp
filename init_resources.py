import os.path
import json


schema_folder = './schema/'
resources_folder = './resources/'
templates_folder = './templates/'
resources_template_file = 'Resources.tpl'



dic = {"String":"str", "Integer":"int", "true":"True", "false":"False"}

    
def charger_fichier(nomfichier):
   with open(nomfichier,'r') as fp:
     r = fp.read()
   return r


ll = [json.loads(charger_fichier(schema_folder+name)) for name in os.listdir(schema_folder)]

from jinja2 import Environment, FileSystemLoader

env = Environment(loader=FileSystemLoader(templates_folder))

for i in range(len(ll)):
  template = env.get_template(resources_template_file)
  with open(resources_folder+ll[i]['name']+'.py', "w") as fh:
     fh.write(template.render(data=ll[i], dic=dic))

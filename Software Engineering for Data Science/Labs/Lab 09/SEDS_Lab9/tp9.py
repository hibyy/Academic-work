from fastapi import FastAPI, Path ,Query ,Body , Form , File ,UploadFile ,Header ,Request ,Response, status, HTTPException
from enum import Enum
from typing import List


#cette instance qui va gérer les routes (les URL de l'API).

app = FastAPI()
# Creating a GET endpoint at the root path
@app.get("/")
async def hello_world():
 return {"hello": "world"}

@app.get("/users/{id}")
async def get_user(id: int):
 return {"id": id}

class UserType(str, Enum):
 STANDARD = "standard"
 ADMIN = "admin"
@app.get("/users/{type}/{id}/")
async def get_user(type: UserType, id: int):
 return {"type": type, "id": id}


#Path est utilisé pour définir une contrainte supplémentaire pour les paramètres de chemin
# La valeur de id doit être supérieure ou égale à 1
@app.get("/users/{id}")
async def get_user(id: int = Path(..., ge=1)):
 return {"id": id}


#Le paramètre license doit être une chaîne de caractères.
#5 chiffres, un tiret (-), 3 chiffres, un autre tiret, et 2 chiffres.

@app.get("/license-plates/{license}")
async def get_license_plate(license: str = Path(...,  #Le ... signifie que ce paramètre est requis 
pattern=r"^\d{5}-\d{3}-\d{2}$")):
 return {"license": license}


@app.get("/users")
async def get_user(page: int = 1, size: int = 10):
 return {"page": page, "size": size}


#Query pour validation des paramètres de requête =>  ?page=1&size=10
@app.get("/users")
async def get_user(page: int = Query(1, gt = 0),
size: int = Query(10, le = 100)):
 return {"page": page, "size": size}


#----------------------------------------

#Body => create structured objects in a database (on format JSON)

@app.post("/users")
async def create_user(name: str = Body(...),
age: int = Body(...)):
 return {"name": name, "age": age}


#Form => formulaire HTML(name=Alice&age=30)????????????????

@app.post("/createUser")
async def create_user(name: str = Form(...),
age: int = Form(...)):
 return {"name": name, "age": age}


#Byte => Charge toute la mémoire , fichiers sont petits
@app.post("/files")
async def upload_file(file: bytes = File(...)):
 return {"file_size": len(file)}


#UploadFile =>  fichiers volumineux , un accès direct au contenu.
@app.post("/uploadFile")
async def upload_file(file: UploadFile = File(...)):
 return {"file_name": file.filename,
"content_type": file.content_type}


@app.post("/uploadMultipleFiles")
async def upload_multiple_files(files: List[UploadFile]=File(...)):
 return [
{"file_name": file.filename,
"content_type": file.content_type}
for file in files
]

#informations détaillées sur le logiciel client, le système d'exploitation,
#et parfois l'appareil ou la version.
@app.get("/getHeader")
async def get_header(user_agent: str = Header(...)):
 return {"user_agent": user_agent}


@app.get("/request")
async def get_request_object(request: Request):
 return {"path": request.url.path}


@app.get("/setCookie")
async def custom_cookie(response: Response):
 response.set_cookie("cookie-name","cookie-value",max_age=86400)
 return {"hello": "world"}


@app.post("/password")
async def check_password(password: str = Body(...),
 password_confirm: str = Body(...)):
 if password != password_confirm:raise HTTPException(status.HTTP_400_BAD_REQUEST,detail="Passwords don't match.",)
 return {"message": "Passwords match."}


from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="templates")
@app.get("/reply")
async def home(request: Request):
 return templates.TemplateResponse("/index.html",{"request":request})




import pandas as pd
import json
app = FastAPI()
templates = Jinja2Templates(directory="templates")
@app.get("/houseprices")
async def home(request: Request):
 df = pd.read_csv("data/house_pricing.csv", nrows=25)
 js = df.to_json(orient="records")
 data=json.loads(js)
 return templates.TemplateResponse("/houseprices.html",{"request":request,"house_prices":data})

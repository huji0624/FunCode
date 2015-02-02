#!/usr/bin/python

import os
import json

titles=dict()
lessons="lessons"
dirs=os.listdir(lessons)
for d in dirs:
	if d.startswith("lesson"):
		f = file(lessons+"/"+d+"/content.html","r")
		html=f.read()
		f.close()
		s=html.find("<h3")
		e=html.find("</h3>")
		t=html[s:e]
		title=t.split(">")[1].strip()
		titles[d]=title
text=json.dumps(titles,ensure_ascii=False)
f=file("lts.json","w")
f.write(text)
f.close()
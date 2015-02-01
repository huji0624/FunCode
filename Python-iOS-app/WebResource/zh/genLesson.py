#!/usr/bin/python
# -*- coding:utf8 -*-

template = \
'''

<html>
<head>
<meta charset='utf-8'>
<link href="../../../bootstrap/css/bootstrap.css" rel="stylesheet">
<link href="../../../bootstrap/css/bootstrap-theme.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
	<div class="row-fluid">
		<div class="span12">
			<h3 class="text-center text-success">
				标题
			</h3>
			<p class="text-danger text-left">
				前言
			</p>
			<p class="text-info">
				讲解
			</p>
			<p class="text-warning">
				<em>题目</em>
			</p>
			<p>
				<em>输出</em>
			</p>
		</div>
	</div>
</div>
</body>
</html>
'''

import sys
import os

if len(sys.argv)!=2:
	print ".py lessonnumber"
	exit(1)

lesson = sys.argv[1]

destdirpath = "lessons/lesson%s" % (lesson)
destcontentpaht = destdirpath + "/content.html"

if os.path.exists(destcontentpaht):
	print "exists lesson " + lesson
else:
	if not os.path.exists(destdirpath):
		os.mkdir(destdirpath)
	cf = file(destcontentpaht,"w")
	cf.write(template)
	cf.close()
	print "create %s" % (destcontentpaht)

	
	

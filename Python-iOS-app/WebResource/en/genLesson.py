import sys
import os

lesson = sys.argv[1]

if os.path.exists("lessons/lesson%s" % (lesson)):
	print "exists lesson " + lesson
else:
	pass
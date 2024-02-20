# -*- coding: utf-8 -*-

from __future__ import with_statement

import os, sys

scintillaDirectory = os.path.join("..", "..", "scintilla", "include")
sys.path.append(scintillaDirectory)
import Face

def cell(s):
	return "<td>%s</td>" % s

def faceFeatures(out):
	out.write("<h2>Scintilla key commands</h2>\n")
	out.write("<table>\n")
	out.write("<thead>%s%s%s</thead>\n" % (cell("Command"), cell("Name"), cell("Explanation")))
	face = Face.Face()
	face.ReadFromFile(os.path.join(scintillaDirectory, "Scintilla.iface"))
	texts = []
	for name in face.features:
		#~ print name
		f = face.features[name]
		if f["FeatureType"] == "fun" and \
			f["ReturnType"] == "void" and \
			not (f["Param1Type"] or f["Param2Type"]):
			texts.append([name, f["Value"], " ".join(f["Comment"])])
	texts.sort()
	for t in texts:
		out.write("<tr>%s%s%s</tr>\n" % (cell(t[1]), cell(t[0]), cell(t[2])))
	out.write("</table>\n")

def menuFeatures(out):
	out.write("<h2>SciTE menu commands</h2>\n")
	out.write("<table>\n")
	out.write("<thead>%s%s</thead>\n" % (cell("Command"), cell("Menu text")))
	with open(os.path.join("..", "win32", "SciTERes.rc"), "rt") as f:
		for l in f:
			l = l.strip()
			if l.startswith("MENUITEM") and "SEPARATOR" not in l:
				l = l.replace("MENUITEM", "").strip()
				text, symbol = l.split('",', 1)
				symbol = symbol.strip()
				text = text[1:].replace("&", "").replace("...", "")
				if "\\t" in text:
					text = text.split("\\t",1)[0]
				if text:
					out.write("<tr><td>%s</td><td>%s</td></tr>\n" % (symbol, text))
	out.write("</table>\n")

startFile = """
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--Generated by scite/scripts/commandsdoc.py -->
<style type="text/css">
    table { border: 1px solid #1F1F1F; border-collapse: collapse; }
    td { border: 1px solid; border-color: #E0E0E0 #000000; padding: 1px 5px 1px 5px; }
    th { border: 1px solid #1F1F1F; padding: 1px 5px 1px 5px; }
    thead { background-color: #000000; color: #FFFFFF; }
</style>
<body>
"""

if __name__ == "__main__":
	with open(os.path.join("..", "doc", "CommandValues.html"), "w") as out:
		out.write(startFile)
		menuFeatures(out)
		faceFeatures(out)
		out.write("</body>\n</html>\n")

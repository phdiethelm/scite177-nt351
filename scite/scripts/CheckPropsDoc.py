# CheckMentioned.py
# Find all the properties used in SciTE source files and check if they
# are mentioned in scite/doc/SciTEDoc.html.

import os
import string
import stat

srcRoot = "../../scite"
srcDir = os.path.join(srcRoot, "src")
docFileName = os.path.join(srcRoot, "doc", "SciTEDoc.html")
propsFileName = os.path.join(srcDir, "SciTEGlobal.properties")
identCharacters = "_*." + string.letters + string.digits

# Convert all punctuation characters except '_', '*', and '.' into spaces.
def depunctuate(s):
	d = ""
	for ch in s:
		if ch in identCharacters:
			d = d + ch
		else:
			d = d + " "
	return d

srcPaths = []
for filename in os.listdir(srcRoot):
	dirname = os.path.join(srcRoot, filename)
	if stat.S_ISDIR(os.stat(dirname)[stat.ST_MODE]):
		for src in os.listdir(dirname):
			if ".cxx" in src:
				srcPaths.append(dirname + os.sep + src)

propertiesPaths = []
for src in os.listdir(srcDir):
	if ".properties" in src and \
		"Embedded" not in src and \
		"SciTE.properties" not in src and \
		".bak" not in src:
		propertiesPaths.append(os.path.join(srcDir, src))

def nameOKSrc(src):
	if os.path.splitext(srcPath)[1] not in [".cxx", ".h"]:
		return False
	if "lua" in srcPath.lower():
		return False
	if "IFaceTable" in srcPath:
		return False
	if "Exporters" in srcPath:
		return False
	return True

def grabQuoted(s):
	if '"' in s:
		s = s[s.find('"')+1:]
		if '"' in s:
			return s[:s.find('"')]
	return ""

def stripComment(s):
	if "//" in s:
		return s[:s.find("//")]
	return s

propertyNames = {}
literalStrings = set()
dontLook = False	# ignore contributor names as they don't get localised
#print srcPaths
for srcPath in srcPaths:
	srcFile = open(srcPath)
	for srcLine in srcFile.readlines():
		srcLine = stripComment(srcLine).strip()
		if '"' in srcLine and "props" in srcLine and ("Get" in srcLine or "ColourOfProperty" in srcLine):
			parts = srcLine.split('\"')
			#print parts
			if len(parts) > 1:
				propertyName = parts[1]
				if propertyName:
					propertyNames[propertyName] = 0
					#print propertyName
		if '"' in srcLine and nameOKSrc(srcPath):
			if "Atsuo" in srcLine or '{"IDM_' in srcLine or dontLook:
				dontLook = ";" not in srcLine
			elif not srcLine.startswith("#") and \
				not srcLine.startswith("//") and \
				"SendDirector" not in srcLine and \
				"gtk_signal_connect" not in srcLine:
				srcLine = grabQuoted(srcLine)
				if srcLine:
					if srcLine[:1] not in ["<"]:
						literalStrings.add(srcLine)
	srcFile.close()

docFile = open(docFileName, "rt")
for docLine in docFile.readlines():
	for word in depunctuate(docLine).split():
		if word in propertyNames.keys():
			propertyNames[word] = 1
docFile.close()

print "# Not mentioned in", docFileName
identifiersSorted = sorted(propertyNames.keys())
for identifier in identifiersSorted:
	if not propertyNames[identifier]:
		print identifier

# Rest flags for searching properties file
for identifier in identifiersSorted:
	propertyNames[identifier] = 0

def keyOfLine(line):
	if '=' in line:
		line = line.strip()
		if line[0] == "#":
			line = line[1:]
		line = line[:line.find("=")]
		line = line.strip()
		return line
	else:
		return None

propsFile = open(propsFileName, "rt")
for propLine in propsFile.readlines():
	if propLine:
		key = keyOfLine(propLine)
		if key:
			if key in propertyNames.keys():
				propertyNames[key] = 1
propsFile.close()

print
print "# Not mentioned in", propsFileName
for identifier in identifiersSorted:
	if not propertyNames[identifier]:
		if "." != identifier[-1:]:
			print identifier

# This is a test to see whether properties are defined in more than one file.
# It doesn't understand the if directive so yields too many false positives to run often.
print
print "# Duplicate mentions"
"""
fileOfProp = {}
notRealProperties = ["abbrev.properties", "SciTE.properties", "Embedded.properties"]
for filename in os.listdir(srcRoot + os.sep + "src"):
	if filename.count(".properties") and filename not in notRealProperties:
		propsFile = open(srcRoot + os.sep + "src" + os.sep + filename, "rt")
		for line in propsFile.readlines():
			if line:
				key = keyOfLine(line)
				if key:
					if fileOfProp.has_key(key):
						print "Clash for", key, fileOfProp[key], filename
					else:
						fileOfProp[key] =filename
		propsFile.close()
"""

propertiesSet = set(propertyNames.keys())
#~ print "# Properties"
#~ print "\n".join(sorted(list(propertiesSet)))

localeFileName = srcRoot + "/win32/locale.properties"
localeSet = set()
for line in file(localeFileName):
	if not line.startswith("#"):
		line = line.strip().strip("=")
		localeSet.add(line.lower())
		
#~ print "# Locale"
#~ print "\n".join(sorted(list(localeSet)))

resourceFileName = srcRoot + "/win32/SciTERes.rc"
resourceSet = set()
for line in file(resourceFileName):
	line = line.strip()
	if "VIRTKEY" not in line and \
		"VALUE" not in line and \
		"1234567" not in line and \
		not line.startswith("BLOCK") and \
		not line.startswith("FONT") and \
		not line.startswith("ICON") and \
		not line.startswith("ID") and \
		"#include" not in line:
		#~ print "::", line
		line = grabQuoted(line)
		if line:
			if '\\t' in line:
				line = line[:line.find('\\t')]
			line = line.replace('&','')
			line = line.replace('...','')
			if len(line) > 2:
				resourceSet.add(line)
		
#~ print "# Resource"
#~ print "\n".join(sorted(list(resourceSet)))

print
print "# Missing localisation of resource"
for l in sorted(resourceSet):
	if l.lower() not in localeSet:
		print l

def present(l, n):
	low = n.lower()
	if low in localeSet:
		return True
	return low.replace("_","").replace("&","") in localeSet

literalStrings = literalStrings.difference(identifiersSorted)
literalStrings = [l for l in list(literalStrings) if not present(localeSet, l)]
#~ print "# Literals", len(literalStrings)
#~ print "\n".join(sorted(literalStrings))

#~ print "##"
#~ print "\n".join(sorted(identifiersSorted))

propsFile = open(propsFileName, "rt")
for propLine in propsFile.readlines():
	if propLine:
		key = keyOfLine(propLine)
		if key:
			if key in propertyNames.keys():
				propertyNames[key] = 1
propsFile.close()

propToFile = {}
for propPath in propertiesPaths:
	base = os.path.basename(propPath)
	base = propPath
	propsFile = open(propPath)
	for propLine in propsFile.readlines():
		if propLine and not propLine.startswith("#"):
			key = keyOfLine(propLine)
			if key:
				if key not in propToFile:
					propToFile[key] = []
				propToFile[key].append(base)
	propsFile.close()

print
print "# Duplicate properties"
for k in sorted(propToFile.keys()):
	files = propToFile[k] 
	if len(files) > 1:
		if files.count(files[0]) < len(files):
			print k, ", ".join(propToFile[k])

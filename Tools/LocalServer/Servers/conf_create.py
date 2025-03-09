#!/usr/bin/env python

import shutil;
import os;

def InputInteger(strTips):
	while True:
		strTemp = raw_input(strTips)
		if strTemp.isdigit():
			return strTemp
		else:
			print("Is not digit")


def SelectGenAudio(strTips):
	while True:
		strSelect = raw_input(strTips)
		if len(strSelect) != 1:
			print("Invalid input")
		else:
			if strSelect == "y" or strSelect == "Y":
				return True
			else:
				return False


def ReplaceInFile(strFilePath, strSrc, strDst):
	file = open(strFilePath, "r+")
	content = file.read()
	new = content.replace(strSrc, strDst)
	file.seek(0)
	file.truncate()
	file.write(new)
	file.close()


print("===============================")

strServerID = InputInteger("Input your server id:")
nLenth = len(strServerID)
strPfx = ""
if nLenth == 1:
	strPfx = "10"
elif nLenth == 2:
	strPfx = "1"


bGenAudio = SelectGenAudio("Create autdio server conf file? [y/n]: ")

print("port prefix: " + strPfx + strServerID + ", create audio conf: " + str(bGenAudio))

if not os.path.exists("conf"):
    os.makedirs("conf")

gs_file = "gs_conf.xml"
ms_file = "ms_conf.xml"
ns_file = "ctrl_conf.xml"
gt_file = "gate_conf.xml"
db_file = "db_conf.xml"
au_file = "audio_conf.xml"
fm_file = "fm_conf.xml"
proxy_file = "proxy_conf.xml"
tr_file = "tr_conf.xml"

shutil.copyfile("conf.template/world/" + gs_file, "conf/" + gs_file)
shutil.copyfile("conf.template/world/" + ms_file, "conf/" + ms_file)
shutil.copyfile("conf.template/world/" + ns_file, "conf/" + ns_file)
shutil.copyfile("conf.template/world/" + gt_file, "conf/" + gt_file)
shutil.copyfile("conf.template/world/" + db_file, "conf/" + db_file)
shutil.copyfile("conf.template/world/" + au_file, "conf/" + au_file)
shutil.copyfile("conf.template/world/" + fm_file, "conf/" + fm_file)
shutil.copyfile("conf.template/world/" + proxy_file, "conf/" + proxy_file)
shutil.copyfile("conf.template/world/" + tr_file, "conf/" + tr_file)

old_svrid  = "id=\"1\""
new_svrid  = "id=\"" + strServerID + "\""

#old_db_name  = "database=\"world\""
#new_db_name  = "database=\"world" + strServerID + "\""

old_port_prefix = "port=\"###"
new_port_prefix = "port=\"" + strPfx + strServerID

old_gate2audio_txt = "<peer ip=\"127.0.0.1\" port=\"21070\" handler=\"audiolink\" sendBufSize=\"1024000\" recvBufSize=\"1024000\"/>"


ReplaceInFile("conf/" + gs_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + ms_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + ns_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + gt_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + db_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + au_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + fm_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + proxy_file, old_svrid, new_svrid)
ReplaceInFile("conf/" + tr_file, old_svrid, new_svrid)

#ReplaceInFile("conf/" + db_file, old_db_name, new_db_name)
#ReplaceInFile("conf/" + ms_file, old_db_name, new_db_name)
#ReplaceInFile("conf/" + ns_file, old_db_name, new_db_name)
#ReplaceInFile("conf/" + gs_file, old_db_name, new_db_name)


if not bGenAudio:
	ReplaceInFile("conf/" + gt_file, old_gate2audio_txt, "")


ReplaceInFile("conf/" + gs_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + ms_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + ns_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + gt_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + db_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + au_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + fm_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + proxy_file, old_port_prefix, new_port_prefix)
ReplaceInFile("conf/" + tr_file, old_port_prefix, new_port_prefix)

print("config successful")
raw_input()

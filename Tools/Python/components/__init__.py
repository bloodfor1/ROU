#components/__init__.py
import os
import sys
import traceback
sys.path.append("..")
import common.act_common_define as common_define
import common.act_common_function as utilFunc
for filename in os.listdir(common_define.TOOL_PATH + "/components"):
	if filename.startswith("ro_step_") and \
		filename.endswith(".py"):
		# __all__.append(filename[:-3])
		cmd = "import " + filename[:-3]
		try:
			exec(cmd)
		except Exception , e:
			utilFunc.log("components/__init__", traceback.format_exc(), True)

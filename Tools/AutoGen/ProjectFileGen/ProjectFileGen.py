#coding=utf-8

import os
import sys
import json
import shutil
import xml
from xml.etree.ElementTree import *

MoonClientCodePath = sys.argv[1]
MoonRoSdkPath = sys.argv[2]

def is_temp(file_path):
    return file_path.find("TemporaryGeneratedFile_") != -1

def Refresh_ProjectFile(project_file_path):
    csfiles = []
    if os.path.exists(project_file_path):
        with open(project_file_path, "r") as f:
            project_file_dir = os.path.dirname(project_file_path)
            for dirpath, dirname, filenames in os.walk(project_file_dir):
                for filename in filenames:
                    if filename[-3:] == ".cs":
                        relative_filename = os.path.join(dirpath, filename).replace(project_file_dir + os.path.sep, "")
                        if not is_temp(filename):
                            csfiles.append(relative_filename.replace('/', '\\'))

        # 修改工程文件
        namespace = "http://schemas.microsoft.com/developer/msbuild/2003"
        xml.etree.ElementTree.register_namespace("", namespace)
        tree = xml.etree.ElementTree.parse(project_file_path)
        root = tree.getroot()
        itemgroups = root.findall("{%s}ItemGroup" % namespace)
        compile_itemgroups = None
        for itemgroup in itemgroups:
            for child in list(itemgroup):
                if child.tag.find("{%s}Compile" % namespace) != -1:
                    compile_itemgroups = itemgroup
                    break
            if compile_itemgroups != None:
                break
        if compile_itemgroups != None:
            for child in list(compile_itemgroups):
                compile_itemgroups.remove(child)
            elements = []
            for csfile in csfiles:
                element = Element('Compile', { 'Include':csfile })
                element.tail ='\n    '
                elements.append(element)
            compile_itemgroups.extend(elements)
        
        tree.write(project_file_path, encoding="utf-8",xml_declaration=True)

Refresh_ProjectFile(os.path.join(MoonClientCodePath, "CSProject/MoonClient/MoonClient.csproj"))
Refresh_ProjectFile(os.path.join(MoonClientCodePath, "CSProject/MoonCommonLib/MoonCommonLib.csproj"))
Refresh_ProjectFile(os.path.join(MoonClientCodePath, "CSProject/MoonSerializable/MoonSerializable.csproj"))
Refresh_ProjectFile(os.path.join(MoonRoSdkPath, "SDKLib/SDKLib.csproj"))
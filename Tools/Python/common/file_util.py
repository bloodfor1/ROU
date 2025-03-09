import os
import json
import sys


def find_file_from_parent(current_path, file_name):
    file_path = os.path.abspath(os.path.join(current_path, file_name))
    has_file = os.path.isfile(file_path)
    if has_file:
        return file_path
    while not has_file:
        if current_path == os.path.abspath(os.path.join(current_path, os.path.pardir)):
            print("cannot find " + file_name + " in " + current_path)
            return None
        current_path = os.path.abspath(os.path.join(current_path, os.path.pardir))
        if not os.path.exists(current_path):
            print("cannot find " + file_name + " in " + current_path)
            return None
        file_path = os.path.join(current_path, file_name)
        has_file = os.path.isfile(file_path)
        if has_file:
            return file_path


def get_sys_env_param(param_name):
    config_path = find_file_from_parent(sys.path[0], "sys_env.json")
    file_obj = open(config_path, "r")
    json_obj = json.load(file_obj)
    return json_obj[param_name]


def get_ab_path():
    return get_sys_env_param("MoonABPath")


def get_gamelib_path():
    return get_sys_env_param("MoonGameLibPath")


def get_server_path():
    return get_sys_env_param("MoonServerPath")


def get_client_project_path():
    return get_sys_env_param("MoonClientProjPath")


def get_client_code_path():
    return get_sys_env_param("MoonClientCodePath")


def get_client_config_path():
    return get_sys_env_param("MoonClientConfigPath")


def get_lua_src_path():
    return os.path.join(get_client_project_path(), "Assets/Scripts/Lua")


def get_lua_proto_path():
    return os.path.join(get_lua_src_path(), "Protobuf")


def get_proto_config_path():
    return os.path.join(get_client_config_path(), "AutoGen/protobuf/lua")


def get_tool_path():
    return os.path.join(get_client_project_path(), "Tools")
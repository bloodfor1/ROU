@echo off

for /R "%3/AutoGen/protobuf/cpp/" %%s in (*) do (
	%1/Tools/Protobuf/protoc.exe %%s --proto_path=%3/AutoGen/protobuf/cpp/ --cpp_out=%2/protocol/pb
)

rem pause
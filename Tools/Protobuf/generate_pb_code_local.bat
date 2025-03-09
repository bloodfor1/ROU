@echo off

SET proto_path=%5


for /R %3 %%s in (*) do (
	%1/Tools/Protobuf/protoc.exe %%s %proto_path:~1,-1% --%4_out=%2
)


rem pause
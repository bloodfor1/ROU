@echo off

for /R "%4/AutoGen/protobuf/cs/" %%s in (*) do (
	%1/Tools/Protobuf/protoc.exe %%s --proto_path=%4/AutoGen/protobuf/cs/ --csharp_out=%3/CSProject/MoonClient/Network/protocol
	copy /y %3/CSProject/MoonClient/Network/protocol %3/ToolsProject/RobotTest/RobotTest/Network/protocol
)


rem pause
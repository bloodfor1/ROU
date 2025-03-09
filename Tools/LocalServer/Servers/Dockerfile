FROM 192.168.6.76:5000/misua/centos7_gcc:latest
COPY start /root
COPY stop /root
COPY start.sh /root
COPY entrypoint.sh /root
ENTRYPOINT ["/root/entrypoint.sh"]

#!/bin/bash
# used some from advanced script to have multiple ports: use an equal number of guest and host ports

echo `date` hook/qemu "${1}" "${2}" >>/root/hook.log


# Update the following variables to fit your setup

### First VM
Guest_name=VM_1_NAME
Guest_ipaddr=VM_1_IP
Host_port=(  '1234' )
Guest_port=( '22' )

length=$(( ${#Host_port[@]} - 1 ))
if [ "${1}" = "${Guest_name}" ]; then
   if [ "${2}" = "stopped" ] || [ "${2}" = "reconnect" ]; then
       for i in `seq 0 $length`; do
            echo "kvm-Ho." >>/root/hook.log
            /sbin/iptables -D FORWARD -o virbr0 -d  ${Guest_ipaddr} -j ACCEPT
            /sbin/iptables -t nat -D PREROUTING -p tcp --dport ${Host_port[$i]} -j DNAT --to ${Guest_ipaddr}:${Guest_port[$i]}
       done
   fi
   if [ "${2}" = "start" ] || [ "${2}" = "reconnect" ]; then
       for i in `seq 0 $length`; do
               echo "kvm-Hey." >>/root/hook.log
            /sbin/iptables -I FORWARD -o virbr0 -d  ${Guest_ipaddr} -j ACCEPT
            /sbin/iptables -t nat -I PREROUTING -p tcp --dport ${Host_port[$i]} -j DNAT --to ${Guest_ipaddr}:${Guest_port[$i]}
       done
   fi
fi

### Second VM
Guest_name=VM_2_NAME
Guest_ipaddr=VM_2_IP
Host_port=(  '7465' )
Guest_port=( '22' )

length=$(( ${#Host_port[@]} - 1 ))
if [ "${1}" = "${Guest_name}" ]; then
   if [ "${2}" = "stopped" ] || [ "${2}" = "reconnect" ]; then
       for i in `seq 0 $length`; do
            echo "kvm-Ho." >>/root/hook.log
            /sbin/iptables -D FORWARD -o virbr0 -d  ${Guest_ipaddr} -j ACCEPT
            /sbin/iptables -t nat -D PREROUTING -p tcp --dport ${Host_port[$i]} -j DNAT --to ${Guest_ipaddr}:${Guest_port[$i]}
       done
   fi
   if [ "${2}" = "start" ] || [ "${2}" = "reconnect" ]; then
       for i in `seq 0 $length`; do
               echo "kvm-Hey." >>/root/hook.log
            /sbin/iptables -I FORWARD -o virbr0 -d  ${Guest_ipaddr} -j ACCEPT
            /sbin/iptables -t nat -I PREROUTING -p tcp --dport ${Host_port[$i]} -j DNAT --to ${Guest_ipaddr}:${Guest_port[$i]}
       done
   fi
fi

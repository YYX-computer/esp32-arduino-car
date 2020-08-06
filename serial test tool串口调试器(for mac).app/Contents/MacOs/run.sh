#!/usr/bin/python
# -*- encoding:utf-8 -*-
import serial
import list_ports
import Tkinter as tk
import time
from multiprocessing import Process
_flag = False
_portname = None
port = None
import tkMessageBox as msg
base = tk.Tk()
base.title('serial test tool串口调试器')
tk.Label(base,text = 'serial test tool').grid(column = 0,row = 0)
tk.Label(base,text = '串口调试器').grid(column = 0,row = 1)
tk.Label(base,text = 'serial number/串口名称').grid(column = 0,row = 2)
entry = tk.Entry(base)
entry.grid(column = 1,row = 2)
END = tk.END
def _submit(ports,val):
	global _portname,_flag
	_portname = ports[val.get()]
	_flag = True
def start_port(entryVal):
	global port
	try:
		port = serial.Serial(entryVal,timeout = 1)
		time.sleep(0.5)
	except:
		port = None
		msg.showerror('unknown port/未知的端口','can\'t connect to the port "%s"/\n无法连接名为"%s"的端口'%(entryVal,entryVal))
tk.Button(base,text = 'connect\连接',command = lambda:start_port(entry.get())).grid(column = 3,row = 2)
tk.Label(base,text = 'output/输出').grid(column = 0,row = 3)
text_out = tk.Text(base)
text_out.grid(column = 0,row = 4)
text_in = tk.Text(base)
tk.Label(base,text = 'input/输入').grid(column = 0,row = 5)
text_in.grid(column = 0,row = 6)
def send_val():
	try:
		port.write(eval("b'%s'"%text_in.get(0.0)))
	except:
		msg.showerror('disconnected/未连接端口','can\'t send message/无法发送消息')
tk.Button(base,text = 'Submit',command = lambda:send_val()).grid(column = 1,row = 6)
def task():
	text_out_text = '[start]'
	text_out.insert(END,text_out_text)
	while(1):
		base.update()
		text_out.delete(0.0,END)
		text_out.insert(END,text_out_text)
		try:
			if(port.isOpen()):
				val = port.read()
				if(val != ''):
					text_out_text += '\n[' + time.asctime() + ']' + val
		except:
			pass
try:
	task()
except:
	pass

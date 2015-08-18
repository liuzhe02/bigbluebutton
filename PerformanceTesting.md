# Introduction #

A few small script files were written to measure the CPU/Memory usage (in percentage) by BigBlueButton server processes (Java, pdftk, pdf2swf, Asterisk, etc.) for a specific period of time. The measurement output are in text/Excel/CSV formats for easy data manipulation. And also some HTML files (data/navigation) are generated for easy access to the current measurement data (and historical measurements) from the web browser.

The server scripts were written in Linux Shell program utilizing existing system functions such as _top_, _ps_, _grep_, _gawk_, etc. The _top_ command is a good built in tool to find CPU/Memory utilizations for Linux. So it is the "engine" of the server scripts.

The clients scripts were written in VBS and Dos batch for Windows, and in Linux Shell for Linux. The clients scripts are mainly providing user friendly testing environment (such as login-free web client loading and multiple clients loading by one command).


# Details #

## Linux Shell scripts - server ##
The logic of the server scripts are as the following:
```
      1. use "ps", to find the process ids (PIDs) for persistent processes by part of their names 
         (i.e., "tomcat" can be input as Apache Tomcat process´ name - the more detailed the better)
      2. run "top" to get CPU/Memory usage data, filtering the results by the PIDs found in step1 and by exact CMD names 
         (i.e., "pdf2swf" is the CMD name for the process to convert PDF to SWF, since it is not a persistent process like tomcat, 
         it has no consistant PID, so its CMD name can be used to identify it) 
      3. the results of the step 2 are processed by another script to get the overall CPU/Memory usage data by the specified processes
      4. pause a specified period of time
      5. repeat 1 - 3 until the user exits or predefined loop times are reached
      6. make conrespondent text, xls, csv and html files
```

The core Linux Shell commands for the above steps are:
```
      1. ps -AF | gawk '/tomcat|activemq-|red5|bigbluebutton|ant-/ {print}' | 
         gawk '!/gawk|findPidByName.sh/ {print}' | gawk '{printf "%d\t%d\t%s\n", $2, $3, $11, $12 >> "ProcessIdsFile"}'
      2. top -b -n 1 -d 1 | gawk '$1 ~ /^11542$|^13591$|^25279$/{print}$12 ~ /^pdftk|^pdf2swf/{print} $1 !~ /^[0-9]/ {print}'
      3. echo -e "Output of step 2 (see below)" | gawk '
                    BEGIN {
                       lineNum=1
                    }
                    /^top/ { lineNum += 1 }
                    /^[0-9]/ {  
                       totalCPU += $9
                       totalMem += $10
                    }
                    END {
                       printf "%d,%f,%f\n", lineNum, totalCPU, totalMem >> outfile
                    } '
      4. sleep 1 (or .500 for 500 ms)
      
      Output of step 2 (top command):
      
         top - 11:40:06 up 38 days, 21:21,  2 users,  load average: 0.02, 0.02, 0.00
         Tasks:  99 total,   1 running,  98 sleeping,   0 stopped,   0 zombie
         Cpu(s):  0.1%us,  0.0%sy,  0.0%ni, 99.8%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
         Mem:   2071216k total,  1591896k used,   479320k free,   304520k buffers
         Swap:  2031608k total,        0k used,  2031608k free,   844584k cached

         PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
         11542 root      22   0  696m 136m  13m S    0  6.7  40:45.94 java
         13591 root      25   0  682m  65m  11m S    0  3.2  22:58.78 java
         25279 root      22   0  227m  77m  10m S    0  3.8   3:43.35 java
         
```

The source code can be downloaded at (performance.tar or tgz or rar):
http://code.google.com/p/bigbluebutton/downloads/list

After downloading, extract all the scripts (usually contained in folder performance). If you want the output to be accessed by web users, extract it into the webapps folder of tomcat server.

The program can be run as (30 times of 1 second interval - about 30 seconds):
```
      sh memcpu.sh 1 30 my_current_test_description 
```

After starting the script, you can quickly start some clients (as described in the following sections). Once you finished the current test session (say, uploaded a PDF file and share it with the connected clients), go to folder performance, view the file performance.html for CPU/Memory usage details.

## A web tool (in JSP mainly) for performance test ##
A web tool has been developed to enable owners to monitor CPU/Memory percentage usage of software components of BigBlueButton. And one format of the result is in Excel with plot (done with open source software JXLS). So owners can just easily get their server's healthiness by just a few button clicks from web browsers. A open source JSP based file browser - jsp File Browser version 1.2 by http://www.vonloesch.de - is used to manage the result files.

Some screen snapshots:

---

http://present.carleton.ca/files/performance/images/MemCpuWeb.JPG
![http://present.carleton.ca/files/performance/images/RawData.jpg](http://present.carleton.ca/files/performance/images/RawData.jpg)
http://present.carleton.ca/files/performance/images/Excel.JPG
http://present.carleton.ca/files/performance/images/browser.JPG

## Linux Shell scripts - client ##
The purpose of the script is to allow users to open several instances (say 20) Login-free BigBlueButton clients in Firefox (or other browsers) at one command under Linux systems.

It can be called as (to open 10 instances of BBB clients in Firefox, in the names of John Doe\_1(ff), John Doe\_2(ff)..., into the conference room 85115 by the password viewpass)
```
      sh bbbcLinux.sh ff 10 -"John Doe, 85115, viewpass" http://www.mycomp.com/BigBlueButton.html

```
The source code can be downloaded at (autoLinux.tar):
http://code.google.com/p/bigbluebutton/downloads/list

## VBS/Dos batch - client ##
The purpose of the scripts is to allow users to open several instances (say 20) Login-free BigBlueButton clients in Firefox (or IE) at one command under Windows systems.

It can be called as (to open 10 instances of BBB clients in Firefox and 10 IE windows, in the names of John Doe\_1(ie), John Doe\_2(ie)..., John Doe\_1(ff), John Doe\_2(ff)..., into the conference room 85115 by the password viewpass)
```
      bbbc ie 10 firefox 10 -"John Doe, 85115, viewpass" http://www.mycomp.com/BigBlueButton.html
```

The source code can be downloaded at (auto.tar or auto.rar):
http://code.google.com/p/bigbluebutton/downloads/list

## Login-free BigBlueButton client ##

A version of Login-free BBB client can be downloaded at (client-auto.tar or client-auto.rar):
http://code.google.com/p/bigbluebutton/downloads/list

You can extract the folder into your web server's folder (i.e., 'webapps' for tomcat), if your web server's IP is 'my.company.com', then you can access the login-free client as 'my.company.com/client-auto/'; and change the methods (getRed5 and getPresentationHost) of BigBlueButton.html to point to the  targeted BigBlueButton server (say 123.456.789.000).

To use login-free clients, as described in the section "VBS/Dos batch - client", just do the following (in Windows):
```
      bbbc ie 10 firefox 10 -"John Doe, 85115, viewpass" [http://www.mycomp.com/client-auto/BigBlueButton.html]
```

## Login-free BigBlueButton client Source ##

Only one MXML file and one HTML file have been modified to enable login free feature. You can download the 2 files from the following (LoginFreeClientSource.rar) and accommodate the changes into your Flex project.
http://code.google.com/p/bigbluebutton/downloads/list
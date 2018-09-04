# xqual.xagent.docker
Contains docker files for XAgent of XQual/XStudio


The dockerfile  (and image) is also available from Docker HUB

In order to build the image 
1. 'cd' to the folder where you clone the content of this repo
2. Copy in this folder the tar of Xtudio for linux (by default, as of this writing this is xstudio_v3_3sp3_linux.tar)
    * if you don't use this name then you need to update the dockerfile where it states 
     `COPY xstudio_v3_3sp3_linux.tar /usr/share/xqual/xstudio.tar`
3. ALso update the dockerfile to copy the Xstudio.conf and plugin.file so that XAgent can find it
    * this is depdendent on your XStudio instance, so I did not provide that part
    `COPY xtudio.Conf /usr/share/xqual/xstudio/xstudio.conf`
    `COPY plugin.Conf /usr/share/xqual/xstudio/plugin.conf`

Note: this is not an official delivery from XQual - don't contact them for direct support

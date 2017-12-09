**Arctic CCM Salt: Report** *by Jori Laine*
===================

## Introduction

Salt**Stack** study is my contribution to the Arctic CCM (centralized configuration management) research and evaluation project.

It consists of several rather basic state files (.sls) of my own creation, that install applications and services to Linux systems as well as Windows OS (due to licensing [Salt Windows repository](https://docs.saltstack.com/en/latest/topics/windows/windows-package-manager.html) is not included, but you’ll find instructions for downloading it in the ["Installation instructions"](https://github.com/joonaleppalahti/CCM/blob/master/salt/Installation%20instructions.md) document). Also, in here you will find my Linux provisioning with PXE configuration files that I used, in order to create multiple minions on which to test my Salt configuration at the Haaga-Helia computer laboratory.

Arctic CCM Salt section was a part of a centralized configuration management research and evaluation project that was done as a part of a Haaga-Helia University of Applied Sciences' course [Monialaprojekti PRO4TN001-3](http://www.haaga-helia.fi/fi/opinto-opas/opintojaksokuvaukset/PRO4TN001) with the intent to learn about the four most popular CCM systems: puppet, Salt, Chef and Ansible.

The documentation covers some of the basic functionalities of Salt and tries to offer some insight to its benefits and attributes.

I made many mistakes during this project and spent a lot of time knocking my head against the wall trying to figure out how to do this or that. This is what my [original Salt report](https://github.com/joonaleppalahti/CCM/blob/master/salt/Origin%20(in%20finnish)/Salt%20raportti.md) (only available in Finnish) reflects and because of this, I decided to rewrite my report, in order to give it more structure and make it easier to read. I can honestly say that I have also had quite a lot of fun working on this project, this being mostly thanks to my amazing friends in the Arctic project workgroup and my family that gave me the time to work on this.

| ![Dia1.PNG](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/Dia1.PNG) | 
|:--:| 
| *My original test environment was a network consisting of four virtual machines.* |


## Table of contents
1. [Introduction](#introduction)

**Arctic CCM Salt: Report** *by Jori Laine*
===================

## Introduction

[Salt**Stack**](https://saltstack.com/) study is my contribution to the Arctic CCM (centralized configuration management) research and evaluation project.

It consists of several rather basic state files (.sls) of my own creation, that install applications and services to Linux systems as well as Windows OS (due to licensing [Salt Windows repository](https://docs.saltstack.com/en/latest/topics/windows/windows-package-manager.html) is not included, but you’ll find instructions for downloading it in the ["Installation instructions"](https://github.com/joonaleppalahti/CCM/blob/master/salt/Installation%20instructions.md) document). Also, in here you will find my Linux provisioning with PXE configuration files that I used, in order to create multiple minions on which to test my Salt configuration at the Haaga-Helia computer laboratory.

Arctic CCM Salt section was a part of a centralized configuration management research and evaluation project that was done as a part of a Haaga-Helia University of Applied Sciences' course [Monialaprojekti PRO4TN001-3](http://www.haaga-helia.fi/fi/opinto-opas/opintojaksokuvaukset/PRO4TN001) with the intent to learn about the four most popular CCM systems: puppet, Salt, Chef and Ansible.

The documentation covers some of the basic functionalities of Salt and tries to offer some insight to its benefits and attributes.

I made many mistakes during this project and spent a lot of time knocking my head against the wall, trying to figure out how to do this or that. This is what my [original Salt report](https://github.com/joonaleppalahti/CCM/blob/master/salt/Origin%20(in%20finnish)/Salt%20raportti.md) (only available in Finnish) reflects and because of this, I decided to rewrite my report, in order to give it more structure and make it easier to read. I can honestly say that I have also had quite a lot of fun working on this project, this being mostly thanks to my amazing friends in the Arctic project workgroup and my family that gave me the time to work on it.

My Salt research has been used and studied for evaluating the benefits of Salt in two projects, coinciding with our own Arctic CCM project:
- A smart mirror ([Kuvastin](https://kuvastinblog.wordpress.com/)) project that being sponsored by the smartphone manufacturer OnePlus.

- The Campfire occupation monitor ([Nuotiovahti](https://raspluonto.wordpress.com/)) project that was conceived as a part of the three years long Virtual Nature development project, that is run by [Lahti University of Applied Sciences](http://www.lamk.fi/english/Sivut/default.aspx)
in partnership with [Haaga-Helia University of Applied Sciences](https://www.haaga-helia.fi/en/frontpage), [University of Eastern Finland](http://www.uef.fi/en/web/mot) and [Karelia University of Applied Sciences](http://www.karelia.fi/en/), with the funding from The European Agricultural Fund for Rural Development (EAFRD).

| ![Dia1.PNG](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/Dia1.PNG) | 
|:--:|
| *My original test environment was a network consisting of four virtual machines.* |


## Table of contents
1. [Introduction](#introduction)
2. [The Beginning](#the-beginning)

## The Beginning

My part in the Arctic CCM begun with the dread and excitement brought by the thought of having to study and learn to use a completely new method of centralized configuration management. I had tried out some puppet before and that was the extent of my experience with these kind of environments.

The Salt documentation had this article ["Salt in 10 minutes"](https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html), which gave me the impression that Salt was going to be easy, but by the time I had my first master and minion functioning and my first test state ready, I had already spent more than 16 hours working on it. With the hindsight I can understand their 10 minute claim, for after getting to know Salt it really does seem possible to do what I did in 10 minutes.

## Salt

Salt is a toolkit above all else, to me it seems that it has a tool for everything that I would think an average system administrator could need in order to manage any network of larger than few devices. It is open-source software with a Enterprise package offering support and additional services. So unless you need support on enterprise scale, the cost of using Salt is time and effort you put in to it.

Salt is by desing a highly modular environment that allows you to pick and chose the parts you need for your network while supporting future needs and growth. According to Salt's devoloper SaltStack, Salt scales well beyond tens of thousands of servers.

I have tested Salt in a environment comprising of both Linux (Ubuntu) and Windows systems on PC and virtual machines as well as in a scenario where some of the minions are beyond the local area network that I had used but in a network only accessable through public internet.

| ![Dia4.PNG](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/Dia4.PNG) | 
|:--:|
| *Environment where some of the minions are located beyond LAN* |

To use Salt it is good to know some programming language. Salt itself uses Python and YAML as well as JSON and Jinja but in my states I only needed YAML and Python, YAML having been totally new to me before this project.

Not only can Salt master manage the devices in your network but also it can be used to monitor and gather information about those devices, that information can for example be disk usage or list of applications currently installed on minion and the version of that application. This date can later be used for targeting specific computer or a group of devices that your master controls with your state modules in your top.sls file (in many ways the top.sls file has the same function in Salt as the site.pp file has in puppet).

## Understanding Salt

With Salt it all starts with the top.sls file that you will have to create in to your Salt directory "/srv/salt/" which is the default directory from where your Salt master will start looking for instructions. For installing Salt and getting started with master-minion structure you can read my instructions [here](https://github.com/joonaleppalahti/CCM/blob/master/salt/Installation%20instructions.md).

| ![Dia8.png](https://github.com/joonaleppalahti/CCM/blob/master/salt/saltimg/Dia8.png) | 
|:--:|
| *Rudimentary top.sls file* |

You can create you own enviroments by adding them


## The End

## Afterword

## What a long strange trip it's been

## Used sources

https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html

https://docs.saltstack.com/en/latest/topics/jinja/index.html

https://en.wikipedia.org/wiki/Salt_(software)

## **To be continued..**

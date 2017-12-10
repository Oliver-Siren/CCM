This is a record of figuring out a problem in my Chef configuration it records the process of the fix but might be hard to apply to your own system. It is still provided to hopefully assist in problem resolution.

I have separate vagrant folders for the same instances of vagrant here. I find working this way easier than trying to make vagrants multimachine run work. Simply placing the files in diferent folders seems to work fine enough.
Vagrant seems to be a bit unstable for hosting the chef server. I can't be certain but it seems that sometimes vagrant dosen't close properly which causes bizarre errors when trying to use the server. These erors have always disappeared upon a fresh install.

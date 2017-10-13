class luser {
user { 'opiskelija':
      ensure  => present,
      password => '$1$SomeSalt$4.JJVvoUTkZesyvyvpkll1',
      home => '/home/opiskelija',
      shell => '/bin/bash',
      managehome => true,
    }
}

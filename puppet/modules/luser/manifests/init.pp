class luser {
user { 'opiskelija':
      ensure  => 'present',
      comment => 'Opiskelija,,,',
      password => '$1$SomeSalt$4.JJVvoUTkZesyvyvpkll1',
      gid => '1001',
      home => '/home/opiskelija',
      shell => '/bin/bash',
      uid => '1001',
    }
}

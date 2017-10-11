class luser
user { 'opiskelija':
      ensure  => 'present',
      comment => 'Opiskelija käyttäjätili,,,',
      password => '$1$SomeSalt$4.JJVvoUTkZesyvyvpkll1',
      shell   => '/bin/bash',
    }
}

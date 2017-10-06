class wuserwall {
    user {'opiskelija':
        name      => 'opiskelija',
        ensure    => present,
        groups    => ['Users'],
        password  => 'salasana',
        managehome => true,
    }
}

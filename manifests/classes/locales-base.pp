/*

==Class: locales::base
Creates shared resources

Do NOT include this class - please refere to init.pp

*/
class locales::base {
  exec {"locale-gen":
    refreshonly => true,
    command => "locale-gen",
    timeout => 30,
  }
}
